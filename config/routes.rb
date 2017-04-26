Rails.application.routes.draw do

  # for health check on aws
  get '/knock-knock', to: proc { [200, {}, ['']] }

  defaults format: 'json' do
    scope '/v1' do
      resources :prescription_requests, only: [:create]
      resources :medications, only: [:index]
      resources :recommended_links, only: [:index]
      resources :pending_recommended_links, only: [:create]

      post 'medications/batch_create', to: 'medications#batch_create'
      post 'medications/batch_update', to: 'medications#batch_update'
      post 'medications/batch_delete', to: 'medications#batch_delete'

      post 'medications/load_info', to: 'medications#load_info'
      post 'medications/verify_ndc', to: 'medications#verify_ndc'

      get 'password/reset', to: 'password#reset', format: :html

      # resources :refill_infos, except: [:new, :edit]

      resources :pharmacies, except: [:new, :edit]
      resources :doctors, except: [:new, :edit]

      resources :reminders, except: [:new, :edit]

      resources :pending_medications, only: [:create]
      resources :pending_insurance_cards, only: [:create]

      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations:  'overrides/registrations',
        passwords: 'overrides/passwords'
      }

      get 'users/email-valid' => 'users#is_email_unique'

      post 'help/feedback' => 'feedback#send_feedback'

      scope '/vitals' do
        resources :blood_pressures, except: [:new, :edit]
        resources :pulse_oxygens, except: [:new, :edit]
        resources :temperatures, except: [:new, :edit]
        resources :weights, except: [:new, :edit]
        resources :glucoses, except: [:new, :edit, :update, :destroy]
        resources :glucose_strip_bottle, except: [:new, :edit, :update, :destroy]

        post 'glucose_strip_bottle/decrement_strip_count', to: 'glucose_strip_bottle#decrement_strip_count'
        post 'glucose_strip_bottle/set_strip_count', to: 'glucose_strip_bottle#set_strip_count'

        post 'blood_pressures/batch_create', to: 'blood_pressures#batch_create'
        post 'pulse_oxygens/batch_create', to: 'pulse_oxygens#batch_create'
        post 'temperatures/batch_create', to: 'temperatures#batch_create'
        post 'weights/batch_create', to: 'weights#batch_create'
        post 'glucoses/batch_create', to: 'glucoses#batch_create'
      end
    end

    scope '/admin/v1' do
      resources :medications, except: [:new, :edit]
      # resources :refill_infos, except: [:new, :edit]
      get 'medications/is_refill/:rx_num' => 'medications#is_refill'
      get 'medications_by_refill' => 'medications#by_refill'
      post 'create_med_or_refill/:pending_med_id' => 'pending_medications#create_med_or_refill'
      post 'medications/load_info', to: 'medications#load_info'
      post 'medications/verify_ndc', to: 'medications#verify_ndc'

      resources :pending_medications, except: [:new, :edit]
      resources :pending_insurance_cards, except: [:new, :edit]
      resources :pharmacies, except: [:new, :edit]
      resources :doctors, except: [:new, :edit]

      resources :recommended_links, only: [:index, :create, :update, :destroy]
      resources :pending_recommended_links, only: [:index, :destroy]

      get '/pending_medications/:id/image/:idx' => 'pending_medications#image'
      get '/pending_insurance_cards/:id/image/:idx' => 'pending_insurance_cards#image'
      post '/update_insurance/:id' => 'pending_insurance_cards#update'
      post '/insurance_need_more_info/:id' => 'pending_insurance_cards#needMoreInfo'

      mount_devise_token_auth_for 'AdminUser', at: 'auth'
    end

    scope '/provider/v1' do

      resources :prescription_requests
      resources :glucoses, except: [:new, :edit, :update]
      post '/prescription_requests/update', to: 'prescription_requests#update'

      mount_devise_token_auth_for 'ProviderUser', at: 'auth'
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
