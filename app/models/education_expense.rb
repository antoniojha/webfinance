class EducationExpense < ActiveRecord::Base
  belongs_to :background
  validates :education_cost,numericality:{greater_than: 0.0 },allow_blank: true
end
