require 'rails_helper'

feature 'Add image to profile', %q{
  In order to add avatar to my pofile
  As a profie owner
  Id like to be able to upload image
} do

  let!(:user) { create :user, email: 'test@test.com', password: '123456' }
  let!(:user2) { create :user, email: 'another@test.com', password: '123456' }
  let(:file) { File.new("#{Rails.root}/spec/fixtures/files/avatar.jpg") }

  scenario "guest tries to upload avatar to another user's profile" do
    visit root_path
    visit user_path(user)

    expect(page).to_not have_content('Загрузить Аватар')
    expect(page).to_not have_button('Загрузить')
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end

  scenario "user tries to upload avatar to another user's profile" do
    visit root_path

    fill_in 'Email', with: 'another@test.com'
    fill_in 'Password', with: "123456"
    click_on 'Log in'
    visit user_path(user)

    expect(page).to_not have_content('Загрузить Аватар')
    expect(page).to_not have_button('Загрузить')
  end

  scenario 'profile owner tries to upload avatar' do
    visit root_path

    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: "123456"
    click_on 'Log in'

    attach_file "user_avatar", file.path
    click_button 'Загрузить'

    expect(page).to have_content("Аватар")
    expect(user.reload.avatar).to be_truthy
  end
end
