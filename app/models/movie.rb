class Movie < ActiveRecord::Base


  def self.all_ratings
    Movie.uniq.pluck(:rating)
  end


  # :services.in =>['lights'] 
  def self.with_ratings(ratings_list)
    # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
    #  movies with those ratings
    # if ratings_list is nil, retrieve ALL movies
    # return Movie.all
    if ratings_list == nil || ratings_list.empty?
      Movie.all
    else
      Movie.where(rating: ratings_list)
    end
  end
end