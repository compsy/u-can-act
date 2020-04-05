# frozen_string_literal: true

class AsyncActiveInteraction < ActiveInteraction::Base
  class << self
    def run_async!(*args)
      AsyncActiveInteractionJob.perform_later(to_s, Marshal.dump(args))
    end
  end
end
