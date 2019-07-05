Rails.application.routes.draw do

  # Root of the app
  root 'twilio#index'

  # webhook for your Twilio number
  match 'ivr/welcome' => 'twilio#ivr_welcome', via: [:get, :post], as: 'welcome'

  # callback for user entry
  match 'ivr/menu' => 'twilio#menu_selection', via: [:get, :post], as: 'menu'

  # callback for caller option selection
  match 'ivr/options' => 'twilio#option_selection', via: [:get, :post], as: 'options'

  #callback for dialing a enqueue
  match 'ivr/agent' => 'twilio#agent', via: [:get, :post], as: 'agent'

  #callback for connect message to Caller
  match 'ivr/connect' => 'twilio#connect', via: [:get, :post], as: 'connect'

end
