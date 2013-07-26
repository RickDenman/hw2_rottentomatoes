class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_ratings
    sort = params[:sort_by]
    #logger.debug "Before if statement, the @ratings_filter object is #{@ratings_filter}"
    if params[:ratings] == nil
	#logger.debug "clause 1 (nil)"
	@ratings_filter = @all_ratings
    elsif params[:ratings].is_a? Array
        #logger.debug "clause 2 (array)"
	@ratings_filter = params[:ratings]
    else
	#logger.debug "clause 3 (hash)"
	@ratings_filter = params[:ratings].keys
    end
    #logger.debug "After if statement, the @ratings_filter object is #{@ratings_filter}"
   
    @movies = Movie.where("rating IN (?)", @ratings_filter).order(sort)
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
