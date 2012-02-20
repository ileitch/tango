require 'tango/contexts/helpers'

module Tango
  module Contexts
    class Chain

      include Helpers

      def initialize
        @contexts = []
      end

      def in_context(context, &block)
        @contexts << context
        if block_given?
          call_in_contexts(&block)
        else
          self
        end
      end

    private

      def call_in_contexts
        begin
          @contexts.each do |context|
            Contexts.current.push(context)
            context.enter
          end

          yield
        ensure
          while context = Contexts.current.shift
            context.leave
          end
        end
      end

    end
  end
end

