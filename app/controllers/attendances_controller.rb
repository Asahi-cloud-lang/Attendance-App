class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month, :overtime, :approval_log, :overtime_log, :destroy_approval_log]
  before_action :logged_in_user, only: [:update, :edit_one_month, :overtime]
  before_action :set_one_month, only: [:edit_one_month, :overtime]
  before_action :correct_user, only: [:edit_one_month, :update_one_month, :update_one_month, :update_overtime]

  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      @attendance.started_at = Time.current.change(sec: 0)
      if @attendance.save(:validate => false)
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end

  def edit_one_month
  end
  
  def update_one_month
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        if item[:started_at].present? && item[:finished_at].present?
          attendance.update_attributes!(changed_started_at: item[:started_at])
          attendance.update_attributes!(changed_finished_at: item[:finished_at])
          attendance.update_attributes!(change_approval: 1)
        end
        # 出勤時間と退勤時間が入力されている場合
        if attendance.started_at.present? && attendance.finished_at.present?
          # 事前に変更前の出勤情報、退勤情報を移動
          attendance.changed_started_at = attendance.started_at
          attendance.changed_finished_at = attendance.finished_at

          # paramsの出勤情報、退勤情報を元にデータ更新
          attendance.update_attributes!(item)
          # 勤務情報と変更後勤務情報に差分があったら更新
          if attendance.changed_started_at != attendance.started_at || attendance.changed_finished_at != attendance.finished_at
            attendance.update_attributes!(changed_started_at: attendance.changed_started_at)
            attendance.update_attributes!(changed_finished_at: attendance.changed_finished_at)
            attendance.update_attributes!(change_approval: 1)
          end
        else
          # paramsの出勤情報、退勤情報を元にデータ更新(change_approval等は更新しない)
          attendance.update_attributes!(item)
        end
      end
    end
    flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
  
  def update_overtime
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      overtimes_params.each do |id, item|
        attendance = Attendance.find(id)
        if item[:check_box] == "on"
          attendance.update_attributes!(item)
          attendance.update_attributes!(overtime_approval: 1)
          # すでにlogがある場合
          if approval_log = History.find_by( log_worked_on: item[:worked_on], user_id: item[:user_id] )
            approval_log.log_scheduled_end_time = item[:scheduled_end_time]
            approval_log.approval_authorizer = item[:approval_authorizer]
            approval_log.overtime_approval = 1
            approval_log.overtime_note = item[:overtime_note]
            approval_log.user_id = item[:user_id]
            approval_log.save
          # ログがない場合は新規作成
          else
            approval_log = History.new
            approval_log.log_worked_on = item[:worked_on]
            approval_log.user_id = item[:user_id]
            approval_log.approval_authorizer = item[:approval_authorizer]
            approval_log.log_scheduled_end_time = item[:scheduled_end_time]
            approval_log.overtime_approval = 1
            approval_log.overtime_note = item[:overtime_note]
            approval_log.user_id = item[:user_id]
            approval_log.save
          end
          flash[:success] = "残業申請しました。"
        end
      end
    end
    redirect_to user_url(date: params[:date])
  end  
  
  def overtime
    @day = params[:format].to_date
  end
  
  # 勤怠修正ログ収集
  def approval_log
    @today = Date.today
    @year = @today.year
    @prev_year = @today.prev_year.year
    @next_year = @today.next_year.year
    @approval_logs = History.where( user_id: params[:id] )

    # 絞り込み検索機能
    # 年月で絞り込みをかけた時
    if params[:year] && params[:month]
      year = params[:year]
      month = params[:month]
      if month.to_i < 10
        @approval_logs = History.where( user_id: params[:id] ).where("log_worked_on LIKE ?", "%#{year}%").where("log_worked_on LIKE ?", "%0#{month}-%")
      else
        @approval_logs = History.where( user_id: params[:id] ).where("log_worked_on LIKE ?", "%#{year}%").where("log_worked_on LIKE ?", "%#{month}-%")
      end
    end
    # 年で絞り込みをかけた時
    if params[:year].present?
      unless params[:month].present?
        year = params[:year]
        @approval_logs = History.where( user_id: params[:id] ).where("log_worked_on LIKE ?", "%#{year}%")
      end
    # 月で絞り込みをかけた時
    elsif params[:month].present?
      unless params[:year].present?
        month = params[:month]
        if month.to_i < 10
          @approval_logs = History.where( user_id: params[:id] ).where("log_worked_on LIKE ?", "%#{@year}%").where("log_worked_on LIKE ?", "%0#{month}-%")
        else
          @approval_logs = History.where( user_id: params[:id] ).where("log_worked_on LIKE ?", "%#{@year}%").where("log_worked_on LIKE ?", "%#{month}-%")
        end
      end
    end
  end
  
  # 残業申請ログ収集
  def overtime_log
    @today = Date.today
    @year = @today.year
    @prev_year = @today.prev_year.year
    @next_year = @today.next_year.year
    @overtime_logs = History.where( user_id: params[:id] )

    # 絞り込み検索機能
    # 年月で絞り込みをかけた時
    if params[:year] && params[:month]
      year = params[:year]
      month = params[:month]
      if month.to_i < 10
        @overtime_logs = History.where( user_id: params[:id] ).where("log_worked_on LIKE ?", "%#{year}%").where("log_worked_on LIKE ?", "%0#{month}-%")
      else
        @overtime_logs = History.where( user_id: params[:id] ).where("log_worked_on LIKE ?", "%#{year}%").where("log_worked_on LIKE ?", "%#{month}-%")
      end
    end
    # 年で絞り込みをかけた時
    if params[:year].present?
      unless params[:month].present?
        year = params[:year]
        @overtime_logs = History.where( user_id: params[:id] ).where("log_worked_on LIKE ?", "%#{year}%")
      end
    # 月で絞り込みをかけた時
    elsif params[:month].present?
      unless params[:year].present?
        month = params[:month]
        if month.to_i < 10
          @overtime_logs = History.where( user_id: params[:id] ).where("log_worked_on LIKE ?", "%#{@year}%").where("log_worked_on LIKE ?", "%0#{month}-%")
        else
          @overtime_logs = History.where( user_id: params[:id] ).where("log_worked_on LIKE ?", "%#{@year}%").where("log_worked_on LIKE ?", "%#{month}-%")
        end
      end
    end
  end
  
  # ログ削除
  def destroy_approval_log
    @approval_logs = History.where( user_id: params[:id] )
    @approval_logs.destroy_all
    flash[:success] = "#{@user.name}のログを削除しました。"
    redirect_to user_url(@user)
  end

  private
    # 1ヶ月分の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note, :approval_authorizer])[:attendances]
    end
    
    # 残業の勤怠情報を扱います。
    def overtimes_params
      params.require(:user).permit(attendances: [:scheduled_end_time, :note, :approval_authorizer, :overtime_approval, :check_box, :user_id, :worked_on, :overtime_note])[:attendances]
    end
end