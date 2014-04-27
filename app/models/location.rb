class Location < ActiveRecord::Base
  has_many :comments
  
  def score
    return nil if comments.empty?
    comments.map {|c| c.score}.reduce(0, :+) / comments.count
  end
end
