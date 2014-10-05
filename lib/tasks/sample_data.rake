require 'bcrypt'

namespace :db do
  task create_user: :environment do

    # Create users
    User.create!(username:              "cherepovskiy",
                 email:                 "cherepovskiy@evgeny.by",
                 password:              "12345678",
                 password_confirmation: "12345678")

    User.create!(username:              "temain",
                 email:                 "temain@mail.ru",
                 password:              "12345678",
                 password_confirmation: "12345678")
  end


  desc "Fill database with sample data"
  task populate: :environment do

    # Create categories
    Category.create!(name: "Ноутбуки, планшеты и компьютеры")
    Category.create!(name: "Периферийные устройства")
    Category.create!(name: "Компьютерные аксессуары")

    # Create departments
    10.times do |n|
      Department.create!(name:                   "#{Faker::Commerce.department} ##{n + 1}",
                         materially_responsible: Faker::Name.name,
                         phone_number:           Faker::PhoneNumber.subscriber_number(3)
      )
    end

    # Create equipment types
    10.times do |n|
      EquipmentType.create!(name:         "#{Faker::Commerce.product_name} ##{n}",
                            category_id:  rand(1..Category.count)
      )
    end

    # Create manufacturers
    10.times do |n|
      Manufacturer.create!(name: Faker::Company.name,
                           abbreviation: "ABBA"
      )
    end

    # Create equipments
    100.times do
      Equipment.create!(model: Faker::Lorem.word,
                        equipment_type_id: rand(1..EquipmentType.count),
                        department_id:     rand(1..Department.count),
                        inventory_number:  Faker::Number.number(11),
                        manufacturer_id:   rand(1..Manufacturer.count),
                        writed_off:        rand(1)
      )
    end

    # Create users
    User.create!(email:                 "temain@mail.ru",
                 password:              "12345678",
                 password_confirmation: "12345678")
    9.times do |n|
      #name = Faker::Name.name
      email = "example-#{n+1}@mail.ru"
      password = "password"
      User.create!(email: email,
                   password: password,
                   password_confirmation: password)
    end

    # Create relocation actions and save it in journal records table
    50.times do
      relocation = Relocation.create!(new_department_id: rand(1..Department.count),
                                      old_department_id: rand(1..Department.count))

      from = Time.now.to_f
      to = 3.years.from_now.to_f
      action_date = Time.at(from + rand * (to - from))
      relocation.create_journal_record(equipment_id:  rand(1..Equipment.count),
                                       user_id:       rand(1..User.count),
                                       action_date:   action_date
      )
    end

    # Create spares
    200.times do |n|
      Spare.create!(name:              "#{Faker::Lorem.word} ##{n}",
                    equipment_type_id: rand(1..EquipmentType.count)
      )
    end

    # Create repair actions and save it in journal records table
    50.times do
      repair = Repair.create!(reason:   Faker::Lorem.sentence)

      ids = Spare.pluck(:id)
      repair.spares << Spare.find(ids.sample)

      from = Time.now.to_f
      to = 3.years.from_now.to_f
      action_date = Time.at(from + rand * (to - from))
      repair.create_journal_record(equipment_id:  rand(1..Equipment.count),
                                   user_id:       rand(1..User.count),
                                   action_date:   action_date
      )
    end
  end
end