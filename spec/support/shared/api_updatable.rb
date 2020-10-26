shared_examples_for 'API updatable' do
  context 'authorized user' do
    context 'author tries to update' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid data' do
        before do
          do_request :patch, api_path, params: {
            access_token: access_token.token,
            updatable => { body: 'new body' }
          }, headers: headers
        end

        it 'returns 200 status' do
          expect(response.status).to eq 200
        end

        it 'return object' do
          expect(json).to have_key updatable.to_s
        end

        it 'change answer attributes in db' do
          expect(send(updatable).reload.body).to eq 'new body'
        end

        it 'returns associated comments and links' do
          %w[links comments].each do |association|
            expect(json[updatable.to_s]).to have_key association
          end
        end
      end

      context 'with invalid data' do
        before do
          do_request :patch, api_path, params: {
            access_token: access_token.token,
            updatable => { body: '' }
          }, headers: headers
        end

        it 'returns :unprocessable_entity status' do
          expect(response.status).to eq 422
        end

        it 'does not change answer attributes in db' do
          expect(send(updatable).reload.body).to_not eq ''
        end
      end
    end

    context 'not an author' do
      let(:access_token) { create(:access_token, resource_owner_id: create(:user).id) }

      before do
        do_request :patch, api_path, params: {
          access_token: access_token.token,
          updatable => { body: 'new body' }
        }, headers: headers
      end

      it 'returns :forbidden status' do
        expect(response.status).to eq 403
      end

      it 'does not change question attributes in db' do
        expect(send(updatable).reload.body).to_not eq 'new body'
      end
    end
  end
end
