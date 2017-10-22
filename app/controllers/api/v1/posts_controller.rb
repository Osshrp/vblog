class Api::V1::PostsController < Api::V1::BaseController
  set_pagination_headers :posts, only: :index

  def index
    @posts = Post.paginate(page: params[:page], per_page: params[:per_page])
      .desc_order
    respond_with(:api, :v1, @posts, each_serializer: PostSerializer)
  end

  def show
    @post = Post.find(params[:id])
    respond_with(:api, :v1, @post, serializer: PostSerializer)
  end

  def create
    post_params[:published_at] ||= Time.zone.now
    @post = Post.create(post_params.merge(user: current_resource_owner))
    respond_with(:api, :v1, @post, serializer: PostSerializer)
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :published_at)
  end
end
