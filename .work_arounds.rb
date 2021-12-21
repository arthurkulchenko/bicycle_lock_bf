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
