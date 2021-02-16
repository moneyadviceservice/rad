class AddTwoNewQualifications < ActiveRecord::Migration[5.2]
  def self.up
    Qualification.find_or_create_by(id: 12, name: 'Chartered Associate of The London Institute of Banking & Finance', order: 12)
    Qualification.find_or_create_by(id: 13, name: 'Chartered Fellow of The London Institute of Banking & Finance', order: 13)
  end

  def self.down
    Qualification.find(12).destroy if Qualification.exists?(12)
    Qualification.find(13).destroy if Qualification.exists?(13)
  end
end
