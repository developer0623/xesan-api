class RecommendedLink < ActiveRecord::Base

  def as_json(options = {})
    {
      id: id,
      title: title,
      url: url
    }
  end
end
