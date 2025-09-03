# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :restrict_to_admin
  before_action :find_user, only: %i[destroy edit update]

  def index
    @users = User.all
  end

  def edit; end

  def create
    @user = User.new user_params
    if @user.save
      flash[:notice] = t('.success')
      redirect_to users_path
    else
      flash[:errors] = @user.errors.full_messages
      render 'edit', status: :unprocessable_content
    end
  end

  def update
    @user.assign_attributes user_params
    if @user.save
      flash[:notice] = t('.success')
      redirect_to users_path
    else
      flash[:errors] = @user.errors.full_messages
      render 'edit', status: :unprocessable_content
    end
  end

  def destroy
    @user.destroy!
    flash[:notice] = t('.success')
    redirect_to users_path
  end

  private

  def find_user
    @user = User.find_by id: params.require(:id)
    render nothing: true, status: :not_found and return if @user.blank?
  end

  def user_params
    params.expect(user: %i[name email password password_confirmation admin]).tap do |p|
      if p[:password].blank?
        p.delete :password
        p.delete :password_confirmation
      end
    end
  end
end
