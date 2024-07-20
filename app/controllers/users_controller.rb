class UsersController < ApplicationController
  def update
    user = User.find_by(id: params[:id])
    return render json: { errors: ['User not found'] }, status: :not_found unless user

    if user.update(users_params)
      render json: { user: user }, status: :ok
    else
      render json: { errors: [user.errors.full_messages.join(', ')] }, status: :unprocessable_entity
    end
  end

  private

  def users_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
