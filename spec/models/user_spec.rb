require 'spec_helper'

describe User do
  let(:user) {FactoryGirl.create(:user)}

  describe 'associations' do
    it { should have_many :listings }
    it { should have_many :sites }
    it { should have_many :sub_profiles }
    it { should have_one :profile }
    it { should have_one :account }
  end


  describe 'profile_attribute_list' do
    it 'calls the same method on its profile' do
      expect(user.profile).to receive(:profile_attribute_list)
      
      user.profile_attribute_list
    end
  end

  describe 'profile_hash' do

    it 'calls the same method on its profile' do
      expect(user.profile).to receive(:profile_hash)

      user.profile_hash
    end
  end

end
