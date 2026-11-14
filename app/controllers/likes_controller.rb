
class LikesController < ApplicationController
  before_action :set_post

  def create
    @like = current_user.likes.find_or_initialize_by(post: @post)

    if @like.save
      redirect_to @post, notice: "Post liked successfully."
    else
      redirect_to @post, alert: "Unable to like this post."
    end
  end

  def destroy
    @like = current_user.likes.find_by!(post: @post)
    @like.destroy!

    redirect_to @post, notice: "Like removed successfully."
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
