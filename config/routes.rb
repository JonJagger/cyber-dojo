
CyberDojo::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'dojo#index'

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  get 'dojo/index(/:id)' => 'dojo#index'
  get 'dojo/valid_id_json(/:id)' => 'dojo#valid_id_json'
  get 'dojo/enter_json(/:id)' => 'dojo#enter_json'
  get 'dojo/re_enter_json(/:id)' => 'dojo#re_enter_json'

  get 'setup/show(/:id)' => 'setup#show'
  get 'setup/save' => 'setup#save'

  get  'kata/edit(/:id)' => 'kata#edit'
  post 'kata/run_tests(/:id)' => 'kata#run_tests'
  get  'kata/help_dialog(/:id)' => 'kata#help_dialog'

  get 'dashboard/show(/:id)' => 'dashboard#show'
  get 'dashboard/progress(/:id)' => 'dashboard#progress'
  get 'dashboard/heartbeat(/:id)' => 'dashboard#heartbeat'

  get 'differ/diff(/:id)' => 'differ#diff'
  get 'forker/fork(/:id)' => 'forker#fork'
  get 'reverter/revert(/:id)' => 'reverter#revert'

  get 'downloader/download(/:id)' => 'downloader#download'

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  #match ':controller(/:action(/:id))(.:format)'

end
