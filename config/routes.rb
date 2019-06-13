Rails.application.routes.draw do

  # Root of the app
  root 'twilio#index'

  # webhook for your Twilio number
  match 'ivr/welcome' => 'twilio#ivr_welcome', via: [:get, :post], as: 'welcome'

  # callback for user entry
  match 'ivr/menu' => 'twilio#menu_selection', via: [:get, :post], as: 'menu'

  # callback for planet entry
  match 'ivr/options' => 'twilio#option_selection', via: [:get, :post], as: 'options'

end
