#
# = DatabaseCounters
#
# Adds two database counters to the log for a request:
#
#  - total number of requests that were made
#  - total number of rows that were returned
#
#
# Author::    mike demers <mike_[AT]_9astronauts.com>
# Homepage::  <http://9astronauts.com/code/database_counters>
# Copyright:: Copyright (c) 2007-8 Nine Astronauts
# License::   Distributed under the same terms as Ruby
#
#
require 'nine_astronauts/database_counters/version'
require 'nine_astronauts/database_counters/controller_mixin'
require 'nine_astronauts/database_counters/connection_mixin'
