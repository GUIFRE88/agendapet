class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Verificar assinatura em todas as páginas
  include SubscriptionRequired

  before_action :ensure_subscription, if: :user_signed_in?

  private
  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def ensure_subscription
    return if current_user.subscription.present?
    current_user.create_subscription!(
      status: 'trial',
      plan_type: 'trial',
      trial_ends_at: 14.days.from_now
    )
  end
end
