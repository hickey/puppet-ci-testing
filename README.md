# puppet-ci-testing
Ruby GEM that checks the syntax of multiple file types and integrates a number of Puppet
tests into a CI workflow. 

## check_file_syntax_ usage
The check_file_syntax script can be used to check the syntax of a set of files or be used as 
a Git pre-commit hook. Adding a directory to the command line will cause the script to 
perform syntax checks of all the files in the directory and all subdirectories recursively. 

````
Usage: check_file_syntax [options] [working dir]

Check the syntax of the following file types from the specified working
directory. If the working directory is not specified, then the current
working directory is used.

Supported file types: puppet, ruby, python, perl, bash, erb, yaml, json

Options:
    -C, --no-color                   Disable text color
    -x, --exclude DIR                Exclude directory from any syntax checks
    -j, --junit DIR                  Generate JUnit reports and deposit in DIR
    -n, --no-output                  Squelch the results on stdout (default to display)
    -g, --git-hook                   Execute as a Git pre-commit hook
````

The check_file_syntax script will check the syntax of the following types of files:

    * Ruby
    * Python
    * BASH
    * Puppet
    * ERB
    * JSON
    * YAML

## puppet_unittest_workflow Usage

The puppet_unittest_workflow script is used to integrate 


````
Usage: puppet_unittest_workflow [options]
        --[no-]lint                  Enable/disable lint parsing (Default: )
        --disable-syntax-check [TYPE]
                                     Disable syntax check for TYPE
        --enable-syntax-check [TYPE] Enable syntax checks for TYPE
        --clean-sources              Clean out dependent sources and start from scratch
        --disable-rspec              Disable rspec unittests

Config file: /Users/ghickey/smartsheet/puppet-ci-testing/etc/puppet_unittest_workflow.yaml

Default syntax checks: puppet, ruby, python, perl, bash, erb, yaml, json

Using the keyword 'all' will allow all syntax checks to be enabled or
disabled. Order of enable/disable switches are important. Using a
disable switch at the end of options will turn off all syntax checks
even if there are enable syntax check switches on the command line.
````

