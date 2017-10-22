require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #show' do
    context 'unauthenticated user tries to see user profile' do
      before { get :show, params: { id: user } }

      it 'does not assign requested user to user' do
        expect(assigns(:user)).to_not eq user
      end

      it 'redirects to new session view' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'authenticate user tries to see profile of another user' do
      sign_in_user
      before { get :show, params: { id: user } }

      it 'assigns requested user to user' do
        expect(assigns(:user)).to eq user
      end

      it 'renders show view' do
        expect(response).to render_template :show
      end
    end
  end


  describe 'PATCH #update' do
    context 'unauthenticated user tries to update user profile' do
      before { patch :update, params: { id: user,
        user: { avatar: fixture_file_upload('files/avatar.jpg', 'image/jpg')} } }

      it 'does not upload file' do
        expect(user.avatar.file).to be_nil
      end

      it 'redirects to new session path' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "authenticated user tries to update another user's avatar" do
      sign_in_user
      before { patch :update, params: { id: user,
        user: { avatar: fixture_file_upload('files/avatar.jpg', 'image/jpg')} } }

      it 'does not upload file' do
        expect(user.avatar.file).to be_nil
      end

      it 'renders show view' do
        expect(response).to render_template :show
      end
    end

    context 'Profile owner tries to upload avatar' do
      sign_in_user
      before { patch :update, params: { id: @user,
        user: { avatar: fixture_file_upload('files/avatar.jpg', 'image/jpg')} } }

      it 'uploads file' do
        @user.reload
        expect(@user.avatar.file.path).to_not be_nil
      end

      it 'renders show view' do
        expect(response).to render_template :show
      end
    end
  end
end
