shared_examples_for 'API editable' do
  context 'authorized' do
    context 'author of object' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before do
        do_request :get, api_path, params: {access_token: access_token.token}, headers: headers
      end

      it 'returns 200 status' do
        expect(response.status).to eq 200
      end

      it 'return object' do
        expect(json).to have_key editable.to_s
      end

      it 'returns associated comments and links' do
        %w[links comments].each do |association|
          expect(json[editable.to_s]).to have_key association
        end
      end
    end

    context 'not an author of object' do
      let(:access_token) { create(:access_token, resource_owner_id: create(:user).id) }

      before do
        do_request :get, api_path, params: {access_token: access_token.token}, headers: headers
      end

      it 'should return 403 status' do
        expect(response.status).to eq 403
      end
    end

    context 'admin' do
      let(:access_token) { create(:access_token, resource_owner_id: create(:user, admin: true).id) }

      before do
        do_request :get, api_path, params: {access_token: access_token.token}, headers: headers
      end

      it 'returns 200 status' do
        expect(response.status).to eq 200
      end

      it 'return answer' do
        expect(json).to have_key editable.to_s
      end

      it 'returns associated comments and links' do
        %w[links comments].each do |association|
          expect(json[editable.to_s]).to have_key association
        end
      end
    end
  end
end