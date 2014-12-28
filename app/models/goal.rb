class Goal < ActiveRecord::Base
  belongs_to :background
  has_many :goals
end
