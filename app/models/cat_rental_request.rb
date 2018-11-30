class CatRentalRequest < ApplicationRecord
  VALID_STATUS = %w(APPROVED DENIED PENDING).freeze
  
  validates :cat_id, :start_date, :end_date, presence: true
  validate :does_not_overlap_approved_request
  validates :status, inclusion: VALID_STATUS
  
  belongs_to :cat,
  primary_key: :id,
  foreign_key: :cat_id,
  class_name: :Cat

  def approve!
    raise 'not pending' unless self.status == 'PENDING'
    transaction do 
      self.status = 'APPROVED'
      self.save!

      overlapping_pending_requests.each do |req|
        req.update!(status: 'DENIED')
      end 
    end 
  end 

  def approved?
    self.status == 'APPROVED'
  end 

  def denied?
    self.status == 'DENIED'
  end 

  def deny!
    self.status = 'DENIED'
    self.save!
  end 

  def pending?
    self.status == 'PENDING'
  end

  private

  def assign_pending_status
    self.status ||= 'PENDING'
  end 
    
  def overlapping_requests # !( B(s) > A(e) || A(s) > B(e) )
    # We want:
    # 1. A different request
    # 2. That is for the same cat.
    # 3. That overlaps.
    CatRentalRequest
      .where.not(id: self.id)
      .where(cat_id: cat_id)
      .where.not('start_date > :end_date OR end_date < :start_date', start_date: start_date, end_date: end_date)
  end 
  
  def overlapping_approved_requests
    overlapping_requests.where("status = 'APPROVED'")
  end
  
  def overlapping_pending_requests
    overlapping_requests.where("status = 'PENDING'")
  end

  def does_not_overlap_approved_request
   # A denied request doesn't need to be checked. A pending request
    # should be checked; users shouldn't be able to make requests for
    # periods during which a cat has already been spoken for.
    return if self.denied?

    if overlapping_approved_requests.exists?
      errors[:base] << 'Overlapping requests!'
    end 
  end

  
end 