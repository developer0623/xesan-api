require 'rails_helper'

RSpec.describe RecommendedLinksController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # RecommendedLink. As you add validations to RecommendedLink, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      url: "http://www.blah.com",
      title: "My awesome link"
    }
  }

  let(:invalid_attributes) {
    {stuff: "junk"}
  }

  before do
    RecommendedLink.destroy_all
    @user = create(:user)
    @user.save!

    @admin_user = create(:admin_user)
    @admin_user.save!
  end

  describe "GET #index" do
    it "assigns all recommended_links as @recommended_links" do
      recommended_link = RecommendedLink.create! valid_attributes
      login_with @user
      get :index
      expect(assigns(:recommended_links)).to eq([recommended_link])
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new RecommendedLink" do
        expect {
          login_with @user
          post :create, {:recommended_link => valid_attributes}
        }.to change(RecommendedLink, :count).by(1)
      end

      it "assigns a newly created recommended_link as @recommended_link" do
        login_with @user
        post :create, {:recommended_link => valid_attributes}
        expect(assigns(:recommended_link)).to be_a(RecommendedLink)
        expect(assigns(:recommended_link)).to be_persisted
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved recommended_link as @recommended_link" do
        login_with @user
        post :create, {:recommended_link => invalid_attributes}
        expect(assigns(:recommended_link)).to_not be_a_new(RecommendedLink)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {
          url: "http://www.blah2.com",
          title: "My awesome link2"
        }
      }

      it "updates the requested recommended_link" do
        recommended_link = RecommendedLink.create! valid_attributes
        login_with @user
        put :update, {:id => recommended_link.to_param, :recommended_link => new_attributes}
        recommended_link.reload
        expect(recommended_link.url).to eq(new_attributes[:url])
      end

      it "assigns the requested recommended_link as @recommended_link" do
        recommended_link = RecommendedLink.create! valid_attributes
        login_with @user
        put :update, {:id => recommended_link.to_param, :recommended_link => valid_attributes}
        expect(assigns(:recommended_link)).to eq(recommended_link)
      end
    end

    context "with invalid params" do
      it "assigns the recommended_link as @recommended_link" do
        recommended_link = RecommendedLink.create! valid_attributes
        login_with @user
        put :update, {:id => recommended_link.to_param, :recommended_link => invalid_attributes}
        expect(assigns(:recommended_link)).to eq(recommended_link)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested recommended_link" do
      recommended_link = RecommendedLink.create! valid_attributes
      expect {
        login_with @user
        delete :destroy, {:id => recommended_link.to_param}
      }.to change(RecommendedLink, :count).by(-1)
    end
  end

end
