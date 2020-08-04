shared_examples_for 'Upvotable' do
  before do
    login(send(user))
  end

  it 'should increase question rating by 1' do
    patch :upvote, params: { id: send(foreign_object) }, format: :json
    send(foreign_object).reload

    expect(send(foreign_object).votes.sum(:useful)).to eq 1
  end

  it 'should cancel first vote after second apply' do
    patch :upvote, params: {id: send(foreign_object)}, format: :json
    patch :upvote, params: {id: send(foreign_object)}, format: :json
    send(foreign_object).reload

    expect(send(foreign_object).votes.sum(:useful)).to eq 0
  end

  it 'should not increase own question rating' do
    patch :upvote, params: {id: send(own_object)}, format: :json
    send(own_object).reload

    expect(send(own_object).votes.sum(:useful)).to eq 0
  end
end