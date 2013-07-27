class Movie < ActiveRecord::Base

	def self.all_ratings
		ratings = ['G','PG','PG-13','R']
		# ratings = Movie.select('rating').collect(&:rating).uniq.sort
		# dynamically returns ratings based on whats in the DB
		# .select(:rating) chooses ratings from movies (returns list of them)
		# .map(&:rating) maps out each rating into an array
		#    basically .each { |r| r.rating}
		# .uniq only shows the uniq values
		# .sort sorts in alpha order 
	end

end
