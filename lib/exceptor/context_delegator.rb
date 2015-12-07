module Exceptor
  class ContextDelegator < BasicObject

    def initialize(context)
      @context = context
    end

    def method_missing(name, *args, &block)
      name = name.id2name
      name.delete!('=') ? @context.local_variable_set(name, args[0]) : @context.local_variable_get(name)
    end

  end
end
