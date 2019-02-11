Rails.application.routes.draw do
  resources :cars
  get 'home/index'
  get 'home/contact'
  get 'home/galerry'
  get 'users/index'
  get 'zad1/typ1'
  get 'zad1/typ2'
  get 'zad1/typ3'
  get 'zad1/typ4'
end
