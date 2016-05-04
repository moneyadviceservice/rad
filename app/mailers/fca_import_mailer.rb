class FcaImportMailer < ActionMailer::Base
  default(
    from: 'RADenquiries@moneyadviceservice.org.uk'
  )

  def successful_upload(email, filename)
    @email = email
    @filename = filename
    mail subject: 'FCA file uploaded successfully', to: email
  end

  def failed_upload(email, filename, error)
    @email = email
    @filename = filename
    @error = error
    mail subject: 'FCA file upload failed', to: email
  end
end
