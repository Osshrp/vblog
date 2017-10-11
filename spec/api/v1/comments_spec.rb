require 'rails_helper'

describe 'Comments API' do
  let(:my_post) { create(:post) }
  describe 'GET /index' do

    it_behaves_like 'API unauthenticable' do
      let(:request_path) { api_v1_post_comments_path(my_post) }
      let(:method) { :get }
    end

    context 'authenticated' do
      let!(:comments) { create_list(:comment, 2, post: my_post) }
      let(:access_token) { create(:access_token) }
      before do
        get api_v1_post_comments_path(my_post),
         as: :json, params: {access_token: access_token.token}
      end

      it_behaves_like 'API indexable' do
        let(:resources_name) { 'comments' }
      end

      %w(id body created_at updated_at).each do |attr|
        it "post object contains #{attr}" do
          expect(response.body).
            to be_json_eql(comments.first.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    let(:comment) { create(:comment, post: my_post) }

    it_behaves_like 'API unauthenticable' do
      let(:request_path) { api_v1_comment_path(comment) }
      let(:method) { :get }
    end

    context 'authenticated' do
      let(:access_token) { create(:access_token) }
      before { get api_v1_comment_path(comment),
        as: :json, params: {access_token: access_token.token} }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "comment object contains #{attr}" do
          expect(response.body).
            to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comment/#{attr}")
        end
      end
    end
  end
  describe 'POST /create' do


    it_behaves_like 'API unauthenticable' do
      let(:request_path) { api_v1_post_comments_path(my_post) }
      let(:method) { :post}
    end

    context 'authenticated' do
      let(:access_token) { create(:access_token) }
      let(:params) {
                      {
                        as: :json, params:
                        {
                          access_token: access_token.token,
                          post_id: my_post,
                          comment: { body: 'Body' }
                        }
                      }
                    }
      it 'returns 201 status' do
        post api_v1_post_comments_path(my_post), params
        expect(response.status).to eq 201
      end

      it 'creates new comment' do
        expect { post api_v1_post_comments_path(my_post), params }
          .to change(my_post.comments, :count).by(1)
      end

      %w(id body created_at updated_at).each do |attr|
        it "comment object contains #{attr}" do
          post api_v1_post_comments_path(my_post), params
          expect(response.body).
            to be_json_eql(Comment.first.send(attr.to_sym).to_json).at_path("comment/#{attr}")
        end
      end

      context 'with invalid attributes' do
        let(:params) {
                        {
                          as: :json, params:
                          {
                            access_token: access_token.token,
                            post_id: my_post,
                            comment: { body: nil }
                          }
                        }
                      }

        it 'returns 422 status' do
          post api_v1_post_comments_path(my_post), params
          expect(response.status).to eq 422
        end

        it 'returns error if body is nil' do
          post api_v1_post_comments_path(my_post), params
          expect(response.body).to be_json_eql("can't be blank".to_json).at_path('errors/body/0/')
        end

        it 'does not create comment in database' do
          expect { post api_v1_post_comments_path(my_post), params }
            .to_not change(my_post.comments, :count)
        end
      end
    end
  end

  def request_to_resource(method, path, options = {})
    send(method, path, as: :json, params: options)
  end
end
