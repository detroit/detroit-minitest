require 'detroit/tool'

module Detroit

  # Convenience method for creating a new MiniTest instance.
  def MiniTest(options={})
    MiniTest.new(options)
  end

  # The MiniTest tool runs tests. For Ruby 1.9+ `minitest/autorun` is
  # used to run the tests. For older versions of Ruby, `test/unit` is used.
  #
  class MiniTest < Tool

    # By default look for tests in test directory.
    DEFAULT_TESTS = ['test/*_test.rb', 'test/test_*.rb']

    #  A T T R I B U T E S

    # Test files to include.
    attr_reader :tests

    #
    def tests=(paths)
      @tests = [paths].flatten
    end

    # Test files or globs to ignore.
    attr_reader :exclude

    #
    def exclude=(paths)
      @exclude = [paths].flatten
    end

    # Test files to ignore by matching filename.
    attr_reader :ignore

    #
    def ignore=(paths)
      @ignore = [paths].flatten
    end

    #
    attr_reader :loadpath

    #
    def loadpath=(paths)
      @loadpath = [paths].flatten
    end

    #
    attr_reader :requires

    #
    def requires=(paths)
      @requires = [paths].flatten
    end

    #
    attr_accessor :extra

    #  A S S E M B L Y  S T A T I O N S

    #
    def station_test
      test
    end

    #  S E R V I C E  M E T H O D S

    # Run tests.
    def test
      requires = [autorunner] + self.requires

      cmd = []
      loadpath.each do |path|
        cmd << "-I#{path}"
      end     
      requires.each do |path|
        cmd << "-r#{path}"
      end
      cmd << "-e '%w{" + resolved_tests.join(' ') + "}.each{ |f| require f }'"
      cmd << extra.to_s if extra

      success = ruby(cmd.join(' '))

      abort "Aborted due to test failures. Use --force to override." unless success or force?
    end

  private

    #
    def initialize_defaults
      @tests    = DEFAULT_TESTS
      @exclude  = []
      @ignore   = []
      @loadpath = []
      @requires = []
    end

    # Resolve test globs.
    def resolved_tests
      @resolved_tests ||= (
        list = amass(tests, exclude, ignore)
        list.map{ |f| "./#{f}" }
      )
    end

    #
    def autorunner
      if RUBY_VERSION < '1.9'
        'test/unit'
      else
        'minitest/autorun'
      end
    end

  public

    def self.man_page
      File.dirname(__FILE__)+'/../man/detroit-minitest.5'      
    end

  end

end
