require 'test_helper'

describe Calculator do
  it "must sum two values" do
    assert_equal Calculator.sum(1,1), 2
  end
end
