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
    module ConnectionMixin
      def self.included(conn) # :nodoc:
        conn.send(:include, InstanceMethods)
        conn.class_eval do
          alias_method_chain :execute, :database_counters
          alias_method_chain :select, :database_counters
        end
      end
      
      module InstanceMethods
      private
        #
        # wrap calls to the +execute+ method of the database connection
        # so that the number of queries can be tracked
        #
        def execute_with_database_counters(*args)
          if NineAstronauts::DatabaseCounters::Counters.active?
            NineAstronauts::DatabaseCounters::Counters.increment_queries!
          end
          execute_without_database_counters(*args)
        end
        
        #
        # wrap calls to the +select+ method of the database connection
        # so that the number of result rows can be tracked
        #
        def select_with_database_counters(*args)
          rows = select_without_database_counters(*args)
          if NineAstronauts::DatabaseCounters::Counters.active?
            NineAstronauts::DatabaseCounters::Counters.increment_rows!(rows.size)
          end
          rows
        end
      end
      
    end
  end
end
