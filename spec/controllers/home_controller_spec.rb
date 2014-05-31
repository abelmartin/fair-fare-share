require 'spec_helper'

describe HomeController do
  it "doesn't assign @debug_stops" do
    get :index
    assigns(:debug_stops).should be_nil
  end
end
