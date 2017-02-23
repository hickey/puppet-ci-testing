require 'spec_helper'
require 'check_file_syntax'

describe 'CheckFileSyntax' do
  
  { :json   =>  '.json', 
    :yaml   =>  ['.yaml','.yml'],
    :perl   =>  ['.pl','.pm'],
    :bash   =>  ['.sh','.bash','.zsh','.ksh'],
    :ruby   =>  '.rb', 
    :python =>  '.py', 
    :erb    =>  '.erb',
    :puppet =>  '.pp' }.each_pair do |type, exts|
      [exts].flatten.each do |ext|
        it "identifies #{type} with #{ext} extension" do
          expect(CheckFileSyntax::type_of_file("foo#{ext}", type, exts)).to eq true
        end
      end
    end
  
  { :json   =>  '.json', 
    :yaml   =>  ['.yaml','.yml'],
    :perl   =>  ['.pl','.pm'],
    :bash   =>  ['.sh','.bash','.zsh','.ksh'],
    :ruby   =>  '.rb', 
    :python =>  '.py', 
    :erb    =>  '.erb',
    :puppet =>  '.pp' }.each_pair do |type, exts|
      bad_ext = random_string(8)
      [exts].flatten.each do |ext|
        it "fails identifying #{type} without #{ext} extension" do
          expect(CheckFileSyntax::type_of_file("foo.#{bad_ext}", type, exts)).to eq false
        end
      end
    end
    
  CheckFileSyntax::ALL_CHECKS.each do |type|
    bad_ext ||= random_string(8)
    # Puppet, ERB, JSON and YAML files don't have shebang lines
    unless [:puppet, :erb, :json, :yaml].include? type
      it "identifies content as #{type}" do
        filename = eval "generate_#{type.to_s}(:valid, extension:'.#{bad_ext}')"
        expect(CheckFileSyntax::type_of_file(filename, type, '.foo')).to eq true
        File.unlink filename
      end
    end
  end
  
  CheckFileSyntax::ALL_CHECKS.each do |type|
    it "identifies valid syntax of #{type}" do
      filename = eval "generate_#{type.to_s}(:valid)"
      CheckFileSyntax::check_file_syntax(filename) { |path, status, errors|
        expect(status).to eq :passed
      }
      File.unlink filename
      File.unlink "#{filename}c" if type == :python
    end
  end

  CheckFileSyntax::ALL_CHECKS.each do |type|
    it "identifies invalid syntax of #{type}" do
      filename = eval "generate_#{type.to_s}(:invalid)"
      CheckFileSyntax::check_file_syntax(filename) { |path, status, errors|
        expect(status).to eq :failed
      }
      File.unlink filename
    end
  end
  
  
end