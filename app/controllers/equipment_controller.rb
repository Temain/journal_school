class EquipmentController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item,  only: [:edit, :update, :destroy, :repair, :relocation, :write_off]
  before_action :load_departments, only: [:index, :new, :edit, :create, :update, :relocation]
  before_action :load_equipment_types, only: [:index, :new, :edit, :create, :update]

  def index
    @equipment = Equipment.search(params[:search]).page params[:page]
    @categories = Category.all

    if request.xhr?
      respond_to do |format|
        format.js { render "container" }
      end
    end
  end

  def show
  end

  def new
    @item = Equipment.new
    @item.manufacturer = Manufacturer.new
  end

  def edit
  end

  def create
    @item = Equipment.new(equipment_params)
    @manufacturer = Manufacturer.find_or_create_by(name: params[:manufacturer][:name])
    @item.manufacturer = @manufacturer
    if @item.save
      flash[:notice] = "Оборудование успешно добавлено."
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def update
    @manufacturer = Manufacturer.find_or_create_by(name: params[:manufacturer][:name])
    if !@manufacturer.name.empty?
      if @manufacturer.new_record?
        @manufacturer.save
      end
      @item.manufacturer = @manufacturer
    else
      @item.manufacturer = nil
    end

    if @item.update(equipment_params)
      flash[:notice] = "Изменения успешно сохранены."
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  def write_off
    if request.xhr?
      respond_to do |format|
        format.js { render "write_off" }
      end
    end
  end

  def destroy
    @item.writed_off = true
    if @item.save
      flash[:notice] = "#{@item.full_name} успешно списан."
    else
      flash[:danger] = "Извините, произошла ошибка."
    end
    redirect_to action: :index
  end

  def repair
    reason = params[:reason].join if params[:reason]
    @repair = Repair.new(reason: reason)
    params[:spares].split(',').each do |spare_id|
      spare = if spare_id.numeric?
        Spare.find(spare_id)
      else
        Spare.create(name: spare_id, equipment_type_id: @item.equipment_type_id)
      end
      @repair.spares << spare
    end
    @repair.create_journal_record(equipment_id: @item.id, user_id: current_user.id,
                                  action_date: params[:action_date].to_date)
    if @repair.save
      flash[:notice] = "#{@item.full_name} успешно отправлен в ремонт."
    else
      flash[:danger] = "Извините, произошла ошибка."
    end
    redirect_to action: :index
  end

  def relocation
    new_department_id = params[:new_department_id].first
    if new_department_id.blank?
      flash[:danger] = "Пожалуйста, выберите подразделение."
    else
      new_department = Department.find(new_department_id) # Can throw RecordNotFound
      @relocation = Relocation.new(old_department_id: @item.department_id, new_department_id: new_department_id)
      @relocation.create_journal_record(equipment_id: @item.id, user_id: current_user.id, action_date: Time.now)
      @item.department = new_department
      if @relocation.save && @item.save
        flash[:notice] = "#{@item.full_name} успешно перемешен в подразделение #{new_department.name}."
      else
        flash[:danger] = "При перемещении произошла ошибка."
      end
    end
    redirect_to action: :index
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "Указано несуществующее подразделение."
    redirect_to action: :index
  end

  def load_manufacturers
    if request.xhr?
      @manufacturers = Manufacturer.search(params[:query])
      respond_to do |format|
        format.json { render json: @manufacturers }
      end
    end
  end

  def load_equipment
    if request.xhr?
      @equipment = Equipment.search_for_create(params[:query])
      respond_to do |format|
        format.json { render json: @equipment, include: [:manufacturer, :equipment_type] }
      end
    end
  end

  def load_spares
    if request.xhr?
      #@spares = EquipmentType.all.map { |type| [ type.name, type.spares.map { |spare| [spare.name, spare.id] }]}
      @spares = EquipmentType.find(params[:equipment_type_id]).spares.search(params[:q])
      respond_to do |format|
        format.json { render json: @spares }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Equipment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def equipment_params
      params.require(:equipment).permit(:model, :inventory_number, :equipment_type_id, :department_id)
    end
end

class String
  def numeric?
    Float(self) != nil rescue false
  end
end
