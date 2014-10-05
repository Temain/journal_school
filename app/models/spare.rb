# == Schema Information
#
# Table name: spares
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  equipment_type_id :integer
#

class Spare < ActiveRecord::Base
  belongs_to :equipment_type
  has_and_belongs_to_many :repairs

  validates :name, presence: true, uniqueness: true

  private

    def self.search(search)
      if search
        where(['name LIKE ?', "%#{ search }%"])
      else
        all
      end
    end
end
