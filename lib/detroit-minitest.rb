module Detroit

  # The MiniTest tool runs tests. For Ruby 1.9+ `minitest/autorun` is
  # used to run the tests. For older versions of Ruby, `test/unit` is used.
  #
  class MiniTest < Tool

    # By default look for tests in test directory.
    DEFAULT_TESTS = ['test/*_test.rb', 'test/test_*.rb']

    # Test files to include.
    attr_accessor :tests

    # Test files or globs to ignore.
    attr_accessor :exclude

    # Test files to ignore by matching filename.
    attr_accessor :ignore

    # Run tests.
    def test
      requires = [autorunner] + resolved_tests

      cmd = "-e '" + requires.map{ |f| %(require "#{f}; ") } + "'"

      ruby cmd
    end

    private

    #
    def initialize_defaults
      @tests = DEFAULT_TESTS
    end

    # Resolve test globs.
    def resolved_tests
      @resolved_tests ||= amass(tests, exclude, ignore)
    end

    #
    def autorunner
      if RUBY_VERSION < '1.9'
        'test/unit'
      else
        'minitest/autorun'
      end
    end

  end

end
