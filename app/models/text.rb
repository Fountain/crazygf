class Text < ActiveRecord::Base
  attr_accessible :category_id, :score, :text, :image_url
  attr_accessible :picture


  belongs_to :category
  
  attr_accessible :emotion_list, :tag_list, :topic_list

  acts_as_taggable
  acts_as_taggable_on :emotions, :tags, :topics
  
  belongs_to :response, :polymorphic => true
  
  require_dependency "incoming_message"
  
  has_many :incoming_messages, :as => :response do
    include IncomingMessage::ProxyMethods
  end
  
  
  
  has_attached_file :picture,
      :storage => :s3,
      :s3_credentials => S3_CREDENTIALS,
      :bucket => "crazygf"
      
  def self.get_text_for_user(user)
    if user.conversations.size == 0
      # Hardcoded first response to text id 1 ("I lost all my numbers, who is this?")
      self.find(1)
    else
      # Get random unused text
      self.find(:first, :conditions => ["id NOT IN (?)", user.conversation_list], :order => 'RANDOM()')
    end
  end
  
  def self.get_text_randomly
    self.find(:first, :order => "RANDOM()")
  end 
  
end
