require 'twilio-ruby'
require 'sanitize'

class TwilioController < ApplicationController

  def index
    render text: "Dial Me."
  end

  def ivr_welcome
    response = Twilio::TwiML::VoiceResponse.new
    gather = Twilio::TwiML::Gather.new(input: 'dtmf', num_digits: '1', action: :menu)
    gather.say(message: "IVR Welcome")
    response.append(gather)
    render xml: response.to_s
  end
end
