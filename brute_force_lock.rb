require 'matrix'
require 'pry'

class BruteForceLock
  STEP = 1
  ARRAY_SIZE = 6

  class << self
    def call(disc_count:, from:, to:, exclude:, rows: nil)
      new(disc_count: disc_count, from: from, to: to, exclude: exclude, rows: rows).call
    end
  end

  attr_reader :disc_count, :from, :to, :exclude, :rows
  attr_accessor :chain, :state, :structs, :disc_completed

  def initialize(disc_count:, from:, to:, exclude:, rows: nil)
    @disc_count = disc_count
    @from = from
    @to = to
    @exclude = exclude
    @chain = []
    @state = from
  end

  Disc = Struct.new(:array, :sum, :trend)

  def approaching_method
    from.map.with_index do |from_disc, index|
      back_direction = to[index] > from_disc && (to[index] - from_disc) >= 5 || to[index] < from_disc && (from_disc - to[index]) < 5
      back_direction ? '-' : '+'
    end
  end


  # PITFALL: arrays could have same sum but different sequence
  # TODO: check each value trend to claim array trend
  # binding.pry if state.sum > 21
  # struct.trend = :distancing if struct.sum < diff.map(&:abs).sum
  def initiate_exclude_discs
    exclude.map do |el|
      array = (Matrix[el] - Matrix[from]).to_a[0]
      Disc.new(el, array.sum, :approaching)
    end
  end

  def print_initial_values
    p '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
    p from
    p to
    p exclude
    p '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
  end

  def call
    print_initial_values
    @disc_completed = Array.new(ARRAY_SIZE, false)
    @structs = initiate_exclude_discs.filter { |struct| struct.trend == :approaching }

    while state != to do
      diffs_on_step_before_roll = diffs_on_step
      each_exclude_array_avg = diffs_on_step_before_roll.map { |array| array.sum / ARRAY_SIZE }
      state_indecies_to_skip = disc_completed.map.with_index { |el, index| index if el }.compact
      closest_exclude_array_score = minimal_values_on_every_diff_step.map.with_index do |pair, index|
        score = pair[0] + each_exclude_array_avg[index]
        score + 99 if disc_completed[index]
        [score, pair[1]]
      end
      closest_exclude_arrays_index = closest_exclude_array_score.index(closest_exclude_array_score.min { |pair| pair[0] })
      closest_exclude_arrays_val_indx = closest_exclude_array_score.min { |pair| pair[0] }
      closest_diff_exclude_array = diffs_on_step_before_roll[closest_exclude_arrays_index]
      next_disc_to_roll = closest_exclude_arrays_val_indx[1]
      new_disc_state_value = begin
        result = state[next_disc_to_roll].public_send(approaching_method[next_disc_to_roll].to_sym, STEP)
        if result == 10
          1
        elsif result.negative?
          10 + result
        else
          result
        end
      end
      if new_disc_state_value == to[next_disc_to_roll]
        disc_completed[next_disc_to_roll] = true
      end
      state[next_disc_to_roll] = new_disc_state_value
      p state
      @chain.push(@state)
    end
    chain
  end

  private

  def diffs_on_step
    structs.map { |struct| (Matrix[struct.array] - Matrix[state]).to_a[0].map(&:abs) }.sort_by { |array| array.sum }
  end

  # NOTICE: Ignoring alrady finished discs
  def minimal_values_on_every_diff_step
    diffs_on_step.map do |diff|
      state_indecies_to_skip = disc_completed.map.with_index { |el, index| index if el }.compact
      minimal_value_in_diff_array = 99
      ddiff = diff.dup
      state_indecies_to_skip.each { |index| ddiff[index] = 99 }
      # ddiff.min
      ddiff.each.with_index do |el, index|
        next if state_indecies_to_skip.include?(index) || el > minimal_value_in_diff_array

        minimal_value_in_diff_array = el
      end
      # ddiff.index(minimal_value_in_diff_array)
      [minimal_value_in_diff_array, ddiff.index(minimal_value_in_diff_array)]
    end
  end
end
