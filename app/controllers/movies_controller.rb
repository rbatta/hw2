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
    
=begin
  
if params has no rating or sorting and session is not nil
    use the session variable to set parameters
    and load
if params has no ratings but does have sort_by (session gets overriden)
    view sorted movies 
    update session[:sort_by] variable
if params has no sorting but does have ratings
    view filtered movies
    set session[:ratings]
if both params have values
    view filtered AND sorted
    set session[:ratings] and session[:sort_by]
if params has nothing and session has nothing
    view all movies (load all)
  
=end
    
    if params[:sort_by] && params[:ratings]
      params[:ratings].map do |x,y|      # eg. { "G" => 1, "PG" => 1}
        arr << Movie.order(params[:sort_by]).where('rating = ?', x)   # this returns an array of arrays (however many i've chosen)
        @ratings_hash[x] = true
      end
      @all_ratings = Movie.all_ratings
      @movies = arr.flatten
      session[:sort_by] = params[:sort_by]
      session[:ratings] = params[:ratings]
      
    elsif params[:ratings] == nil && params[:sort_by] == nil
      if session[:ratings] == nil && session[:sort_by] == nil
        @movies = Movie.all
        @ratings_hash = { "G" => true, "PG" => true, "PG-13" => true, "R" => true }
      else
        session[:ratings].map do |x,y|      
          arr << Movie.order(session[:sort_by]).where('rating = ?', x)   
          @ratings_hash[x] = true
        end
        @all_ratings = Movie.all_ratings
        @movies = arr.flatten
      end

    elsif params[:sort_by]
      @movies = Movie.order(params[:sort_by])
      @ratings_hash = { "G" => true, "PG" => true, "PG-13" => true, "R" => true }
      session[:sort_by] = params[:sort_by]

    else
      params[:ratings].map do |x,y|      
        arr << Movie.order(params[:sort_by]).where('rating = ?', x)   
        @ratings_hash[x] = true
      end
      @all_ratings = Movie.all_ratings
      @movies = arr.flatten
      session[:ratings] = params[:ratings]

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
