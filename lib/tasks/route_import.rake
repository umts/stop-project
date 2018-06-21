# frozen_string_literal: true

require 'csv'

# Example invocation rake 'routes:import[some_csv_file.csv]'

namespace :routes do
  task :import, [:csv_file] => :environment do |_, args|
    Route.delete_all
    BusStopsRoute.delete_all
    @route_hash = {}
    @sequenced_bsrs = []
    CSV.foreach(args[:csv_file], headers: true, col_sep: ';') do |row|
      stop = BusStop.find_by hastus_id: row['stp_identifier']
      if stop.present?
        route = Route.find_or_create_by number: row['rte_identifier'].strip

        direction = row['direction']
        variant = row['variant']
        stop_id = row['stp_identifier']
        sequence = row['stop_variant_rank']

        @route_hash[route] ||= {}
        @route_hash[route][direction] ||= {}
        @route_hash[route][direction][variant] ||= []
        @route_hash[route][direction][variant] << { stop_id => sequence }
      end
    end

    @stop_list = []
    @other_variants = []

    @route_hash.each do |route, directions|
      # determine the longest variant
      directions.each do |direction, variants|
        @main_variant = nil
        @max_length = 0
        variants.each_key do |variant|
          if @max_length.zero?
            @main_variant = variant
            @max_length = @route_hash[route][direction][@main_variant].length
          elsif @route_hash[route][direction][variant].length > @max_length
            @other_variants << @main_variant
            @max_length = @route_hash[route][direction][variant].length
            @main_variant = variant
          else
            @other_variants << variant
          end
        end

        # take longest variant and assign sequence number to stops
        @route_hash[route][direction][@main_variant].each do |stop_hash|
          stop_hash.each do |hastus_id, rank|
            sequence = rank.to_i
            @sequenced_bsrs << { hastus_stop_id: hastus_id, route: route, direction: direction, sequence: sequence }
            @stop_list << hastus_id
          end
        end

        # stops not in longest variant but on route are added to the end of longest variant.
        if @other_variants.present?
          sequence = @max_length
          @other_variants.each do |other_variant|
            @route_hash[route][direction][other_variant].each do |stop_hash|
              stop_hash.each_key do |hastus_id|
                next if @stop_list.include?(hastus_id)
                sequence += 1
                @sequenced_bsrs << { hastus_stop_id: hastus_id, route: route, direction: direction, sequence: sequence }
              end
            end
          end
        end
        # remove variants from the array if there were any in there to begin with
        @other_variants = []
        # remove stops from the array
        @stop_list = []
      end
    end

    # create bus stops routes here by looping through sequenced_hash
    @sequenced_bsrs.each do |bsr_attrs|
      BusStopsRoute.create! bsr_attrs
    end
  end
end
