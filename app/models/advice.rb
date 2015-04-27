class Advice < ActiveRecord::Base
  belongs_to :question
  belongs_to :broker
  belongs_to :advice_category
end
