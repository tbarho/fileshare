class UsersController < ApplicationController
  before_filter :authenticate, :except => [:new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :signed_in_user, :only => [:new, :create]

  def index
    @title = "Users - Index"
  end

  def show
    @user = User.find(params[:id])
    @title = "Users - Show - #{@user.name}"
  end

  def new
    @user = User.new
    @title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user      
    else
      @title = "Sign up"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end

  def edit
    @title = "Edit user"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "user was updated"
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end


  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
  
    def signed_in_user
      redirect_to(root_path) unless !signed_in?
    end

    def is_self
      @user = User.find(params[:id])
      unless !current_user?(@user)
        flash[:error] = "You can't delete yourself, silly!"
        redirect_to users_path
      end
    end

end
