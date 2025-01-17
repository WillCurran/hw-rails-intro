class MoviesController < ApplicationController
    @sort_asc = false

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      reconcile_session
      @all_ratings = Movie.all_ratings
      @ratings_selected = params[:ratings].nil? ? @all_ratings.to_a : params[:ratings].keys
      @title_style = params[:active_col] == 'title' ? 'hilite bg-warning' : ''
      @release_style = params[:active_col] == 'release_date' ? 'hilite bg-warning' : ''
      @movies = Movie.with_ratings(@ratings_selected)
      if !params[:active_col].nil? && !params[:sort_dir].nil?
        @movies = Movie.with_ratings(@ratings_selected).order(params[:active_col] + ' ' + params[:sort_dir])
      else
        @movies = Movie.with_ratings(@ratings_selected)
      end
    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
    
    def reconcile_session
      should_redirect = false
      if params[:ratings].nil? and !session[:ratings].nil?
        params[:ratings] = session[:ratings]
        should_redirect = true
      elsif !params[:ratings].nil?
        session[:ratings] = params[:ratings]
      end
      if params[:active_col].nil? and !session[:active_col].nil?
        params[:active_col] = session[:active_col]
        params[:sort_dir] = session[:sort_dir]
        should_redirect = true
      elsif !params[:active_col].nil?
        session[:active_col] = params[:active_col]
        session[:sort_dir] = params[:sort_dir]
      end
      if should_redirect
        flash.keep
        redirect_to root_path params
      end
    end
  end