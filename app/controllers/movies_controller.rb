class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # @movies = Movie.all
    
    # this theoretically works but didn't work for me
    #if params[:sort_by] == "title"
    #  @movies = Movies.order('title ASC')
    #elsif params[:sort_by] == "release_date"
    #  @movies = Movies.order('release_date ASC')
    #else
    #  @movies = Movie.all
    #end
    
    @all_ratings = Movie.all_ratings
    @ratings_hash = { "G" => false, "PG" => false, "PG-13" => false, "R" => false }
    # if( nothing set ) { set all true } else { do mapping }
    
    if params[:commit] == "Refresh"
      @checked_box = params[:ratings]  # params[:ratings] is a hash!
      arr = []
      @checked_box.map do |x,y|      # { "G" => 1, "PG" => 1}
        arr << Movie.find_all_by_rating(x)    # this returns an array of arrays (however many i've chosen)
        @ratings_hash[x] = true
      end
      @all_ratings = Movie.all_ratings
      @movies = arr.flatten                   # @movies only works on 1D array so need to flatten arr to 1D
    else
      @movies = Movie.order(params[:sort_by])
      @ratings_hash = { "G" => true, "PG" => true, "PG-13" => true, "R" => true }
    end


    # if user selects some movie ratings and hits refresh, run this code
    # else black refresh

    #@checked_box = params[:ratings] # should return hash of ratings chosen
    #@checked_box.map do
    #  |x| Movie.where("rating = ?", x)
    #end

    #movie.find_all_by_rating('G') also works

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
