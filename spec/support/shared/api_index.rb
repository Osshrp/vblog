shared_examples_for 'API indexable' do
  it 'returns 200 status code' do
    expect(response).to be_success
  end

  it 'returns list of resources' do
    expect(response.body).to have_json_size(2).at_path(resources_name)
  end
end
