class GistService

  def initialize(gist_url, client = default_client)
    @client = client
    @gist_id = gist_url.match(/\w+$/).to_s
  end

  def call
    @client.gist(@gist_id).files.first.last[:content]
  end

  private

  def default_client
    Octokit::Client.new(access_token: ENV['ACCESS_TOKEN'])
  end
end