class MoviesController < ApplicationController


    def sort
      @movies = Movie.all
    end

    def show
      session[:ratings] ||= params[:ratings]
      session[:sort_by] ||= params[:sort_by]
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index

      if params[:home] == nil
        params[:ratings] ||= session[:ratings]
        params[:sort_by] ||= session[:sort_by]
      end

      if params[:ratings] != nil
        ratings_arr = params[:ratings].keys
        @ratings_to_show = ratings_arr
      end
      @movies = Movie.with_ratings(ratings_arr)

      if params[:sort_by] != nil
        @movies = @movies.order("#{params[:sort_by]} ASC").all
      else
        @movies = @movies.all
      end
      
      if params[:sort_by] == 'title'
        @title_header = 'bg-warning'
        @sort_by = 'title'
      elsif params[:sort_by] == 'release_date'
        @release_date_header ='bg-warning'
        @sort_by = 'release_date'
      end
    end
        # redirect_to movies_path
    
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

    before_filter :set_my_variables
    # before_render :set_session

    private
    def set_my_variables
      @all_ratings = Movie.all_ratings
      @ratings_to_show = []
      @title_header = 'bg-transparent'
      @release_date_header = 'bg-transparent'
      @sort_by = nil
    end
  end