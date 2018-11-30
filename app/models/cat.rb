class Cat < ApplicationRecord
  VALID_COLORS = ['BLACK', 'WHITE', 'BROWN', 'ORANGE']
  
  validates :name, :birth_date, :sex, :description, presence: true
  validates :color, inclusion: VALID_COLORS
  validates :sex, inclusion: %w(M F)
  
  has_many :rental_requests,
  primary_key: :id,
  foreign_key: :cat_id,
  class_name: :CatRentalRequest,
  dependent: :destroy # If a cat is destroyed than its associated rental requests will be destroyed as well.
  
  def age 
    Date.today.year - birth_date.year
  end 
end 