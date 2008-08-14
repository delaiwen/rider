$:.unshift File.dirname(__FILE__)

require 'rubygems'
require 'logger'
require 'mechanize'
require 'timeout'
require 'yaml'

require 'rider/queue'
require 'rider/part_queue'
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