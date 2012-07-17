require 'test_helper'

describe Person do
  subject { Person.new }
  
  must { validate_presence_of( :name ) }

  it "must return OKIE DOKIE on a_method" do
    subject.a_method.must_equal "OKIE DOKIE"
  end

  it "must have a name" do
    subject.name = nil
    assert !subject.save
  end
end
