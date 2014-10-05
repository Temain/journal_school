class ImportController < ApplicationController
  before_action :authenticate_user!
  before_action :load_departments, only: [:index]
  before_action :load_equipment_types, only: [:index]

  def index
    # @dark_page = false
  end

  def upload
    if request.xhr?
      respond_to do |format|
        @results = Equipment.import session, params[:import_file]
        format.js
      end
    end
  end

  def format
    if request.xhr?
      respond_to do |format|
        Equipment.format params[:import_file]
        format.js #{ redirect_to download_path("formated") }
      end
    end
  end

  def download
    @file = open("public/#{params[:file_name]}.xls")
    send_file(@file, :filename => "#{params[:file_name]}.xls")
  end

  def departments_index
    @dark_page = true
  end

  def departments
    #Department.import File.open("public/departments.xls")
    Department.import params[:import_file]
    render text: "<h1>#{@count}</h1>".html_safe
  end

end
