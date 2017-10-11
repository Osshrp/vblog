shared_examples_for 'API unauthenticable' do
  context 'unauthenticated' do
    it 'returns 401 status if there is no access_token' do
      request_to_resource method, request_path
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      request_to_resource method, request_path, access_token: '12345'
      expect(response.status).to eq 401
    end
  end
end
