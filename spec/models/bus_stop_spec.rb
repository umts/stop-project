require 'spec_helper'

describe BusStop do
  describe 'assign_completion_timestamp' do
    context 'bus stop is completed' do
      it 'assigns the current time to completed_at' do
      end
    end
    context 'bus stop is not completed' do
      it 'assigns nil to completed at' do
      end
    end
  end

  describe 'decide_if_completed_by' do
    context 'bus stop completed attribute changed' do
      context 'bus stop is completed' do
        it 'assigns user to completed by' do
        end
      end
      context 'bus stop is not completed' do
        it 'assigns nil to completed by' do
        end
      end
    end
  end
end
