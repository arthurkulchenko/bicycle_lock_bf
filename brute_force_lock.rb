class BruteForceLock
  class << self
    def call(disc_count:, from:, to:, exclude:)
      new(disc_count: disc_count, from: from, to: to, exclude: exclude).call
    end
  end

  def initialize(disc_count:, from:, to:, exclude:)
    @disc_count = disc_count
    @from = from
    @to = to
    @exclude = exclude
  end

  def call
    do_the_stuff
  end

  private

    def do_the_stuff
      [[0, 0, 0]]
    end
end
