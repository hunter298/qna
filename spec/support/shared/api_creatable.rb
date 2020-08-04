shared_examples_for 'API creatable' do
  context 'authorized' do
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    context 'valid data' do
      before do
        post api_path, params: { creatable => {title: 'some title', body: 'some body'}, access_token: access_token.token }, headers: headers
      end

      it 'returns :created status' do
        expect(response.status).to eq 201
      end

      it 'should create new question' do
        expect(creatable.to_s.capitalize.constantize.count).to eq 1
      end

      it 'should return answer public fields' do
        expect(json[creatable.to_s]['body']).to eq 'some body'
        expect(json[creatable.to_s]['user_id']).to eq user.id
        expect(json[creatable.to_s]).to have_key 'created_at'
        expect(json[creatable.to_s]).to have_key 'updated_at'
      end
    end

    context 'invalid data' do
      before do
        post api_path, params: { creatable => {body: nil}, access_token: access_token.token }, headers: headers
      end

      it 'returns 422 status' do
        expect(response.status).to eq 422
      end

      it 'should not create new question' do
        expect(creatable.to_s.capitalize.constantize.count).to eq 0
      end

      it 'should return error message' do
        expect(json['errors']).to include("Body can't be blank")
      end
    end
  end
end