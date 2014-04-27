class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def to_s
    email
  end

  def image
    "http://www.irdrinternational.org/wp-content/uploads/2011/06/NO-IMAGE-AVAILABLE.jpg"
  end
end
