# frozen_string_literal: true

require 'rails_helper'

module Api
  module V1
    module BasicAuthApi
      RSpec.describe SchedulingController, type: :controller do
        describe 'without authentication' do
          it 'should head a 401' do
            post :minutely
            expect(response.status).to eq 401
          end
        end

        describe 'with authentication' do
          before :each do
            basic_auth 'admin', 'admin'
          end

          describe 'daily_at_one_am' do
            it 'should call the correct job' do
              expect(ReschedulingJob).to receive(:perform_later).and_return(true)
              post :daily_at_one_am
              expect(response.status).to eq 201
            end
          end

          describe 'daily_at_two_am' do
            it 'should call the correct job' do
              expect(CompleteProtocolSubscriptions).to receive(:run).and_return(true)
              post :daily_at_two_am
              expect(response.status).to eq 201
            end
          end

          describe 'daily_at_three_am' do
            it 'should call the correct job' do
              expect(CleanupInvitationTokens).to receive(:run).and_return(true)
              post :daily_at_three_am
              expect(response.status).to eq 201
            end
          end

          describe 'daily_at_four_am' do
            it 'should call the correct job' do
              post :daily_at_four_am
              expect(response.status).to eq 204
            end
          end

          describe 'daily' do
            it 'should call the correct job' do
              post :daily
              expect(response.status).to eq 204
            end
          end

          describe 'hourly' do
            it 'should call the correct job' do
              post :hourly
              expect(response.status).to eq 204
            end
          end

          describe 'thirty_minutely' do
            it 'should call the correct job' do
              post :thirty_minutely
              expect(response.status).to eq 204
            end
          end

          describe 'five_minutely' do
            it 'should call the correct job' do
              expect(SnitchJob).to receive(:perform_later).and_return(true)
              expect(SendInvitations).to receive(:run).and_return(true)
              post :five_minutely
              expect(response.status).to eq 201
            end
          end

          describe 'minutely' do
            it 'should call the correct job' do
              post :minutely
              expect(response.status).to eq 204
            end
          end
        end
      end
    end
  end
end
