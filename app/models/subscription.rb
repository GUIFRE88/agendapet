class Subscription < ApplicationRecord
  belongs_to :user

  # Status possíveis
  STATUSES = %w[trial active past_due canceled incomplete incomplete_expired unpaid].freeze
  
  # Planos disponíveis
  PLANS = {
    'trial' => { name: 'Trial Gratuito', price: 0, duration_days: 14 },
    'basic' => { name: 'Plano Básico', price: 29.90, duration_days: 30 },
    'premium' => { name: 'Plano Premium', price: 59.90, duration_days: 30 },
    'enterprise' => { name: 'Plano Enterprise', price: 99.90, duration_days: 30 }
  }.freeze

  validates :status, inclusion: { in: STATUSES }
  validates :plan_type, inclusion: { in: PLANS.keys }

  # Scopes
  scope :active, -> { where(status: ['trial', 'active']) }
  scope :trial, -> { where(status: 'trial') }
  scope :paid, -> { where(status: 'active') }

  # Métodos de verificação
  def active?
    return true if status == 'trial' && trial_ends_at > Time.current
    status == 'active'
  end

  def trial?
    status == 'trial'
  end

  def expired?
    return false if status == 'active'
    return true if status == 'trial' && trial_ends_at < Time.current
    false
  end

  def needs_payment?
    expired? || status.in?(['past_due', 'unpaid'])
  end

  # Métodos de plano
  def plan_name
    PLANS[plan_type]&.dig(:name) || 'Plano Desconhecido'
  end

  def plan_price
    PLANS[plan_type]&.dig(:price) || 0
  end

  def days_remaining
    return 0 unless trial?
    return 0 if trial_ends_at.nil?
    [(trial_ends_at - Time.current).to_i / 1.day, 0].max
  end
end
