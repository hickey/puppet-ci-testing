require 'spec_helper'
require 'simple_junit'

describe 'SimpleJUnit' do
  describe 'TestSuiteCollection' do 
    it 'creates an empty test suite collection' do
      tc = SimpleJUnit::TestSuiteCollection.instance
      expect(tc.testsuites).to eq []
      tc.reset
    end
    
    it 'creates two test suite collections' do
      tc = SimpleJUnit::TestSuiteCollection.instance
      tc.create_testsuite('foo')
      tc.create_testsuite('bar')
      expect(tc.testsuites.count).to eq 2
      tc.reset
    end
    
    it 'generates valid JUnit XML output' do
      tc = SimpleJUnit::TestSuiteCollection.instance
      xml = tc.to_s.gsub(/\n\s*/, "")
      expect(xml).to match /<\?xml version="1.0" encoding="UTF-8"\?><testsuites><\/testsuites>/
      tc.reset
    end
    
    it 'generates valid JUnit XML output with test suites' do
      tc = SimpleJUnit::TestSuiteCollection.instance
      tc.create_testsuite('foo')
      tc.create_testsuite('bar')
      xml = tc.to_s.gsub(/\n\s*/, "")
      expect(xml).to match /<\?xml version="1.0" encoding="UTF-8"\?>/
      expect(xml).to match /\s*<testsuite name="foo" errors="0" tests="0" failures="0" time="0" timestamp="[^\"]+">/
      expect(xml).to match /\s*<testsuite name="bar" errors="0" tests="0" failures="0" time="0" timestamp="[^\"]+">/
      tc.reset
    end
  end
  
  
  describe 'TestSuite' do
    it 'generates valid XML' do
      name = random_string(5)
      ts = SimpleJUnit::TestSuite.new(name)
      t1 = random_string(3)
      ts.create_testcase(t1).passed
      t2 = random_string(3)
      ts.create_testcase(t2).failed
      t3 = random_string(3)
      ts.create_testcase(t3).failed
      t4 = random_string(3)
      ts.create_testcase(t4).passed
      t5 = random_string(3)
      ts.create_testcase(t5).skip
      xml = ts.to_s.gsub(/\n\s*/, "")
      expect(xml).to match /<testsuite name="#{name}" errors="0" tests="5" failures="2" time="0" timestamp="[^"]+"><properties\/><testcase classname="#{t1}" time=""><\/testcase><testcase classname="#{t2}" time=""><failure message="unspecified"><\/failure><\/testcase><testcase classname="#{t3}" time=""><failure message="unspecified"><\/failure><\/testcase><testcase classname="#{t4}" time=""><\/testcase><testcase classname="#{t5}" time=""><skipped\/><\/testcase><\/testsuite>/
    end
    
  end
  
  
  describe 'TestCase' do
    it 'passed() sets internal state correctly' do
      t = SimpleJUnit::TestCase.new('foo')
      output = random_string(30)
      error = random_string(20)
      t.passed(output: output, error: error)
      expect(t.status).to eq :passed
      expect(t.output).to eq output
      expect(t.errors).to eq error
    end
    
    it 'passed? test correct' do
      t = SimpleJUnit::TestCase.new('foo')
      expect(t.passed?).to eq false
      t.passed
      expect(t.passed?).to eq true
      t.failed
      expect(t.passed?).to eq false
      t.skip
      expect(t.passed?).to eq false
    end
    
    it 'failed() sets internal state correctly with error type' do
      t = SimpleJUnit::TestCase.new('foo')
      output = random_string(30)
      error = random_string(20)
      t.failed(type:'bar', output:output, error:error)
      expect(t.status).to eq :failed
      expect(t.output).to eq output
      expect(t.errors).to eq error
    end
    
    it 'failed() sets internal state correctly without error type' do
      t = SimpleJUnit::TestCase.new('foo')
      output = random_string(30)
      error = random_string(20)
      t.failed(:output => output, :error => error)
      expect(t.status).to eq :failed
      expect(t.output).to eq output
      expect(t.errors).to eq error
    end
    
    it 'failed? test correct' do
      t = SimpleJUnit::TestCase.new('foo')
      expect(t.failed?).to eq false
      t.failed
      expect(t.failed?).to eq true
      t.passed
      expect(t.failed?).to eq false
      t.skip
      expect(t.passed?).to eq false
    end
    
    it 'pending? test correct' do
      t = SimpleJUnit::TestCase.new('foo')
      expect(t.pending?).to eq true
      t.failed
      expect(t.pending?).to eq false
      t.passed
      expect(t.pending?).to eq false
      t.skip
      expect(t.pending?).to eq false
    end
    
    it 'skipped? test correct' do
      t = SimpleJUnit::TestCase.new('foo')
      expect(t.skipped?).to eq false
      t.failed
      expect(t.skipped?).to eq false
      t.passed
      expect(t.skipped?).to eq false
      t.skip
      expect(t.skipped?).to eq true
    end
    
    it 'duration is calculated correctly' do
      t = SimpleJUnit::TestCase.new('foo')
      t.start
      sleep(2)
      t.finish
      expect(t.duration.to_i).to eq 2
    end
    
    it 'generates correct XML' do
      name = random_string(5)
      type = random_string(7)
      output = random_string(13)
      error = random_string(11)
      t = SimpleJUnit::TestCase.new(name)
      t.passed(output: output, error: error)
      xml = t.to_s.gsub(/\n\s*/, '')
      expect(xml).to match /<testcase classname="#{name}" time=""><system-out>#{output}<\/system-out><system-err>#{error}<\/system-err><\/testcase>/
    end
  end
end

    