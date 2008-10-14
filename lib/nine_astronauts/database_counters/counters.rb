#
# = Counters
#
# Maintains global database counters.
#
#--
# Author::    mike demers <mike_[AT]_9astronauts.com>
# Homepage::  <http://9astronauts.com/code/database_counters>
# Copyright:: Copyright (c) 2007-8 Nine Astronauts
# License::   Distributed under the same terms as Ruby
#
#++
module NineAstronauts
  module DatabaseCounters
    class Counters
      
      class << self
        
        # are the database counters active?
        #
        def active?
          @status || false
        end
        
        
        # activates the database counters
        #
        def activate!
          @status = true
        end
        
        
        # deactivates the database counters
        #
        def deactivate!
          @status = false
        end
        
        
        # resets the database counters (for the current process)
        #
        def reset!
          row_counter[Process.pid] = query_counter[Process.pid] = 0
        end
        
        
        # number of database queries executed by the current process
        #
        def queries
          query_counter[Process.pid].to_i
        end
        
        
        # number of database rows returned to the current process
        #
        def rows
          row_counter[Process.pid].to_i
        end
        
        
        # increases the row counter by +n+ (for the current process)
        #
        def increment_rows!(n=1)
          row_counter[Process.pid] = rows + n
        end
        
        
        # increases the query counter by +n+ (for the current process)
        #
        def increment_queries!(n=1)
          query_counter[Process.pid] = queries + n
        end
        
      private
        
        def row_counter
          @rows ||= {}
        end
        
        def query_counter
          @queries ||= {}
        end
      end
      
    end
  end
end
