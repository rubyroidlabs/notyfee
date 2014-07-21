class Payment < ActiveRecord::Base
  belongs_to :notification
end
