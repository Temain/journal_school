class HistoryController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item
  before_action :load_departments, only: [:show]
  before_action :load_equipment_types, only: [:show]

  def show
    #@journal_records = JournalRecord.all.group_by{ |i| i.action_date.year }
    @journal_records = @item.journal_records.group_by{ |i| i.action_date.year }
  end

  private

    def set_item
      @item = Equipment.find(params[:id])
    end

end
