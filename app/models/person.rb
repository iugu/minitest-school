class Person < ActiveRecord::Base
  attr_accessible :age, :name

  validates :name, :presence => true


  def a_method
    "OKIE DOKIE"
  end
end
