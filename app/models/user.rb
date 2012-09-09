class User < ActiveRecord::Base
  attr_accessible :name, :phone_number, :score
  before_create :init_score
  has_many :conversations

  def converstion_list
    conversations.map(&:text_id)
  end 
  
  private
  
  def init_score
    self.score = 0
  end
     
end
