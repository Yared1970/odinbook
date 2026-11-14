
class PostsController < ApplicationController
def index
  following_ids = current_user.following.pluck(:id)

  @posts = Post.where(
    user_id: following_ids + [ current_user.id ]
  ).where(parent_id: nil)
   .includes(:user)
   .order(created_at: :desc)
end


  def show
    @post = Post.find(params[:id])
    @reply = Post.new
  end
  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to @post, notice: "Post created successfully."
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
