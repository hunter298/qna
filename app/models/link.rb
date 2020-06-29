class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: true

  def is_gist?
    url =~ /gist.github.com/
  end

  def gist
    GistService.new(url).call
  end
end
