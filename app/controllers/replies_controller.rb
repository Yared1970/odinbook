
class RepliesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])

    @reply = current_user.posts.build(reply_params)
    @reply.parent = @post

    if @reply.save
      redirect_to @post, notice: "Reply posted successfully."
    else
      render "posts/show", status: :unprocessable_content
    end
  end

  private

  def reply_params
    params.require(:post).permit(:content)
  end
end
