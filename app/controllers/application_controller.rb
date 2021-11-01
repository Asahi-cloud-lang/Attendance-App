class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  $days_of_the_week = %w{日 月 火 水 木 金 土}

  # beforフィルター

  # paramsハッシュからユーザーを取得します。
  def set_user
    @user = User.find(params[:id])
  end

  # ログイン済みのユーザーか確認します。
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end

  # アクセスしたユーザーが現在ログインしているユーザーか確認します。
  def correct_user
    redirect_to(root_url) unless current_user?(@user) || current_user.admin?
  end

  # 上長かどうか判定します。
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
  
  # システム管理権限所有かどうか判定します。
  def superior_user
    redirect_to root_url unless current_user.superior?
  end

  # ページ出力前に1ヶ月分のデータの存在を確認・セットします。
  def set_one_month 
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day] # 対象の月の日数を代入します。
    # ユーザーに紐付く一ヶ月分のレコードを検索し取得します。
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)

    unless one_month.count == @attendances.count # それぞれの件数（日数）が一致するか評価します。
      ActiveRecord::Base.transaction do # トランザクションを開始します。
        # 繰り返し処理により、1ヶ月分の勤怠データを生成します。
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end

  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end
  
  # 本日の勤怠情報を取得
  def set_worked_state
    @attendances.each do |day|
      if Date.current == day.worked_on
        if day.started_at.present? && day.finished_at.nil?
          @today_worked_state = day
          @state = "出社中"
        else
          @today_worked_state = day
          @state = "退社済"
        end
      end
    end
  end
  
  # 勤怠承認データ作成
  def set_approval
    @approval = Apply.find_by( user_id: params[:id], month: @first_day.month )
    if @approval == nil
      @approval = Apply.new
      @approval.mark = 0
      @approval.month = @first_day.month
      @approval.user_id = params[:id]
      @approval.user_name = @user.name
      @approval.save
    end
    @unapprovals = Apply.where(mark: 1)
  end
end