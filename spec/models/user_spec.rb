require "spec_helper"

describe User do
  it {should respond_to :first_name}
  it {should respond_to :last_name}
  it {should respond_to :email}

  describe 'associations' do
    it {should have_many :trips}
  end
end