class CatRentalRequest < ApplicationRecord
  VALID_STATUS = ['APPROVED', 'PENDING', 'DENIED']
  
  validates :cat_id, :start_date, :end_date, presence: true
  validate :does_not_overlap_approved_request
  validates :status, :inclusion => {:in => VALID_STATUS}, presence: true
  
  belongs_to :cat,
  primary_key: :id,
  foreign_key: :cat_id,
  class_name: :Cat
    
  def overlapping_requests # !( B(s) > A(e) || A(s) > B(e) )
    CatRentalRequest
      .where.not(id: self.id)
      .where(cat_id: cat_id)
      .where.not('start_date > :end_date OR end_date < :start_date', start_date: start_date, end_date: end_date)
  end 
  
  def overlapping_approved_requests
    overlapping_requests.where("status = 'APPROVED'")
  end
  
  def does_not_overlap_approved_request
    if overlapping_approved_requests.exists?
      errors[:base] << 'Overlapping requests!'
    end 
  end
end 