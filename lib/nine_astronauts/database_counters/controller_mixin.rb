#
# = DatabaseCounters
#
# Adds two database counters to the log for a request:
#
#  - total number of requests that were made
#  - total number of rows that were returned
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
    module ControllerMixin
      
      def self.included(controller) # :nodoc:
        controller.extend(ClassMethods)
        controller.send(:include, InstanceMethods)
        controller.class_eval do
          alias_method_chain :active_record_runtime, :database_counters
        end
        controller.before_filter(:reset_database_counters)
      end
      
      module ClassMethods
        #
        # turns the database counters on or off
        #
        def database_counters(state=:on)
          if 'on' == state.to_s.downcase
            NineAstronauts::DatabaseCounters::Counters.activate!
          else
            NineAstronauts::DatabaseCounters::Counters.deactivate!
          end
        end
      end
      
      
      module InstanceMethods
        #
        # wraps the default active_record benchmarking output and extends it
        # to include the total number of database calls made and rows returned
        # during the processing of the current request.
        #
        # default output (in log entry starting with "Completed in..."):
        #
        #    ... | DB: 3.14276 (97%) | ...
        #
        # extended output:
        #
        #    ... | DB: 3.14276 (97%) Calls: 27 Rows: 43 | ...
        #
        def active_record_runtime_with_database_counters(runtime)
          if NineAstronauts::DatabaseCounters::Counters.active?
            "%s Calls: %d Rows: %d" % [
              active_record_runtime_without_database_counters(runtime),
              NineAstronauts::DatabaseCounters::Counters.queries,
              NineAstronauts::DatabaseCounters::Counters.rows
            ]
          else
            active_record_runtime_without_database_counters(runtime)
          end
        end
        
        # clears the counters used to benchmark database access for the current
        # request.  currently tracks the number of database calls made and the
        # number of rows returned.
        #
        def reset_database_counters
          NineAstronauts::DatabaseCounters::Counters.reset!
        end
      end
      
    end
  end
end
  

