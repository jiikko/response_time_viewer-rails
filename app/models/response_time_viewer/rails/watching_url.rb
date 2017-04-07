module ResponseTimeViewer::Rails
  class WatchingUrl < ApplicationRecord
    has_and_belongs_to_many :watching_url_groups
  end
end
