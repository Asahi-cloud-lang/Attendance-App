class BasesController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_one_month, only: :show
  before_action :set_worked_state, only: :show
  
  def show
    @user = User.find( params[:id] )
    @base = Base.find_by( id: @user.base_id )
  end
  
  def edit
     if @user.base_id != nil
      @base = Base.find( @user.base_id )
    else
      @base = Base.find(1)
    end
    @bases = Base.all
  end
  
  def update
    @user.base_id = params[:base_id]
    if @user.save
      flash[:success] = "拠点情報を更新しました。"
      redirect_to bases_user_path(@user)
    else
      render :edit
    end
  end
  
  def destroy
    @user.base_id = ""
    @user.save
    flash[:success] = "#拠点情報を削除しました。"
    redirect_to bases_user_path(@user)
  end
end