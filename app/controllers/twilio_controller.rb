require 'twilio-ruby'
require 'sanitize'

class TwilioController < ApplicationController
  def initialize
    @vr = Twilio::TwiML::VoiceResponse.new
  end

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

    case user_selection
    when "1"
      #@selection = Twilio::TwiML::VoiceResponse.new
      @vr.say(message: "Placing you into the queue. This call will be recorded. Please stand by.")
      @vr.enqueue(name: 'support')
    when "2"
      @vr.say(message: 'Please record your message now.')
      @vr.record(timeout: 10, method: 'GET', max_length: 20, finish_on_key: '*')
    when "*"
      @vr.say(message: "Your message has been saved. Goodbye.")
      @vr.hangup
    when "9"
      #@vr.say(message: "Connecting you to the caller. Please stand by.")
      @vr.dial do |dial|
        dial.queue('support', url: agent_path)
      end
      puts "@vr = #{@vr}"
    else
      @vr.say("Returning to the main menu.")
      @vr.redirect(welcome_path)
    end
    render xml: @vr.to_s
  end

  def agent
    @vr.dial do |dial|
      dial.conference('support')
    end
    puts @vr
    render xml: @vr.to_s
  end

  def connect
    @vr.say(message: 'You will now be connected to an agent.')
    puts @vr
    render xml: @vr.to_s
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
