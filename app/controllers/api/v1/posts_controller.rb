class Api::V1::PostsController < Api::V1::BaseController
  def index
    @posts = Post.all
    respond_with(:api, :v1, @posts, each_serializer: PostsListSerializer)
  end

  def show
    @post = Post.find(params[:id])
    respond_with(:api, :v1, @post, serializer: SinglePostSerializer)
  end

  def create
    @post = Post.create(post_params)
    respond_with(:api, :v1, @post, serializer: SinglePostSerializer)
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :published_at)
  end
end
