require 'csv'

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: :show
  before_action :set_approval, only: :show

  def index
    @users = User.paginate(page: params[:page])
  end
  
  def commuting_index
    @users = User.all.includes(:attendances)
  end

  def show
    # 承認に関する処理(管理者用)
    @approval = Apply.where( authorizer: @user.id, mark: 1, month: @first_day.month ).first
    @unapprovals = Apply.where(mark: 1).where(authorizer: params[:id])
    @change_unapprovals = Attendance.where(change_approval: 1).where(approval_authorizer: params[:id])
    @overtime_unapprovals = Attendance.where(overtime_approval: 1).where(approval_authorizer: params[:id])
    
    # 承認ログ（ユーザー用）
    @approval_logs = History.where( user_id: params[:id] )
    
    # 勤怠に関する処理
    @worked_sum = @attendances.where.not(started_at: nil).count
    respond_to do |format|
      format.html
      format.csv do
        send_posts_csv(@attendances)
      end
    end
  end
  
  def send_posts_csv(attendances)
    csv_data = CSV.generate do |csv|
      header = %w(worked_on started_at finished_at note)
      csv << header

      attendances.each do |day|
        values = [day.worked_on,day.started_at,day.finished_at,day.note]
        csv << values
      end

    end
    send_data(csv_data, filename: "attendances.csv")
  end


  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit      
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end

  def edit_basic_info
  end

  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  def import
    User.import(params[:file])
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :uid, :password, :password_confirmation)
    end

    def basic_info_params
      params.require(:user).permit(:affiliation, :basic_time, :work_time)
    end
end