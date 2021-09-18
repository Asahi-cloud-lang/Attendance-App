class AdminsController < ApplicationController
  before_action :set_user, only: [:overtime_approval, :one_month_approval, :attendance_change_approval]
  
  def overtime_approval
  end
  
  def one_month_approval
    @today = Date.today
    @unapprovals = Apply.where( mark: "1" ).group_by(&:user_name)
  end
  
  def update_one_month_approval
    params[:unapprovals].each do |key, value|
      approval = Apply.find_by( user_name: value[:user_name], month: value[:month].to_i )
      approval.mark = value[:mark]
      if approval.save
        flash[:success] = "処理致しました。"
      else
        render :show
      end
    end
    redirect_to user_url
  end
  
  def request_one_month_approval
    @approval = Apply.find_by( user_id: params[:id], month: params[:month].to_i )
    @approval.mark = 1
    @approval.authorizer = params[:authorizer]
    if @approval.save
      flash[:success] = "申請致しました。"
      redirect_to user_url
    else
      render :show
    end
  end
  
  def attendance_change_approval
  end
end
