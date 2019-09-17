class VerifyReferenceNumberJob < ActiveJob::Base
  include Sidekiq::Worker

  queue_as :default
  sidekiq_options retry: 5, backtrace: true, unique: :until_executed

  def perform(form_data)
    @response = FcaApi::Request.new.get_firm(form_data['fca_number'])

    if @response.ok?
      Rails.logger.info(
        "\nINFO: FCA API successful request for #{form_data['fca_number']}\n"
      )
      VerifiedPrincipal.new(form_data, firm_name).register!
    else
      Rails.logger.warn(
        "\n WARN: FCA API failed for #{form_data['fca_number']}\n"
      )
      send_fail_email(form_data['email'])
    end
  end

  private

  def firm_name
    @response.data['Organisation Name']
  end

  def send_fail_email(email)
    FailedRegistrationMailer.notify(email).deliver_later
  end
end
