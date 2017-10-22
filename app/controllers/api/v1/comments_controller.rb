class Api::V1::CommentsController < Api::V1::BaseController
  before_action :set_post, only: [:index, :create]

  def index
    @comments = @post.comments
    respond_with(:api, :v1, @comments, each_serializer: CommentSerializer)
  end

  def show
    @comment = Comment.find(params[:id])
    respond_with(:api, :v1, @comment, serializer: CommentSerializer)
  end

  def create
    @comment = @post.comments.create(comment_params.merge(user: current_resource_owner))
    respond_with(:api, :v1, @comment, serializer: CommentSerializer)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_post
    @post = Post.find(params[:post_id])
  end
end
