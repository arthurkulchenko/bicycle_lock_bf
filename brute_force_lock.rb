require 'pry'

class BruteForceLock
  class << self
    def call(disc_count:, from:, to:, exclude:, rows: nil)
      new(disc_count: disc_count, from: from, to: to, exclude: exclude, rows: rows).call
    end
  end

  attr_reader :disc_count, :from, :to, :exclude, :rows

  def initialize(disc_count:, from:, to:, exclude:, rows: nil)
    @disc_count = disc_count
    @from = from
    @to = to
    @exclude = exclude
  end

  def call
    populate
  end

  private

  def unified_banned_arrays
    @_unified_banned_arrays ||= exclude.map(&:join)
  end

  def populate
    (from.join.to_i..to.join.to_i).map do |el|
      array = ("0" * disc_count + el.to_s)[-disc_count..-1].split(%r{\s*}).map(&:to_i)
      array unless unified_banned_arrays.include?(array.join)
    end
  end
end
