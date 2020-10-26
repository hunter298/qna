class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true, touch: true

  validates :name, :url, presence: true
  validates :url, url: true

  def gist?
    url =~ /gist.github.com/
  end

  def gist
    GistService.new(url).call
  end
end
