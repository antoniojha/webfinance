class Activity < ActiveRecord::Base
  belongs_to :author, polymorphic:true
  belongs_to :trackable, polymorphic:true
  belongs_to :story_owner, polymorphic:true
  
end
