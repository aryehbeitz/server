class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable , :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable, :trackable

  validates :phone, uniqueness: true

  has_many :user_salon
  has_many :salon
  #belongs_to :witness

  def password_required?
    #false if source = "witness"
    false
  end

  def email_required?
    #false if source = "witness"
    false
  end

  def staff?
    not Staff.where(user_id: id).empty?
  end

  def admin?
    not Staff.where(user_id: id, entity_type: 'admin').empty?
  end

  def manage_salon?(salon)
    staff = Staff.where(user_id: id)
    return false if staff.nil?
    return Staff.manage_salon?(self, salon.id)
  end

  def first_name
    if full_name
      return full_name.split(' ')[0]
    end
  end

  def last_name
    if full_name
      return full_name.split(' ')[1]
    end
  end

  def self.exist?(email,phone)
    return nil if email.nil? && phone.nil?
    if !email.nil?
      user = User.where(email: email)
      user = user.or(User.where(phone: phone)) if !phone.nil?
    else
      user = User.where(phone: phone) if !phone.nil?
    end
    return user.first if !user.first.nil?
    return nil
  end
end
