class ProfilesController < ApplicationController
  before_action :authenticate

  def index; end
  def dashboard; end
  def brands
    @brands = Brand.where(account_id: current_account.id)
  end
  def brands_owner; end
  def brands_head; end

  def update
    @profile = current_account.profile
    if @profile.update(current_profile_params)
      flash[:notice] = 'Профиль успешно обновлен'
    else
      flash[:alert]  = 'Не могу обновить профиль'
    end
    redirect_to dashboard_path
  end

  private

  def current_profile_params
    params.require(:profile).permit(
      :username, :firstname,
      :lastname, :gender,
      :bio, :birthdate
    )
  end
end
