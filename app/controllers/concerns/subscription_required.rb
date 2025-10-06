module SubscriptionRequired
  extend ActiveSupport::Concern

  included do
    before_action :check_subscription_status
  end

  private

  def check_subscription_status
    return unless user_signed_in?
    return if subscription_allowed_paths.include?(request.path)
    return if current_user.has_active_subscription?

    if current_user.trial_expired?
      redirect_to subscriptions_path, alert: 'Seu período de teste expirou. Escolha um plano para continuar.'
    elsif current_user.needs_payment?
      redirect_to subscriptions_path, alert: 'Sua assinatura precisa ser renovada.'
    end
  end

  def subscription_allowed_paths
    [
      '/',
      '/users/sign_in',
      '/users/sign_up',
      '/users/password/new',
      '/users/password',
      '/users/sign_out',
      '/subscriptions',
      '/subscriptions/create',
      '/subscriptions/update',
      '/subscriptions/destroy'
    ]
  end
end
