require 'spec_helper'

describe Location do
  describe 'associations' do
    it {should belong_to(:user)}
  end
end
