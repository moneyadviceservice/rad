class NewFirmMailerPreview < ActionMailer::Preview
  def notify
    firm = Struct.new(:registered_name, :id).new('Foo Bar ltd', '4321')
    NewFirmMailer.notify(firm)
  end
end
