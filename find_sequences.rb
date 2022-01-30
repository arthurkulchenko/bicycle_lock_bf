require_relative './brute_force_lock.rb'

disc_count = 6
rows = 9

from = Array.new(disc_count).map { |el| rand(0..9) }
to = Array.new(disc_count).map { |el| rand(0..9) }
exclude = rand(4..10).times.map { rand((10**(disc_count-1))..(10**(disc_count)-1)).to_s.split(%r{\s*}).map(&:to_i) }

result = BruteForceLock.call(disc_count: disc_count, from: from, to: to, exclude: exclude, rows: rows)
result.chain.each { |el| p el }
