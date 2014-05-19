require 'spec_helper'

describe Site do
  describe 'associations' do
    it { should belong_to :listing }
    it { should belong_to :user }
  end
end
