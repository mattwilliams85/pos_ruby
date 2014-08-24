require 'spec_helper'

describe Purchase do
  it { should validate_presence_of :quantity }
end
