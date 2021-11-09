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
      @base = Base.find_by( base_id: @user.base_id )
    end
  end
  
  def new
  end
  
  def create
    if params[:base_id]
      @base = Base.find_by( base_id: params[:base_id] )
    end
    if @base.present?
      @user.base_id = params[:base_id]
      @base.base_id = params[:base_id]
      @base.base_name = params[:base_name]
      @base.base_kinds = params[:base_kinds]
      @base.save
    elsif params[:base]
      if @base = Base.find_by( base_id: params[:base][:base_id] )
        @user.base_id = params[:base][:base_id]
        @base.base_id = params[:base][:base_id]
        @base.base_name = params[:base][:base_name]
        @base.base_kinds = params[:base][:base_kinds]
        @base.save
      else
        @base = Base.new
        @user.base_id = params[:base][:base_id]
        @base.base_id = params[:base][:base_id]
        @base.base_name = params[:base][:base_name]
        @base.base_kinds = params[:base][:base_kinds]
        @base.save
      end
    else
      @base = Base.new
      @user.base_id = params[:base_id]
      @base.base_id = params[:base_id]
      @base.base_name = params[:base_name]
      @base.base_kinds = params[:base_kinds]
      @base.save
    end
    if @user.save
      flash[:success] = "拠点情報を更新しました。"
      redirect_to bases_user_path(@user)
    else
      render :edit
    end
  end
  
  def update
    if params[:base_id]
      @base = Base.find_by( base_id: params[:base_id] )
    end
    if @base.present?
      @user.base_id = params[:base_id]
      @base.base_id = params[:base_id]
      @base.base_name = params[:base_name]
      @base.base_kinds = params[:base_kinds]
      @base.save
    elsif params[:base]
      if @base = Base.find_by( base_id: params[:base][:base_id] )
        @user.base_id = params[:base][:base_id]
        @base.base_id = params[:base][:base_id]
        @base.base_name = params[:base][:base_name]
        @base.base_kinds = params[:base][:base_kinds]
        @base.save
      else
        @base = Base.new
        @user.base_id = params[:base][:base_id]
        @base.base_id = params[:base][:base_id]
        @base.base_name = params[:base][:base_name]
        @base.base_kinds = params[:base][:base_kinds]
        @base.save
      end
    else
      @base = Base.new
      @user.base_id = params[:base_id]
      @base.base_id = params[:base_id]
      @base.base_name = params[:base_name]
      @base.base_kinds = params[:base_kinds]
      @base.save
    end
    byebug
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