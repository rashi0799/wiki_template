# config/routes.rb
RedmineApp::Application.routes.draw do
  resources :templatesg, controller: 'templatesg', except: [:show]
  put 'templatesg/:id', to: 'templatesg#edit', as: 'update_templatesg'
  delete 'templatesg/:id', to: 'templatesg#destroy', as: 'delete_templatesg'
  resources :templates, controller: 'templates', except: [:show]
end

