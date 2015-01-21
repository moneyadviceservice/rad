class Adviser < ActiveRecord::Base
  belongs_to :firm

  has_and_belongs_to_many :qualifications
end
