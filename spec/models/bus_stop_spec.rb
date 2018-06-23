require 'spec_helper'

describe BusStop do
  describe 'assign_completion_timestamp' do
    context 'bus stop is completed' do
      # need some time cop up in here
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
          stop_1 = create :bus_stop, completed: true
          stop_1.update! completed: false
          # how to access current user
          # stop_1.decide_if_completed_by current_user
          # user.fetch(:completed_by).to be current_user
        end
      end
      context 'bus stop is not completed' do
        it 'assigns nil to completed by' do
        end
      end
    end
  end

  describe 'completed scope' do
    it 'bus stops are completed' do
    end
  end

  describe 'not_started scope' do
    it 'bus stops data has not been entered' do
    end
  end

  describe 'pending scope' do
    it 'bus stops data has been entered but not complete' do
    end
  end

  describe 'pending scope' do
  end
end
