# frozen_string_literal: true

module Lzrb
  # Delegates all methods
  module Delegate
    OBJECT_METHODS = %i[
      methods singleton_methods protected_methods private_methods public_methods
      instance_of? kind_of? is_a? class
      public_method method public_send singleton_method define_singleton_method
      extend clone to_enum enum_for <=> === =~ !~ nil? eql? respond_to?
      freeze inspect to_s display frozen? tap then yield_self hash
      dup itself ! == != equal?
    ].freeze

    def self.included(base)
      base.extend ClassMethods

      OBJECT_METHODS.each do |method_name|
        base.undef_method(method_name)
      end
    end

    def method_missing(method_name, *args, **kw_args, &block)
      unless respond_to_missing?(method_name)
        raise NoMethodError, "undefined method `#{method_name}' for #{__object}"
      end

      __object.public_send(method_name, *args, **kw_args, &block)
    end

    def respond_to_missing?(method_name, *)
      __object.respond_to?(method_name)
    end

    module ClassMethods
      private

      def delegate_all_methods(to: :object)
        find_method = if to.to_s.start_with?("@")
          Proc.new { @__object ||= instance_variable_get(to) }
        else
          Proc.new { @__object ||= send(to) }
        end

        define_method(:__object, &find_method)
      end
    end
  end
end
