class AdminsController < ApplicationController
  before_action :set_user, only: [:overtime_approval, :one_month_approval, :attendance_change_approval]
  
  def overtime_approval
    @today = Date.today
    @overtime_unapprovals = Attendance.where( overtime_approval: "1" ).where( approval_authorizer: params[:id] ).group_by(&:user_id)
  end
  
  def one_month_approval
    @today = Date.today
    @unapprovals = Apply.where( mark: "1" ).group_by(&:user_name)
  end
  
  def edit_one_month_approval
    @today = Date.today
    @change_unapprovals = Attendance.where( change_approval: "1" ).where( approval_authorizer: params[:id] ).group_by(&:user_id)
  end

  def update_edit_one_month_approval
    params[:change_unapprovals].each do |key, value|
      if value[:check_box] == "1"
        approval = Attendance.find_by( worked_on: value[:worked_on], user_id: value[:user_id] )
        approval.change_approval = value[:change_approval]
      
        # 勤怠ログにも情報を保存
      
        # 勤怠編集が承認 or 否認された場合
        if value[:change_approval] = 2 || value[:change_approval] = 3
          # すでにlogがある場合
          if approval_log = History.find_by( log_worked_on: value[:worked_on], user_id: value[:user_id] )
            approval_log.log_started_at = value[:started_at]
            approval_log.log_finished_at = value[:finished_at]
            approval_log.log_changed_started_at = value[:changed_started_at]
            approval_log.log_changed_finished_at = value[:changed_finished_at]
            approval_log.approval_authorizer = value[:approval_authorizer]
            approval_log.save
          # ログがない場合は新規作成
          else
            approval_log = History.new
            approval_log.log_worked_on = value[:worked_on]
            approval_log.user_id = value[:user_id]
            approval_log.log_started_at = value[:started_at]
            approval_log.log_finished_at = value[:finished_at]
            approval_log.log_changed_started_at = value[:changed_started_at]
            approval_log.log_changed_finished_at = value[:changed_finished_at]
            approval_log.approval_authorizer = value[:approval_authorizer]
            approval_log.save
          end
        end
      
        if approval.save
          flash[:success] = "処理致しました。"
        else
          render :show
        end
      end
    end
    redirect_to user_url
  end

  def update_overtime_approval
    params[:overtime_unapprovals].each do |key, value|
      if value[:check_box] == "1"
        approval = Attendance.find_by( worked_on: value[:worked_on], user_id: value[:user_id] )
        approval.overtime_approval = value[:overtime_approval]
        # 残業ログにも情報を保存
      
        # 残業申請が承認 or 否認された場合
        if value[:overtime_approval] = 2 || value[:overtime_approval] = 3
          # すでにlogがある場合
          if approval_log = History.find_by( log_worked_on: value[:worked_on], user_id: value[:user_id] )
            approval_log.log_scheduled_end_time = value[:scheduled_end_time]
            approval_log.approval_authorizer = value[:approval_authorizer]
            approval_log.overtime_approval = approval.overtime_approval
            approval_log.overtime_note = value[:overtime_note]
            approval_log.user_id = value[:user_id]
            approval_log.save
          # ログがない場合は新規作成
          else
            approval_log = History.new
            approval_log.log_worked_on = value[:worked_on]
            approval_log.user_id = value[:user_id]
            approval_log.approval_authorizer = value[:approval_authorizer]
            approval_log.log_scheduled_end_time = value[:scheduled_end_time]
            approval_log.overtime_approval = approval.overtime_approval
            approval_log.overtime_note = value[:overtime_note]
            approval_log.user_id = value[:user_id]
            approval_log.save
          end
        end

        if approval.save
          flash[:success] = "処理致しました。"
        else
          render :show
        end
      end
    end
    redirect_to user_url
  end
  
  def update_one_month_approval
    params[:unapprovals].each do |key, value|
      if value[:check_box] == "1"
        approval = Apply.find_by( user_name: value[:user_name], month: value[:month].to_i )
        approval.mark = value[:mark]
        if approval.save
          flash[:success] = "処理致しました。"
        else
          render :show
        end
      end
    end
    redirect_to user_url
  end
  
  def request_one_month_approval
    @approval = Apply.find_by( user_id: params[:id], month: params[:month].to_i )
    @approval.mark = 1
    @approval.authorizer = params[:approval_authorizer]
    if @approval.save
      flash[:success] = "申請致しました。"
      redirect_to user_url
    else
      render :show
    end
  end
end
