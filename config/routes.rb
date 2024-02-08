Rails.application.routes.draw do
  resources :templatesg, controller: 'templatesg', except: [:show] do
    collection do
      get 'new'
      post 'new'
    end
  end

  put 'templatesg/:id/edit', to: 'templatesg#edit', as: 'update_templatesg'
  delete 'templatesg/:id', to: 'templatesg#destroy', as: 'delete_templatesg'

  resources :templates, controller: 'templates', except: [:show] do
    collection do
      get 'new'
      post 'new'
    end
  end
end

