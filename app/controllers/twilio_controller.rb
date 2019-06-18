require 'twilio-ruby'
require 'sanitize'

class TwilioController < ApplicationController

  def index
    render text: "Dial Me."
  end

  def ivr_welcome
    response = Twilio::TwiML::VoiceResponse.new
    gather = Twilio::TwiML::Gather.new(input: 'dtmf', num_digits: '1', action: menu_path)
    gather.say(message: "IVR Welcome - please press 1 to reach a live person or press 2 to leave a message........", loop: 1)
    response.append(gather)

    render xml: response.to_s
  end

  # GET ivr/menu_selection
  # menu_path
  def menu_selection
    user_selection = params[:Digits]
    @selection = Twilio::TwiML::VoiceResponse.new
    case user_selection
    when "1"
      @selection.say("Placing you into the queue. Please stand by till an agent answers.")
      @selection.enqueue(name: 'chef')
    when "2"
      #@selection.say(message: 'Please record your message now.')
      @selection.record(timeout: 10, method: 'POST', max_length: 20, finish_on_key: '*')
    else
      @selection.say("Returning to the main menu.")
      @selection.hangup
    end
    render xml: @selection.to_s
    binding.pry
  end

  def twiml_say(phrase, exit = false)
    # Respond with some TwiML and say something.
    # Should we hangup or go back to the main menu?
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say(phrase, voice: 'alice', language: 'en-GB')
      if exit
        r.say("Thank you for calling the ET Phone Home Service - the
        adventurous alien's first choice in intergalactic travel.")
        r.hangup
      else
        r.redirect(welcome_path)
      end
    end

    render xml: response.to_s
  end
end
