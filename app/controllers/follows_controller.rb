
class FollowsController < ApplicationController
  before_action :set_user

  def create
    follow = current_user.active_follows.find_or_initialize_by(
      followed: @user
    )

    if follow.save
      redirect_to @user, notice: "User followed successfully."
    else
      redirect_to @user, alert: follow.errors.full_messages.to_sentence
    end
  end

  def destroy
    follow = current_user.active_follows.find_by!(followed: @user)
    follow.destroy!

    redirect_to @user, notice: "User unfollowed successfully."
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
