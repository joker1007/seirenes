class SessionsController < ApplicationController
  def callback
    auth = request.env["omniauth.auth"]
    @user = current_user.taap || User.find_or_create_by_omniauth(auth)
    if @user.persisted?
      @user.update_auth(auth)

      session[:user_id] = @user.id
      redirect_to :root, notice: "#{@user.screen_name}としてログインしました"
    else
      redirect_to :root, alert: "ログインに失敗しました"
    end
  end

  def failure
    render text: "Auth Failure", status: :unauthorized
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root, notice: "ログアウトしました"
  end
end
