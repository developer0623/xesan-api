class RecommendedLinksController < ApiController
  before_action :set_recommended_link, only: [:update, :destroy]

  # GET /recommended_links
  # GET /recommended_links.json
  def index
    @recommended_links = RecommendedLink.all

    render json: @recommended_links
  end

  # POST /recommended_links
  # POST /recommended_links.json
  def create
    @recommended_link = RecommendedLink.new(recommended_link_params)

    if @recommended_link.save
      render json: @recommended_link, status: :created, location: @recommended_link
    else
      render json: @recommended_link.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /recommended_links/1
  # PATCH/PUT /recommended_links/1.json
  def update
    @recommended_link = RecommendedLink.find(params[:id])

    if @recommended_link.update(recommended_link_params)
      head :no_content
    else
      render json: @recommended_link.errors, status: :unprocessable_entity
    end
  end

  # DELETE /recommended_links/1
  # DELETE /recommended_links/1.json
  def destroy
    @recommended_link.destroy

    head :no_content
  end

  private

    def set_recommended_link
      @recommended_link = RecommendedLink.find(params[:id])
    end

    def recommended_link_params
      params.require(:recommended_link).permit(:title, :url)
    end
end
