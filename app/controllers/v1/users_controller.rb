class V1::UsersController < ApplicationController

  def index
    users = User.all
    render json: users.as_json
  end

  def show
    user = User.find_by(:id)
    render json: user.as_json
  end

  
  def create
    user = User.new(
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )

    if user.save
      render json: {message: "User Successfully Created!"}, status: :created
    else
      render json: {errors: user.errors.full_messages}, status: :bad_request
    end
  end

end
