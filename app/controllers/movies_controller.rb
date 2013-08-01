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
    p_rat = []
    s_rat = []
    p_rat = params[:ratings].map { |x,y| x } if params[:ratings]
    s_rat = session[:ratings].map { |x,y| x } if session[:ratings]

    debugger
    if params[:sort_by] && params[:ratings]
      @movies = Movie.where("rating = '#{p_rat.join("' OR rating = '")}'").order(params[:sort_by])
      p_rat.each { |x| @ratings_hash[x] = true }
      session[:sort_by] = params[:sort_by]
      session[:ratings] = params[:ratings]
      
    elsif params[:ratings] == nil && params[:sort_by] == nil
      if session[:ratings] == nil && session[:sort_by] == nil
        @movies = Movie.all
        @ratings_hash.update(@ratings_hash) { |x, y| y = true }
      else
        @movies = Movie.where("rating = '#{s_rat.join("' OR rating = '")}'").order(session[:sort_by])    
        s_rat.each { |x| @ratings_hash[x] = true }
      end

    elsif params[:sort_by]
      redirect_to movies_path(:sort_by => params[:sort_by])
      # @movies = Movie.order(params[:sort_by])
      @ratings_hash.update(@ratings_hash) { |x, y| y = true }
      session[:sort_by] = params[:sort_by]
      session.delete(:ratings)

    else
      @movies = Movie.where("rating = '#{p_rat.join("' OR rating = '")}'").order(params[:sort_by])
      p_rat.each { |x| @ratings_hash[x] = true }
      session[:ratings] = params[:ratings]
      session.delete(:sort_by)

    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path(:sort_by => session[:sort_by], :ratings => session[:ratings])
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
    redirect_to movies_path(:sort_by => session[:sort_by], :ratings => session[:ratings])
  end

end
