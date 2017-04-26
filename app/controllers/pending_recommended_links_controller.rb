class PendingRecommendedLinksController < ApiController
  before_action :set_pending_recommended_link, only: [:show, :update, :destroy]

  # GET /pending_recommended_links
  # GET /pending_recommended_links.json
  def index
    @pending_recommended_links = PendingRecommendedLink.all

    render json: @pending_recommended_links
  end

  # POST /pending_recommended_links
  # POST /pending_recommended_links.json
  def create
    @pending_recommended_link = PendingRecommendedLink.new(pending_recommended_link_params)

    if @pending_recommended_link.save
      render json: @pending_recommended_link, status: :created
    else
      render json: @pending_recommended_link.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pending_recommended_links/1
  # PATCH/PUT /pending_recommended_links/1.json
  def update
    @pending_recommended_link = PendingRecommendedLink.find(params[:id])

    if @pending_recommended_link.update(pending_recommended_link_params)
      head :no_content
    else
      render json: @pending_recommended_link.errors, status: :unprocessable_entity
    end
  end

  # DELETE /pending_recommended_links/1
  # DELETE /pending_recommended_links/1.json
  def destroy
    @pending_recommended_link.destroy

    head :no_content
  end

  private

    def set_pending_recommended_link
      @pending_recommended_link = PendingRecommendedLink.find(params[:id])
    end

    def pending_recommended_link_params
      params.require(:pending_recommended_link).permit(:title, :url)
    end
end
