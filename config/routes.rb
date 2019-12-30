Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: {format: :json} do
   #sessionroutes
    post 'login'           =>    'sessions#create_session'
    post 'logout'          =>    'sessions#delete_session'
    post 'signup'          =>    'sessions#signup'
    get 'session/:token'   =>    'sessions#fetch_session_details'

    #postroutes
    get  'posts'             =>    'posts#index'
    post 'posts/create'      =>    'posts#create'
    post 'posts/update/:id'  =>    'posts#update'
    delete  'posts/delete/:id'  => 'posts#delete'

    #commentroutes
    post 'comments/create'      =>    'comments#create'
    delete  'comments/delete/:id'  => 'comments#delete'

  end
end
