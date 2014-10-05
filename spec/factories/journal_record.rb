FactoryGirl.define do
  factory :journal_record do |f|
    equipment
    #f.journalable FactoryGirl.create(:relocation)
    #f.after_create {|r| FactoryGirl.create(:relocation, :journalable => r)}
  end
end
