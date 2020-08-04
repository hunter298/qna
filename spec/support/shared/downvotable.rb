shared_examples_for 'Downvotable' do
  before do
    login(send(user))
  end

  it 'should decrease object rating by 1' do
    patch :downvote, params: {id: send(other_object)}, format: :json
    send(other_object).reload

    expect(send(other_object).votes.sum(:useful)).to eq -1
  end

  it 'should cancel first vote after second apply' do
    patch :downvote, params: {id: send(other_object)}, format: :json
    patch :downvote, params: {id: send(other_object)}, format: :json
    send(other_object).reload

    expect(send(other_object).votes.sum(:useful)).to eq 0
  end

  it 'should not decrease own question rating' do
    patch :downvote, params: {id: send(own_object)}, format: :json
    send(own_object).reload

    expect(send(own_object).votes.sum(:useful)).to eq 0
  end
end