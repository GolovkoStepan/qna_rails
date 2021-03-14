# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
         authentication_keys: [:login]

  has_many :questions
  has_many :answers
  has_many :rewards
  has_many :votes
  has_many :comments

  validates :nickname, presence: true
  validates :nickname, uniqueness: true, if: :nickname?
  validates :nickname, format: { with: /\A[a-zA-Z0-9_.]*\z/, multiline: true }

  validates :email, uniqueness: true, if: :email?
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, multiline: true }, if: :email?
  validates :phone, uniqueness: true, if: :phone?

  attr_writer :login

  before_save :reset_confirmation

  def confirmed?
    phone_confirmed || email_confirmed
  end

  def created_by_me?(resource)
    resource.respond_to?(:user_id) ? id == resource.user_id : false
  end

  def login
    @login || nickname
  end

  def full_name
    full_name = [first_name, last_name].join(' ')
    first_name.blank? ? nickname : full_name
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      begin
        Integer(login)
        where(conditions.to_h).where(['phone = :value', { value: login.to_i }]).first
      rescue ArgumentError
        where(conditions.to_h).where(
          ['lower(nickname) = :value OR lower(email) = :value', { value: login.downcase }]
        ).first
      end
    elsif conditions.key?(:username) || conditions.key?(:email) || conditions.key?(:phone)
      where(conditions.to_h).first
    end
  end

  protected

  def email_required?
    false
  end

  private

  def reset_confirmation
    self.email_confirmed = false if email_changed?
    self.phone_confirmed = false if phone_changed?
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  date_of_birth          :date
#  email                  :string           default(""), not null
#  email_confirmed        :boolean          default(FALSE)
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  nickname               :string           default(""), not null
#  phone                  :bigint
#  phone_confirmed        :boolean          default(FALSE)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
