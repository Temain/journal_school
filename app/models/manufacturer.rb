# == Schema Information
#
# Table name: manufacturers
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  abbreviation :string(255)
#

class Manufacturer < ActiveRecord::Base
  has_many :equipments
  validates :name, presence: true, uniqueness: true

  default_scope -> { order('name ASC') }

  private

  def self.search(search)
    if search
      where(['name LIKE ?', "%#{ search }%"])
    else
      all
    end
  end
end
