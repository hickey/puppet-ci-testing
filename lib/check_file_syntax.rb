require 'colorize'
require 'json'
require 'yaml'
require 'find'


module CheckFileSyntax

  ALL_CHECKS = [:puppet, :ruby, :python, :perl, :bash, :erb, :yaml, :json]

  module_function
  def type_of_file(path, interpreter, extensions)
    # check extensions first
    [extensions].flatten.each {|ext| return true if path.end_with? ext }

    # check only if really a file and is not 0 byte
    if File.file?(path) and File.size?(path)
      # Look for a she-bang line and check for interpreter
      shebang = File.open(path).first
      if shebang and shebang.start_with? '#!/' and shebang.include? interpreter.to_s
        return true
      end
    end
    return false
  end

  # define a bunch of convenience functions
  def puppet_file?(path)
    type_of_file(path, :puppet, '.pp')
  end

  def erb_file?(path)
    type_of_file(path, :erb, '.erb')
  end

  def python_file?(path)
    type_of_file(path, :python, '.py')
  end

  def ruby_file?(path)
    type_of_file(path, :ruby, '.rb')
  end

  def perl_file?(path)
    type_of_file(path, :perl, ['.pl', '.pm'])
  end

  def bash_file?(path)
    type_of_file(path, :bash, ['.sh', '.bash', '.zsh', '.ksh'])
  end

  def json_file?(path)
    type_of_file(path, :json, '.json')
  end

  def yaml_file?(path)
    type_of_file(path, '---', ['.yaml', '.yml'])
  end


  module_function
  def show_status (name, success, errors)
    if success == :passed
      puts '   OK   '.colorize(:green) + "  #{name}".colorize(:cyan)
    else
      puts '  FAIL  '.colorize(:light_yellow).swap + "  #{name}".colorize(:cyan)
      puts errors
    end
  end


  module_function
  def search_all_files_for_errors(directory, excludes=[], checks=ALL_CHECKS, &block)
    error_count = 0
    Find.find(directory) do |path|
      # prune the directory tree if we found a directory that should be excluded
      if File.directory? path
        if not (excludes.select { |d| path.end_with? d }).empty?
          Find.prune
        else
          # we don't do any thing with dirs, so go to next item
          next
        end
      end

      # TODO Need to look at checks to determine if we should do this
      check_file_syntax(path) do |path, status, errors|
        if status == :failed
          error_count += 1
        end

        if block_given?
          yield path, status, errors
        else
          show_status(path, status, errors)
        end
      end
    end
    return error_count
  end


  module_function
  def check_file_syntax(path, &block)
    errors = ''
    status = nil

    if puppet_file? path
      if system('which puppet >/dev/null')
        errors = `puppet parser validate #{path} 2>&1`
        status = $?.success? ? :passed : :failed
      else
        puts 'Consider installing puppet so that syntax can be checked.'.colorize(:yellow)
        status = :skipped
      end
    end

    if erb_file? path
      errors = `cat #{path} | erb -x -T - | ruby -c 2>&1`
      status = $?.success? ? :passed : :failed
    end

    if python_file? path
      if system('which python >/dev/null')
        errors = `python -m py_compile #{path} 2>&1`
        status = $?.success? ? :passed : :failed
      else
        puts 'Consider installing python so that syntax can be checked.'.colorize(:yellow)
        status = :skipped
      end
    end

    if ruby_file? path
      errors = `ruby -c #{path} 2>&1`
      status = $?.success? ? :passed : :failed
    end

    if perl_file? path
      if system('which perl >/dev/null')
        errors = `perl -c #{path} 2>&1`
        status = $?.success? ? :passed : :failed
      else
        puts 'Consider installing perl so that syntax can be checked.'.colorize(:yellow)
        status = :skipped
      end
    end

    if bash_file? path
      errors = `bash -n #{path} 2>&1`.to_i
      status = $?.success? ? :passed : :failed
    end


    if json_file? path
      begin
        JSON.parse(File.read(path))
        status = :passed
      rescue Exception => e
        errors = e.message
        status = :failed
      end
    end

    if yaml_file? path
      begin
        YAML.parse(File.read(path))
        status = :passed
      rescue Exception => e
        errors = e.message
        status = :failed
      end
    end

    if block_given?
      yield path, status, errors
    else
      show_status(path, status, errors)
      error_count += 1 if status == :failed
    end
  end
end