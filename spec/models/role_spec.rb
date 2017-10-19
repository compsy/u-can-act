# frozen_string_literal: true

require 'rails_helper'

describe Role, type: :model do
  describe 'validations' do
    it 'should be valid by default' do
      role = FactoryGirl.create(:role)
      expect(role).to be_valid
    end

    describe 'group' do
      it 'should be invalid when not present' do
        role = FactoryGirl.build(:role, group: nil)
        expect(role).to_not be_valid
        role = FactoryGirl.build(:role, group: 'test group')
        expect(role).to be_valid
      end

      it 'should be invalid when not unique in organization' do
        role = FactoryGirl.create(:role, group: 'test')
        role2 = FactoryGirl.build(:role, group: 'test', organization: role.organization)
        expect(role2).to_not be_valid
      end

      it 'should be valid when not unique but in different organization' do
        role = FactoryGirl.create(:role, group: 'test')
        role2 = FactoryGirl.build(:role, group: 'test')
        expect(role2).to be_valid
      end
    end

    describe 'title' do
      it 'should be invalid when not present' do
        role = FactoryGirl.build(:role, title: nil)
        expect(role).to_not be_valid
        role = FactoryGirl.build(:role, title: 'test title')
        expect(role).to be_valid
      end

      it 'should be invalid when not unique in organization' do
        role = FactoryGirl.create(:role, title: 'test')
        role2 = FactoryGirl.build(:role, title: 'test', organization: role.organization)
        expect(role2).to_not be_valid
      end

      it 'should be valid when not unique but in different organization' do
        role = FactoryGirl.create(:role, title: 'test')
        role2 = FactoryGirl.build(:role, title: 'test')
        expect(role2).to be_valid
      end
    end

    describe 'organization_id' do
      it 'should be invalid when not present' do
        organization = FactoryGirl.create(:organization)
        role1 = FactoryGirl.build(:role, organization_id: nil)
        role2 = FactoryGirl.build(:role, organization: organization)

        expect(role1).to_not be_valid
        expect(role2).to be_valid
      end
    end
  end

  it 'should be able to retrieve an organization' do
    role = FactoryGirl.create(:role)
    expect(role.organization).to be_a(Organization)
  end
end
