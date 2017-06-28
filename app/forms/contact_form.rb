class ContactForm
  include ActiveModel::Model

  attr_accessor :email, :message

  validates_presence_of :message, :email
  validates_format_of :email,
                      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  def field_order
    %i[email message]
  end
end
