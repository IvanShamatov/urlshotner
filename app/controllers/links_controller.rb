class LinksController < ApplicationController
# oh that naming convention

  def new
    # here we will show form to input long url
    # just showing field

  end


  def create
    # here we will generate url short name and put original url into redis
    @link = Link.create(permit_params[:original_url])
    # after that we need to render some page to show short_url; let it be show 
    redirect_to action: "show", key: @link.short_url
  end


  def show
    @link = Link.find(params[:key])
  end


  def move
    link = Link.find(params[:key])
    redirect_to link.original_url
  rescue Link::NotFound
    redirect_to "new"
    # here we will get shot version in params and redirect to long url
    # or if there is no link we will redirect to index page
  end 


  def permit_params
    params.permit(:original_url)
  end
end
