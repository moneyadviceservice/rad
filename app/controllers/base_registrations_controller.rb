class BaseRegistrationsController < ApplicationController
  before_action :validate_registration_type, only: [:create]
  before_action :set_cache_buster, only: :new
  def new
    @form = NewPrincipalForm.new
    Stats.increment('radsignup.prequalification.success')
  end

  def create
    submitted_form = NewPrincipalForm.new(new_principal_form_params)

    result = DirectoryRegistrationService.call(submitted_form)

    if result.success?
      render :show
    else
      @form = result.form
      flash.now[:error] = t('registration.principal.validation_error_html')
      render :new
    end
  end

  private

  def new_principal_form_params
    params.require(:new_principal_form).permit(
      :fca_number,
      :first_name,
      :last_name,
      :individual_reference_number,
      :job_title,
      :email,
      :telephone_number,
      :password,
      :password_confirmation,
      :confirmed_disclaimer,
      :registration_type
    )
  end

  def validate_registration_type
    redirect_to root_path unless supported_registration_type?
  end

  def supported_registration_type?
    new_principal_form_params[:registration_type]
      .in?(
        DirectoryRegistrationService::REGISTRATION_TYPE_TO_FIRM_MAPPING.keys
      )
  end

  def set_cache_buster
    response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = 1.year.ago.httpdate
  end
end
