module ResponseTimeViewer::Rails
  class WatchingUrlGroup < ApplicationRecord
    has_and_belongs_to_many :watching_urls
  end
end
