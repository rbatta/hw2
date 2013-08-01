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
    p_rat = []
    s_rat = []
    p_rat = params[:ratings].map { |x,y| x } if params[:ratings]
    s_rat = session[:ratings].map { |x,y| x } if session[:ratings]
    
    # if( nothing set ) { set all true } else { do mapping }
     
=begin
  
1st load
  if sessions have keys has_key?(key) T/F
    redirect to loading by sessions
  else, load all

if params sort
  sort list
  session = param sort
if params sort == nil && params ratings == nil
  use session and redirect

if params ratings
  filter ratings
  session = params ratings
=end 
    #if !session[:sort_by] && !session[:ratings]
    #  @movies = Movie.all 
    #end
    debugger
    
    if params[:sort_by] && params[:ratings]
      @movies = Movie.where("rating = '#{p_rat.join("' OR rating = '")}'").order(params[:sort_by])
      p_rat.each { |x| @ratings_hash[x] = true }
      session[:ratings] = params[:ratings]
      session[:sort_by] = params[:sort_by]
    elsif params[:sort_by]
      @movies = Movie.order(params[:sort_by])
      session[:sort_by] = params[:sort_by]
      @ratings_hash.update(@ratings_hash) { |x, y| y = true }
      # redirect_to movies_path(:ratings => session[:ratings], :sort_by => session[:sort_by])
    elsif params[:ratings]
      @movies = Movie.where("rating = '#{p_rat.join("' OR rating = '")}'").order(params[:sort_by])
      p_rat.each { |x| @ratings_hash[x] = true }
      session[:ratings] = params[:ratings]
    elsif !session[:ratings] && !session[:sort_by]
      @movies = Movie.all 
      @ratings_hash.update(@ratings_hash) { |x, y| y = true }
    elsif !params[:ratings] && !params[:sort_by]
      redirect_to movies_path(:ratings => session[:ratings], :sort_by => session[:sort_by])
    else #everything should be nil
      @movies = Movie.all 
      @ratings_hash.update(@ratings_hash) { |x, y| y = true }
    end
# redirect_to movies_path can only happen 1x in index method

=begin
    if params[:sort_by] && params[:ratings]
      @movies = Movie.where("rating = '#{p_rat.join("' OR rating = '")}'").order(params[:sort_by])
      p_rat.each { |x| @ratings_hash[x] = true }
      session[:sort_by] = params[:sort_by]
      session[:ratings] = params[:ratings]
      
    elsif params[:ratings] == nil && params[:sort_by] == nil
      if session[:ratings] == nil && session[:sort_by] == nil
        @movies = Movie.all
        @ratings_hash.update(@ratings_hash) { true }
      else
        @movies = Movie.where("rating = '#{s_rat.join("' OR rating = '")}'").order(session[:sort_by])    
        s_rat.each { |x| @ratings_hash[x] = true }
      end

    elsif params[:sort_by]
      #redirect_to movies_path(:sort_by => params[:sort_by])
      @movies = Movie.order(params[:sort_by])
      @ratings_hash.update(@ratings_hash) { true }
      session[:sort_by] = params[:sort_by]
      session.delete(:ratings)

    else
      # redirect_to movies_path(:ratings => params[:ratings])
      @movies = Movie.where("rating = '#{p_rat.join("' OR rating = '")}'").order(params[:sort_by])
      p_rat.each { |x| @ratings_hash[x] = true }
      session[:ratings] = params[:ratings]
      session.delete(:sort_by)

    end
=end
    
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
    redirect_to movies_path #(:sort_by => session[:sort_by], :ratings => session[:ratings])
  end

end
