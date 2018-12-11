class Comment < ApplicationRecord
  belongs_to :user, optional: true

  def self.get_all_json(entity_id, entity_type)
    comments = Comment.where(entity_id: entity_id, entity_type: entity_type).includes(:user)
    comments.map do |c|
      if c.user.nil?
        full_name = ''
      else
        full_name = c.user.full_name
      end

      {
          content: c.content,
          user_name: full_name,
          created_at: c.created_at
      }
    end
  end
end
