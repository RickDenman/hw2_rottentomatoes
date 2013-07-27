class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
    logger.debug "In show method, the session[:current_ratings] object is #{session[:current_ratings]}"
  end

  def index
    @all_ratings = Movie.get_ratings
    if params[:sort_by] == nil
      sort = session[:current_sort_by]
    else 
      sort = params[:sort_by]
    end
    #logger.debug "Before if statement, the @ratings_filter object is #{@ratings_filter}"
    if params[:ratings] == nil
	@ratings_filter = session[:current_ratings]
    elsif params[:ratings].is_a? Array
	@ratings_filter = params[:ratings]
    else
	@ratings_filter = params[:ratings].keys
    end
    #logger.debug "After if statement, the @ratings_filter object is #{@ratings_filter}"
    session[:current_ratings] = @ratings_filter
    session[:current_sort_by] = sort
    params[:sort_by] = sort
    logger.debug "After if statement, the session[:current_ratings] object is #{session[:current_ratings]}"
    logger.debug "After if statement, the session[:current_sort_by] object is #{session[:current_sort_by]}"
    @movies = Movie.where("rating IN (?)", @ratings_filter).order(sort)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to (movies_path(:ratings => session[:current_ratings], :sort_by => session[:current_sort_by]))
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
    redirect_to (movies_path(session[:current_ratings], session[:current_sort_by]))
  end

end
