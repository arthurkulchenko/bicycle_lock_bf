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

  # WIP
  def call2
    board = (0..9).to_a.map { |el| Array.new(disc_count, el.to_s) }
    exclude.each { |array| array.each.with_index { |el, index| i = el; j = index; board[i][j] = 'X' } }
    from.each.with_index { |el, index| board[el][index] == 'X' ? board[el][index] += 'F' : board[el][index] = 'F' }
    to.each.with_index { |el, index| board[el][index] == 'X' ? board[el][index] += 'T' : board[el][index] = 'T' }
    distances = (Matrix[to] - Matrix[from]).to_a[0]
    xfs = board.flatten.map.with_index { |el, index | [index / ARRAY_SIZE, index % ARRAY_SIZE] if el == 'XF' }.compact
    tfs = board.flatten.map.with_index { |el, index | [index / ARRAY_SIZE, index % ARRAY_SIZE] if el == 'TF' }.compact
    
    # white_board = (0..9).to_a.map { |_el| Array.new(disc_count, 0) }
    # distances.sum.each do |iteration|
    #   white_board[i][j] = iteration
    # end

    board = board.reverse
  end

  def call
    @disc_completed = Array.new(ARRAY_SIZE, false)
    initiate_exclude_discs

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
      # -------------------------
      if check_next_roll(next_disc_to_roll)
        # break
        next_disc_to_roll
        state.each.with_index do |el, index|
          next if index == next_disc_to_roll
          p "NOTHING" if check_next_roll(el)
        end
      # -------------------------
      else
        new_disc_state_value = next_disc_value(next_disc_to_roll)
        if new_disc_state_value == to[next_disc_to_roll]
          disc_completed[next_disc_to_roll] = true
        end
        state[next_disc_to_roll] = new_disc_state_value
        p state
        @chain.push(@state.dup)
      end
    end
    # chain
  end

  private

  # -------------------------
  def check_next_roll(key)
    exclude.map { |array| array == state }.any?(true)
  end
  # -------------------------

  def initiate_exclude_discs
    @structs = exclude.map do |el|
      array = (Matrix[el] - Matrix[from]).to_a[0]
      Disc.new(el, array.sum, :approaching)
    end.filter { |struct| struct.trend == :approaching }
  end

  def approaching_method
    from.map.with_index do |from_disc, index|
      back_direction = to[index] > from_disc && (to[index] - from_disc) >= 5 || to[index] < from_disc && (from_disc - to[index]) < 5
      back_direction ? '-' : '+'
    end
  end

  def next_disc_value(next_disc_to_roll)
    result = state[next_disc_to_roll].public_send(approaching_method[next_disc_to_roll].to_sym, STEP)
    if result == 10
      1
    elsif result.negative?
      10 + result
    else
      result
    end
  end

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
