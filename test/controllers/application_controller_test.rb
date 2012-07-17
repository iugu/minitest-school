require 'test_helper'

describe ApplicationController do
  
  it "must have a method that return OKIE DOKIE" do
    @controller.apc_method.must_equal "OKIE DOKIE" 
  end
end
