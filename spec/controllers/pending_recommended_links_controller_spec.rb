require 'rails_helper'

RSpec.describe PendingRecommendedLinksController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # PendingRecommendedLink. As you add validations to PendingRecommendedLink, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      url: "http://blah.com",
      title: "My link"
    }
  }

  let(:invalid_attributes) {
    {stuff: "junk"}
  }

  before do
    PendingRecommendedLink.destroy_all
    @user = create(:user)
    @user.save!
  end

  describe "GET #index" do
    it "assigns all pending_recommended_links as @pending_recommended_links" do
      pending_recommended_link = PendingRecommendedLink.create! valid_attributes

      login_with @user
      get :index
      expect(assigns(:pending_recommended_links)).to eq([pending_recommended_link])
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new PendingRecommendedLink" do
        expect {
          login_with @user
          post :create, {:pending_recommended_link => valid_attributes}
        }.to change(PendingRecommendedLink, :count).by(1)
      end

      it "assigns a newly created pending_recommended_link as @pending_recommended_link" do
        login_with @user
        post :create, {:pending_recommended_link => valid_attributes}
        expect(assigns(:pending_recommended_link)).to be_a(PendingRecommendedLink)
        expect(assigns(:pending_recommended_link)).to be_persisted
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved pending_recommended_link as @pending_recommended_link" do
        login_with @user
        post :create, {:pending_recommended_link => invalid_attributes}
        expect(assigns(:pending_recommended_link)).to_not be_a_new(PendingRecommendedLink)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested pending_recommended_link" do
      pending_recommended_link = PendingRecommendedLink.create! valid_attributes
      expect {
        login_with @user
        delete :destroy, {:id => pending_recommended_link.to_param}
      }.to change(PendingRecommendedLink, :count).by(-1)
    end
  end

end
