require 'singleton'
require 'time'

module SimpleJUnit

  class TestSuiteCollection

    include Singleton

    attr :testsuites

    def initialize
      @testsuites = []
    end

    def create_testsuite(name)
      @testsuites << SimpleJUnit::TestSuite.new(name)
      @testsuites.last
    end

    def to_s
      return <<-EOTC
<?xml version="1.0" encoding="UTF-8"?>
<testsuites>
#{(@testsuites.each {|ts| ts.to_s}).join}
</testsuites>
EOTC
    end
  end


  class TestSuite

    attr :name
    attr_accessor :testcases

    def initialize(name)
      @name = name
      @timestamp = Time.now()
      @testcases = []
    end

    def add_testcase(testcase)
      unless @testcases.include? testcase
        @testcases << testcase
      end
    end

    def create_testcase(name, desc)
      @testcases << TestCase.new(name, desc)
      @testcases.last
    end

    def to_s
      num_testcase = @testcases.count
      num_failures = (@testcases.select {|tc| tc.failed?}).count

      return <<-EOTS
  <testsuite name="#{@name}" errors="0" tests="#{num_testcase}" failures="#{num_failures}" time="0" timestamp="#{@timestamp.iso8601}">
    <properties/>
#{(@testcases.collect {|tc| tc.to_s}).join}
  </testsuite>
EOTS
    end
  end


  class TestCase

    attr :classname
    attr :description
    attr :duration
    attr :status
    attr :errors
    attr :output

    def initialize(name, desc=nil, duration=nil)
      @classname = name
      @description = desc
      @duration = duration
      @status = :pending
      @errors = nil
      @output = nil
    end

    def passed(output=nil, errors=nil)
      @status = :passed
      unless output.nil?
        @output = output
      end
      unless errors.nil?
        @errors = errors
      end
    end

    def passed?
      @status == :passed
    end

    def failed(type=nil, output=nil, errors=nil)
      @status = :failed
      @error_type = type || 'unspecified'
      unless output.nil?
        @output = output
      end
      unless errors.nil?
        @errors = errors
      end
    end

    def failed?
      @status == :failed
    end

    def pending?
      @status == :pending
    end

    def skip
      @status = :skipped
    end

    def skipped?
      @status == :skipped
    end

    def start
      @started = Time.now
    end

    def finish
      @duration = Time.now - @started
    end


    def to_s
      xml = "    <testcase classname=\"#{@classname}\" "
      unless @description.nil?
        xml += "name=\"#{@description}\" "
      end
      xml += "time=\"#{@duration}\">\n"

      case @status
      when :skipped
        xml += "      <skipped/>\n"
      when :failed
        xml += "      <failure message=\"#{@error_type}\">#{@errors}</failure>\n"
      end

      xml += "      <system-out>#{@output}</system-out>\n" if @output
      xml += "      <system-err>#{@errors}</system-err>\n" if @errors

      xml += "    </testcase>\n"
      return xml
    end

  end
end