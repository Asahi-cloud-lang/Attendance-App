Rails.application.routes.draw do
  get 'admins/show'

  get 'bases/show'

  root 'static_pages#top'
  get '/signup', to: 'users#new'

  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users do
    collection { post :import }
    member do
      # 拠点関連
      get 'bases/edit', to: 'bases#edit'
      get 'bases', to: 'bases#show'
      patch 'bases', to: 'bases#update'
      delete 'bases', to: 'bases#destroy'
      
      # 拠点関連
      get 'commuting_index'
      get 'edit_basic_info'
      patch 'update_basic_info'
      
      # 出席関連
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      
      # 残業関連
      get 'attendances/overtime'
      
      # 承認関連
      get 'attendance_change_approval', to: 'admins#attendance_change_approval'
      patch 'request_one_month_approval', to: 'admins#request_one_month_approval'
      patch 'update_one_month_approval', to: 'admins#update_one_month_approval'
      get 'one_month_approval', to: 'admins#one_month_approval'
      get 'overtime_approval', to: 'admins#overtime_approval'
      
    end
    resources :attendances, only: :update
  end
end