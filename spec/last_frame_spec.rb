# frozen_string_literal: true

require './lib/last_frame'

describe LastFrame do
  subject(:frame) { described_class.new }

  describe '#frame_completed' do
    it 'shows a frame is completed' do
      frame.log_roll(6)
      frame.log_roll(3)
      expect(frame.frame_complete?).to be true
    end

    it 'shows a frame is not completed' do
      frame.log_roll(6)
      expect(frame.frame_complete?).to be false
    end

    it 'shows a frame complete after a strike and 2 following rolls' do
      frame.log_roll(10)
      frame.log_roll(10)
      frame.log_roll(10)
      expect(frame.frame_complete?).to be true
    end

    it 'shows a frame not completed after a strike and 1 roll' do
      frame.log_roll(10)
      frame.log_roll(10)
      expect(frame.frame_complete?).to be false
    end

    it 'shows a frame not completed after a spare and 1 roll to go' do
      frame.log_roll(2)
      frame.log_roll(8)
      expect(frame.frame_complete?).to be false
    end

    it 'shows a frame  completed after a spare and final roll' do
      frame.log_roll(2)
      frame.log_roll(8)
      frame.log_roll(8)
      expect(frame.frame_complete?).to be true
    end
  end

  context 'Bonus rolls on last frame' do
    it 'scores two strikes on 2 rolls' do
      frame.log_roll(10)
      frame.log_roll(10)
      expect(frame.all_rolls).to eq [10, 10]
    end

    it 'scores threes strikes on 3 rolls' do
      frame.log_roll(10)
      frame.log_roll(10)
      frame.log_roll(10)
      frame.all_rolls
      expect(frame.all_rolls).to eq [10, 10, 10]
    end

    it 'scores spare and strikes over 3 rolls' do
      frame.log_roll(3)
      frame.log_roll(7)
      frame.log_roll(10)
      expect(frame.all_rolls).to eq [3, 7, 10]
    end
  end

  context 'invalid input' do
    it 'raises an error if the frame is completed with a spare and a roll is logged against the frame' do
      frame.log_roll(5)
      frame.log_roll(5)
      frame.log_roll(5)
      expect { frame.log_roll(5) }.to raise_error('Frame complete. Cannot roll again')
    end

    it 'raises an error if the frame is completed with a strike and a roll is logged against the frame' do
      frame.log_roll(10)
      frame.log_roll(5)
      frame.log_roll(5)
      expect { frame.log_roll(5) }.to raise_error('Frame complete. Cannot roll again')
    end

    it 'raises an error if the frame is completed and a roll is logged against the frame' do
      frame.log_roll(2)
      frame.log_roll(5)
      expect { frame.log_roll(5) }.to raise_error('Frame complete. Cannot roll again')
    end

    it 'does not allow rolls greater than what pins are left, 3rd ball' do
      frame.log_roll(5)
      frame.log_roll(5)
      expect { frame.log_roll(11) }.to raise_error('Pins downed must be between 0 and 10')
    end

  end
end
