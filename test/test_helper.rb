require "bundler/setup"

require "minitest/autorun"
require "minitest/pride"
require "minitest/spec"
require "mocha/minitest"

require "shrine"
require "shrine/storage/memory"
require "dynamoid"

require "stringio"

require_relative "lib/dynamoid/config_loader"
require_relative "lib/dynamoid/reset"

require "minitest/byebug" if ENV["DEBUG"]

Dynamoid::ConfigLoader.load!("test/dynamoid.yml", :test)

class Minitest::Test
  def fakeio(content = "file")
    StringIO.new(content)
  end
end

class RubySerializer
  def self.dump(data)
    data.to_s
  end

  def self.load(data)
    eval(data)
  end
end
