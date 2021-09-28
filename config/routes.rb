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
      
      # 基本情報
      get 'commuting_index'
      get 'edit_basic_info'
      patch 'update_basic_info'
      
      # 出席関連
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      
      # ユーザーの残業関連
      get 'attendances/overtime'
      patch 'attendances/update_overtime', to: 'attendances#update_overtime'
      
      # ログ
      get 'attendances/log', to: 'attendances#approval_log'
      delete 'attendances/log', to: 'attendances#destroy_approval_log'
      
      # 承認関連

      # 残業申請関連
      get 'overtime_approval', to: 'admins#overtime_approval'
      patch 'update_overtime_approval', to: 'admins#update_overtime_approval'

      # 1ヶ月の勤怠申請関連
      get 'one_month_approval', to: 'admins#one_month_approval'
      patch 'request_one_month_approval', to: 'admins#request_one_month_approval'
      patch 'update_one_month_approval', to: 'admins#update_one_month_approval'
      
      # 1ヶ月の勤怠変更申請関連
      get 'edit_one_month_approval', to: 'admins#edit_one_month_approval'
      patch 'update_edit_one_month_approval', to: 'admins#update_edit_one_month_approval'      
      
    end
    resources :attendances, only: :update
  end
end