Ffs::Application.routes.draw do
  # You can have the root of your site routed with "root"
  root 'home#index'

  get 'home/getShares' => 'home#getShares'
  get 'home/verifyWaypoint' => 'home#verifyWaypoint'
end
