require_relative '../brute_force_lock.rb'

RSpec.describe BruteForceLock, type: :service do
  let(:disc_count) { 3 }
  let(:initial_position) { [0, 0, 0] }
  let(:final_position) { [1, 1, 1] }
  let(:prohibited_combinations) { [[0, 0, 1], [1, 0, 0]] }
  let(:expected_combinations) { [[0, 0, 0], [0, 1, 0], [1, 1, 0], [1, 1, 1]] } # [1, 0, 1] is absent?
  let(:args) do
    {
      disc_count: disc_count,
      from: initial_position,
      to: final_position,
      exclude: prohibited_combinations,
      rows: 1
    }
  end

  subject { described_class.call(**args) }

  it 'has only expected combinations' do
    expect(subject).to match_array(expected_combinations)
  end

  it "has't prohibited combinations combinations" do
    expect(subject).not_to include(*prohibited_combinations)
  end
end
