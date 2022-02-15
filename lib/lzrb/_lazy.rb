# frozen_string_literal: true

require_relative "delegate"
require_relative "result"

module Lzrb
  # Makes an object (i. e. all their methods) lazy
  class _Lazy
    include Delegate

    delegate_all_methods to: :result

    def initialize(object)
      @object = object
    end

    private

    def result
      @result ||= Result.new do
        @object.public_send(method_name, *args, **kw_args, &block)
      end
    end
  end
end
