require 'rails_helper'

describe 'Posts API' do
  describe 'GET /index' do

    it_behaves_like 'API unauthenticable' do
      let(:request_path) { '/api/v1/posts' }
      let(:method) { :get }
    end

    context 'authenticated' do
      let(:access_token) { create(:access_token) }
      let!(:posts) { create_list(:post, 2) }
      let(:my_post) { posts.first }
      let!(:comment) { create(:comment, post: my_post) }

      before { get '/api/v1/posts', as: :json, params: {access_token: access_token.token} }

      it_behaves_like 'API indexable' do
        let(:resources_name) { 'posts' }
      end

      %w(id title body created_at updated_at).each do |attr|
        it "post object contains #{attr}" do
          expect(response.body).
            to be_json_eql(my_post.send(attr.to_sym).to_json).at_path("posts/0/#{attr}")
        end
      end

      it 'post object contains short_title' do
        expect(response.body).
          to be_json_eql(my_post.title.truncate(10).to_json).at_path("posts/0/short_title")
      end

      context 'comments' do
        it 'included in post object' do
          expect(response.body).to have_json_size(1).at_path("posts/0/comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json)
              .at_path("posts/0/comments/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET /show' do
    let(:my_post) { create(:post) }

    it_behaves_like 'API unauthenticable' do
      let(:request_path) { api_v1_post_path(my_post) }
      let(:method) { :get }
    end

    context 'authenticated' do
      let(:access_token) { create(:access_token) }
      before do
        file = File.open("#{Rails.root}/spec/spec_helper.rb")
        my_post.attachments.create(file: file)
      end
      before { get api_v1_post_path(my_post), as: :json, params: {access_token: access_token.token} }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at rating).each do |attr|
        it "post object contains #{attr}" do
          expect(response.body).
            to be_json_eql(my_post.send(attr.to_sym).to_json).at_path("post/#{attr}")
        end
      end

      context 'posts' do
        it 'included in post object' do
          expect(response.body).to have_json_size(1).at_path("post/posts")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).
              to be_json_eql(my_post.send(attr.to_sym).to_json).
                at_path("post/posts/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API unauthenticable' do
      let(:request_path) { api_v1_posts_path }
      let(:method) { :post }
    end

    context 'authenticated' do
      let(:access_token) { create(:access_token) }
      let(:params) {
                      {
                        as: :json, params:
                        {
                          access_token: access_token.token,
                          post: { title: 'Title', body: 'Body' }
                        }
                      }
                    }
      it 'returns 201 status' do
        post api_v1_posts_path, params
        expect(response.status).to eq 201
      end

      it 'creates new post' do
        expect { post api_v1_posts_path, params }.to change(Post.all, :count).by(1)
      end

      %w(id title body created_at updated_at rating).each do |attr|
        it "post object contains #{attr}" do
          post api_v1_posts_path, params
          expect(response.body).
            to be_json_eql(Post.first.send(attr.to_sym).to_json).at_path("post/#{attr}")
        end
      end

      context 'with invalid attributes' do
        let(:params) {
                        {
                          as: :json, params:
                          {
                            access_token: access_token.token,
                            post: { title: nil, body: 'Body' }
                          }
                        }
                      }

        it 'returns 422 status' do
          post api_v1_posts_path, params
          expect(response.status).to eq 422
        end

        it 'returns error when title is nil' do
          post api_v1_posts_path, params
          expect(response.body).to be_json_eql("can't be blank".to_json).at_path('errors/title/0/')
        end

        it 'returns error when body is nil' do
          post api_v1_posts_path, as: :json, params: {
                                                        access_token: access_token.token,
                                                        post: { title: 'Title', body: nil }
                                                      }
          expect(response.body).to be_json_eql("can't be blank".to_json).at_path('errors/body/0/')
        end

        it 'does not create post in database' do
          expect { post api_v1_posts_path, params }.to_not change(Post.all, :count)
        end
      end
    end
  end

  def request_to_resource(method, path, options = {})
    send(method, path, as: :json, params: options)
  end
end
