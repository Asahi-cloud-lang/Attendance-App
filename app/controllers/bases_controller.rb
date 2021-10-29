class BasesController < ApplicationController
  before_action :set_user, only: [:show, :edit, :new, :create, :update, :destroy]
  before_action :set_one_month, only: :show
  before_action :set_worked_state, only: :show
  
  def show
    @user = User.find( params[:id] )
    @base = Base.find_by( base_id: @user.base_id )
  end
  
  def edit
    if @user.base_id
      @base = Base.find( @user.base_id )
    end
  end
  
  def new
  end
  
  def create
    @base = Base.new
    @base.base_id = params[:base][:base_id]
    @base.base_name = params[:base][:base_name]
    @base.base_kinds = params[:base][:base_kinds]
    if @base.save
      flash[:success] = "拠点情報を更新しました。"
      redirect_to bases_user_path(@user)
    else
      render :edit
    end
  end
  
  def update
    @base = Base.find_by( base_id: params[:base][:base_id] )
    if @base
      @base.base_name = params[:base][:base_name]
      @base.base_kinds = params[:base][:base_kinds]
      @base.save
    else
      @base = Base.new
      @base.base_id = params[:base][:base_id]
      @base.base_name = params[:base][:base_name]
      @base.base_kinds = params[:base][:base_kinds]
      @base.save
    end
    
    @user.base_id = params[:base][:base_id]
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