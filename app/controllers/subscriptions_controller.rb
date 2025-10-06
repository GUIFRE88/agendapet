class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subscription, only: [:show, :update, :destroy]

  def index
    @subscription = current_user.subscription
    @plans = Subscription::PLANS.except('trial')
  end

  def show
  end

  def create
    plan_type = params[:plan_type]
    
    if plan_type == 'trial'
      redirect_to dashboard_path, alert: 'Você já está no período de teste!'
      return
    end

    # Aqui você integraria com o Stripe
    # Por enquanto, vamos simular a criação
    if current_user.subscription.update(
      status: 'active',
      plan_type: plan_type,
      current_period_start: Time.current,
      current_period_end: 30.days.from_now
    )
      redirect_to dashboard_path, notice: 'Assinatura ativada com sucesso!'
    else
      redirect_to subscriptions_path, alert: 'Erro ao ativar assinatura.'
    end
  end

  def update
    if @subscription.update(subscription_params)
      redirect_to subscriptions_path, notice: 'Assinatura atualizada com sucesso!'
    else
      redirect_to subscriptions_path, alert: 'Erro ao atualizar assinatura.'
    end
  end

  def destroy
    @subscription.update(status: 'canceled')
    redirect_to subscriptions_path, notice: 'Assinatura cancelada com sucesso!'
  end

  private

  def set_subscription
    @subscription = current_user.subscription
  end

  def subscription_params
    params.require(:subscription).permit(:plan_type, :status)
  end
end
