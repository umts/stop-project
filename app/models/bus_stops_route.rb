# frozen_string_literal: true

class BusStopsRoute < ApplicationRecord
  belongs_to :bus_stop
  belongs_to :route

  validates :sequence, presence: true,
                       numericality: { greater_than_or_equal_to: 1 }
  validates :direction, presence: true
  validates_uniqueness_of :sequence, scope: %i[route direction]
  validates_uniqueness_of :bus_stop, scope: %i[route direction]

  def self.import(stop_hash)
    stop_hash.each_pair do |route_dir, direction_variants|
      variants = direction_variants.values
      longest_variant = variants.max_by(&:length)
      other_variants = variants - longest_variant
      other_variants.each do |other_variant|
        other_variant.each.with_index do |stop, sequence|
          unless longest_variant.include? stop
            if sequence == 0
              # first stop on longest variant that's on the other variant
              first_known_stop = longest_variant.find do |known_stop|
                other_variant.include? known_stop
              end
              if first_known_stop.present?
                # insert stop before first known stop on longest variant
                first_known_stop_index = longest_variant.index(first_known_stop)
                longest_variant.insert(first_known_stop_index, stop)
              # stop isn't on the other variant and longest variant
              else
                # add the stop onto the end of the longest variant
                longest_variant << stop
              end
            end
            # the previous stop will already be in the longest variant
            previous_stop = other_variant[sequence - 1]
            previous_stop_index_in_longest_variant = longest_variant.index(previous_stop)
            # Array#insert inserts before the given index.
            longest_variant.insert(previous_stop_index_in_longest_variant + 1, stop)
          end
        end
      end
      # overwrites the data we don't need, that is, the variants and corresponding
      # array of stop ids is condensed into one main variant pointing
      # to an array of ordered stops
      stop_hash[route_dir] = longest_variant
    end
  end
end
