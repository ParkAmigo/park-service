class UsersController < ApplicationController
  def update
    unless current_user.id.to_s == params[:id]
      return render json: { error: t('json_errors.unauthorized') },
                    status: :unauthorized
    end

    if current_user.update(users_params)
      render json: { data: { user: current_user } }, status: :ok
    else
      render json: { errors: [current_user.errors.full_messages.to_sentence] }, status: :unprocessable_entity
    end
  end

  private

  def users_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
