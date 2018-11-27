class Comment < ApplicationRecord
  belongs_to :user

  def self.get_all_json(entity_id, entity_type)
    comments = Comment.where(entity_id: entity_id, entity_type: entity_type).includes(:user)
    comments.map do |c|
      {
          content: c.content,
          user_name: c.user.full_name,
          created_at: c.created_at
      }
    end
  end
end
