class Movie < ActiveRecord::Base

	def self.all_ratings
		ratings = Movie.select('rating').collect(&:rating).uniq.sort
		# .select(:rating) chooses ratings from movies (returns list of them)
		# .map(&:rating) maps out each rating into an array
		#    basically .each { |r| r.rating}
		# .uniq only shows the uniq values
		# .sort sorts in alpha order 
	end

end
