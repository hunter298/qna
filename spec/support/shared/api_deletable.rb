shared_examples_for 'API deletable' do
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  before do
    delete api_path, params: { access_token: access_token.token }, headers: headers
  end

  it 'should delete object from db' do
    expect(deletable.to_s.capitalize.constantize.count).to eq 0
  end

  it 'should return 200 status' do
    expect(response.status).to eq 200
  end
end
