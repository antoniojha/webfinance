class ApplicationComment < ActiveRecord::Base
  has_many :application_comment_relations
  has_many :brokers, through: :application_comment_relations
  validates :comment, presence: true
  def associate_broker(broker)
    unless broker.status=="accepted"
      application_comment_relations.create(broker_id: broker.id)
    end
  end
end