module ReviewsHelper
  def review_average(reviews)
    reviews.length > 0 ? reviews.inject(0) {|sum, r| sum + r.rank } .quo(reviews.length).to_f.round(2) : 0
  end
end
