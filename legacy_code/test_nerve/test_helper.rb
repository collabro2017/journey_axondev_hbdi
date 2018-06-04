require "minitest/autorun"
require 'nerve'
require 'celluloid/test'
require 'bundler'

require 'fixtures/mock_poller'
require 'fixtures/mock_worker'

Bundler.require(:test, :nerve)

NERVE_URL = ENV['DATABASE_URL'] || 'postgres://postgres:@localhost/nerve-test'


class NerveTest < MiniTest::Spec

  before { Celluloid.boot }
  after { Celluloid.shutdown }

  def create_supervisor(&block)
    Class.new(Celluloid::Supervision::Container, &block)
  end

  def self.disable_celluiod_logging
    before do
      @logger = Celluloid.logger
      Celluloid.logger = nil
    end

    after do
      Celluloid.logger = @logger
    end
  end

  # Add more helper methods to be used by all tests here...
end
