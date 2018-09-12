class CatRentalRequestsController < ApplicationController
  
  def new # The edit form tries to use a Cat's values to pre-fill the fields. The new form doesn't have an existing cat
    @cat_rental_request = CatRentalRequest.new # build (but don't save) a blank Cat object in the #new action. Set this to @cat
    render :new
  end 
  
  def create
    @cat_rental_request = CatRentalRequest.new(params.permit(:start_date, :end_date, :cat_id))

    if @cat_rental_request.save
      redirect_to cats_url
    else
      render :new
    end
  end
end 