#--
###############################################################################
# daemonize.rb is a slightly modified version of daemonize.rb was             #
# from the Daemonize Library written by Travis Whitton                        #
# for details, read the notice below                                          #
###############################################################################
#++
#
#
# =Daemonize Library
# 
# February. 4, 2005 Travis Whitton <whitton@atlantic.net>
# 
# Daemonize allows you to easily modify any existing Ruby program to run
# as a daemon. See README.rdoc for more details.
# 
# == How to install
# 1. su to root
# 2. ruby install.rb
# build the docs if you want to
# 3. rdoc --main README.rdoc daemonize.rb README.rdoc
# 
# == Copying
# The Daemonize extension module is copywrited free software by Travis Whitton
# <whitton@atlantic.net>. You can redistribute it under the terms specified in
# the COPYING file of the Ruby distribution.
# 
# == WARRANTY
# THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
# WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR
# PURPOSE.
#
#
# ----
#
# == Purpose
# 
# Daemonize is a module derived from Perl's Proc::Daemon module. This module
# allows you to easily modify any existing Ruby program to run as a daemon.
# A daemon is a process that runs in the background with no controlling terminal.
# Generally servers (like FTP and HTTP servers) run as daemon processes.
# Note, do not make the mistake that a daemon == server. Converting a program
# to a daemon by hand is a relatively simple process; however, this module will
# save you the effort of repeatedly looking up the procedure, and it will also
# insure that your programs are daemonized in the safest and most corrects
# fashion possible.
# 
# == Procedure
# 
# The Daemonize module does the following:
# 
# Forks a child and exits the parent process.
# 
# Becomes a session leader (which detaches the program from
# the controlling terminal).
# 
# Forks another child process and exits first child. This prevents
# the potential of acquiring a controlling terminal.
# 
# Changes the current working directory to "/".
# 
# Clears the file creation mask.
# 
# Closes file descriptors.
# 
# == Example usage
# 
# Using the Daemonize module is extremely simple:
# 
#     require 'daemonize'
# 
#     class TestDaemon
#       include Daemonize
# 
#       def initialize
#         daemonize()
#         loop do
#           # do some work here
#         end
#       end
#     end
# 
# == Credits
# 
# Daemonize was written by Travis Whitton and is based on Perl's
# Proc::Daemonize, which was written by Earl Hood. The above documentation
# is also partially borrowed from the Proc::Daemonize POD documentation.


unless Process.respond_to?(:daemon)
  class << Process
    # Try to fork if at all possible retrying every 5 sec if the
    # maximum process limit for the system has been reached
    def safefork
      tryagain = true

      while tryagain
        tryagain = false
        begin
          if pid = fork
            return pid
          end
        rescue Errno::EWOULDBLOCK
          sleep 5
          tryagain = true
        end
      end
    end

    def daemon(nochdir = nil, noclose = nil)
      srand # Split rand streams between spawning and daemonized process
      safefork and exit # Fork and exit from the parent

      # Detach from the controlling terminal
      unless sess_id = Process.setsid
        raise Daemons.RuntimeException.new('cannot detach from controlling terminal')
      end

      # Prevent the possibility of acquiring a controlling terminal
      #if oldmode.zero?
        trap 'SIGHUP', 'IGNORE'
        exit if pid = safefork
      #end

      Dir.chdir "/" unless nochdir # Release old working directory
      File.umask 0000 # Insure sensible umask

      # Make sure all file descriptors are closed
      unless noclose
        ObjectSpace.each_object(IO) do |io|
          unless [STDIN, STDOUT, STDERR].include?(io)
            begin
              unless io.closed?
                io.close
              end
            rescue ::Exception
            end
          end
        end

        begin; STDIN.reopen "/dev/null"; rescue ::Exception; end       
        begin; STDOUT.reopen "/dev/null"; rescue ::Exception; end
        begin; STDERR.reopen STDOUT; rescue ::Exception; end
        STDERR.sync = true
      end
      
      #return oldmode ? sess_id : 0   # Return value is mostly irrelevant
      return sess_id
    end
  end
end