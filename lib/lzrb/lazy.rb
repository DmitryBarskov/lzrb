# frozen_string_literal: true

require_relative "delegate"

module Lzrb
  # Lazily accesses the given block
  class Lazy
    include Delegate

    delegate_all_methods to: :object

    def initialize(&block)
      @proc = block
      @object = nil
      @initialized = false
    end

    private

    def object
      unless @initialized
        @object = @proc.call
        @initialized = true
      end

      @object
    end
  end
end
