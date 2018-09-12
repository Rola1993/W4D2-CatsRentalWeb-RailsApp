class Cat < ApplicationRecord
  VALID_COLORS = ['BLACK', 'WHITE', 'BROWN', 'ORANGE']
  
  validates :name, :birth_date, :sex, :description, presence: true
  validates :color, :inclusion => {:in => VALID_COLORS}, presence: true
  validates :sex, :inclusion => {:in => ['M', 'F']}
  
  has_many :cat_rental_requests,
  primary_key: :id,
  foreign_key: :cat_id,
  class_name: :CatRentalRequest,
  dependent: :destroy # If a cat is destroyed than its associated rental requests will be destroyed as well.
  
  def age 
    Date.today.year - birth_date.year
  end 
end 