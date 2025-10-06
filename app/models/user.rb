class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associações
  has_one :subscription, dependent: :destroy

  # Callbacks
  after_create :create_trial_subscription

  # Métodos de assinatura
  def has_active_subscription?
    subscription&.active? || false
  end

  def trial_expired?
    subscription&.expired? || false
  end

  def needs_payment?
    subscription&.needs_payment? || false
  end

  def current_plan
    subscription&.plan_name || 'Sem plano'
  end

  def days_remaining
    subscription&.days_remaining || 0
  end

  private

  def create_trial_subscription
    create_subscription!(
      status: 'trial',
      plan_type: 'trial',
      trial_ends_at: 14.days.from_now
    )
  end
end
