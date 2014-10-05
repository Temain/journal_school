require 'spec_helper'

describe EquipmentController do
  let(:item) { FactoryGirl.create(:equipment) }
  before(:each) do
    include Rails.application.routes.url_helpers
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET index" do
    before(:each) do
      get :index
    end

    it "has a 200 status code" do
      expect(response.status).to eq(200)
    end

    it "should return a list of equipment" do
      assigns(:equipment).should_not be_nil
    end

    it "renders the index template" do
      expect(response).to render_template("index")
    end
  end

  describe "POST relocation" do
    it "when parameter :new_department_id is empty" do
      post :relocation, id: item.id, new_department_id: [""]
      expect(flash[:danger]).to_not be_nil
      expect(response).to redirect_to action: :index
    end

    it "when new department not exists" do
      post :relocation, id: item.id, new_department_id: ["11100000000"]
      expect(flash[:danger]).to_not be_nil
      expect(response).to redirect_to action: :index
    end

    it "should save relocation" do
      new_department = FactoryGirl.create(:department)
      post :relocation, id: item.id, new_department_id: ["#{new_department.id}"]
      assigns[:relocation].should_not be_new_record
      assigns[:relocation].journal_record.should_not be_new_record
      expect(response).to redirect_to action: :index
    end
  end

  describe "POST repair" do
    context "should save repair" do
      it "when spares is empty" do
        post :repair, id: item.id, spares: nil
        assigns[:repair].should_not be_new_record
        assigns[:repair].journal_record.should_not be_new_record
        expect(response).to redirect_to action: :index
      end

      it "when spares is not empty" do
        spare1 = FactoryGirl.create(:spare)
        spare2 = FactoryGirl.create(:spare)
        post :repair, id: item.id, reason: "",spares: "#{spare1.id}, #{spare2.id}"
        #assigns[:repair].should_not be_new_record
        assigns[:repair].journal_record.should_not be_new_record
        assigns[:repair].spares.should_not be_nil
        expect(response).to redirect_to action: :index
      end
    end
  end
end
