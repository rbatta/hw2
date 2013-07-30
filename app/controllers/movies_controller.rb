class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # @movies = Movie.all
    
    @all_ratings = Movie.all_ratings
    @ratings_hash = { "G" => false, "PG" => false, "PG-13" => false, "R" => false }
    # if( nothing set ) { set all true } else { do mapping }
    
    arr = []
    debugger
    if params[:sort_by] || params[:ratings]
      session[:sort_by] = params[:sort_by]
      session[:ratings] = params[:ratings]
      if !params[:ratings]      # because sort_by by itself has no params[ratings] to pass thru
        @movies = Movie.order(session[:sort_by])
        @ratings_hash = { "G" => true, "PG" => true, "PG-13" => true, "R" => true }
      else
        params[:ratings].map do |x,y|      # eg. { "G" => 1, "PG" => 1}
          arr << Movie.order(params[:sort_by]).where('rating = ?', x)   # this returns an array of arrays (however many i've chosen)
          @ratings_hash[x] = true
        end
        @all_ratings = Movie.all_ratings
        @movies = arr.flatten
      end
    else
      @movies = Movie.order(params[:sort_by])
      @ratings_hash = { "G" => true, "PG" => true, "PG-13" => true, "R" => true }
      
    end
    
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
