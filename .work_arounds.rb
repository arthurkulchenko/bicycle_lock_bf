  # def populate
  #   result_array.push(from)
  #   (0..rows).each do |number|
  #     next if number == 0

  #     prev_index = result_array.size - 1
  #     prev_array = result_array[prev_index].dup
  #     result_array.push([*Array.new(disc_count - 1, 0), number]) unless result_array[prev_index][0].zero? && result_array[prev_index][-1].zero?
  #     disc_count.times.each do |x|
  #       (disc_count - x).times.each do |el|
  #         prev_index = result_array.size - 1
  #         prev_array = result_array[prev_index].dup
  #         next if prev_array == Array.new(disc_count, number)

  #         new_array = if prev_array.bsearch_index { |i| i == number }.nil? && result_array[prev_index][0].zero?
  #           if prev_array.index(number).nil?
  #             prev_array.push(number)[-disc_count..-1]
  #           else
  #             prev_array.push(0)[-disc_count..-1]
  #           end
  #         elsif result_array[prev_index][0].zero?
  #           prev_array.push(0)[-disc_count..-1]
  #         else
  #           ([number] + prev_array)[0..disc_count - 1]
  #         end
  #         result_array.push(new_array)
  #       end
  #     end
  #   end
  # end

  # def exclude_prohibited
  #   result_array.filter! { |el| !unified_banned_array.include?(el.join) }
  # end

  # def populate
  #   @result_array = (from.join.to_i..to.join.to_i).map do |el|
  #     ("0" * disc_count + el.to_s)[-disc_count..-1].split(%r{\s*}).map(&:to_i)
  #   end
  # end

  # def populate
  #   dummy_array = Array.new(disc_count, 0)
  #   (from.join.to_i..to.join.to_i).each do |el|
  #     array = dummy_array.push(el)[-disc_count..-1]
  #     result_array.push(array)
  #   end
  # end

  # def populate
  #   Array.new()
  #   (0..rows).to_a.reverse.each do |number|
  #     array_size = result_array.size
  #     if array_size.zero?
  #       result_array.push(Array.new(disc_count, number))
  #     else
  #       prev_array = result_array[array_size - 1].dup
  #       if prev_array[1].zero?
  #         result_array.push(Array.new(disc_count, number + 1))
  #       else
  #         prev_array.push(0)
  #         result_array.push(prev_array[-disc_count..-1])
  #       end
  #     end
  #   end
  # end

  # def func_populate
  #   pusher_lambda = -> glob_arr, work_arr { work_arr.each { |el| p glob_arr.push(el) } }
  #   pusher_lambda.curry.(result_array).(0..rows)
  # end
