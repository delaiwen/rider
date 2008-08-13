$:.unshift File.dirname(__FILE__)

require 'rubygems'
require 'logger'
require 'mechanize'
require 'eventmachine'
require 'amqp'
require 'mq'

require 'rider/queue'
require 'rider/file_queue'
require 'rider/amqp_queue'
require 'rider/crawler'

$KCODE = 'u'

module Rider
  VERSION = '0.1'
  LOGGER = Logger.new(STDOUT)
  LOGGER.level = Logger::DEBUG
  
  
  def log
    LOGGER
  end
  module_function :log
end