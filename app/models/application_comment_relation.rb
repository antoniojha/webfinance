class ApplicationCommentRelation < ActiveRecord::Base
  belongs_to :broker
  belongs_to :application_comment
end
