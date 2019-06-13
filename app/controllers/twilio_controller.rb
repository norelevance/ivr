require 'twilio-ruby'
require 'sanitize'

class TwilioController < ApplicationController

  def index
    render text: "Dial Me."
  end

  def ivr_welcome
    response = Twilio::TwiML::VoiceResponse.new
    gather = Twilio::TwiML::Gather.new(input: 'dtmf', num_digits: '1', action: menu_path)
    gather.say(message: "IVR Welcome - please press 1 to reach a live person or press 2 to leave a message.", loop: 3)
    response.append(gather)

    render xml: response.to_s
  end

  # GET ivr/menu_selection
  # menu_path
  def menu_selection(*args)
    user_selection = params[:Digits]

    case user_selection
    when "1"
      @output = Twilio::TwiML::VoiceResponse.new
      @output.say(message: "Placing you into the queue. Please stand by till an agent answers.")
      @output.enqueue(name: 'chef')
    when "2"
      voicemail
    else
      @output.say("Returning to the main menu.")
      @output.redirect(:welcome) and return
    end
    render xml: @output.to_s
  end

  def enqueue
    enqueue = Twilio::TwiML::VoiceResponse.new
    enqueue.say(message: 'Enqueued.')
    enqueue.enqueue(message: 'Option selection enqueue', wait_url: 'wait-music.xml', name: 'chef')

    enqueue.to_xml
  end

  def voicemail
    vm = Twilio::TwiML::VoiceResponse.new
    vm.say(message: 'Please record your message now.')
    vm.record(timeout: 10, method: 'GET',
              max_length: 20, finish_on_key: '*')
    vm.say(message: 'I did not receive a recording')
    puts vm
  end
end
