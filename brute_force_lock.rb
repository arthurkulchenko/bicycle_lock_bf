require 'pry'

class BruteForceLock
  class << self
    def call(disc_count:, from:, to:, exclude:, rows:)
      new(disc_count: disc_count, from: from, to: to, exclude: exclude, rows: rows).call
    end
  end

  attr_reader :disc_count, :from, :to, :exclude, :rows
  attr_accessor :result_array

  def initialize(disc_count:, from:, to:, exclude:, rows:)
    @disc_count = disc_count
    @from = from
    @to = to
    @exclude = exclude
    @rows = rows
    @result_array = []
  end

  def call
    populate
    exclude_prohibited
    result_array
  end

  private

  def unified_banned_array
    @_unified_banned_array ||= exclude.map(&:join)
  end

  def exclude_prohibited
    result_array.filter! { |el| !unified_banned_array.include?(el.join) }
  end

  def populate
    result_array.push(from)
    (0..rows).each do |number|
      next if number == 0

      prev_index = result_array.size - 1
      prev_array = result_array[prev_index].dup
      result_array.push([*Array.new(disc_count - 1, 0), number]) unless result_array[prev_index][0].zero? && result_array[prev_index][-1].zero?
      disc_count.times.each do |x|
        (disc_count - x).times.each do |el|
          prev_index = result_array.size - 1
          prev_array = result_array[prev_index].dup
          next if prev_array == Array.new(disc_count, number)

          new_array = if prev_array.bsearch_index { |i| i == number }.nil? && result_array[prev_index][0].zero?
            if prev_array.index(number).nil?
              prev_array.push(number)[-disc_count..-1]
            else
              prev_array.push(0)[-disc_count..-1]
            end
          elsif result_array[prev_index][0].zero?
            prev_array.push(0)[-disc_count..-1]
          else
            ([number] + prev_array)[0..disc_count - 1]
          end
          result_array.push(new_array)
        end
      end
    end
  end
end
