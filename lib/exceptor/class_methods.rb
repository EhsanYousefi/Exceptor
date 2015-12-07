module Exceptor
  module ClassMethods

    def self.extended(base)
      base.extend(ClassAttr)
      base.class_attr :_default_exceptor
      base.define_singleton_method(:default_exceptor) { |param| self._default_exceptor = param }
    end

    def exceptor(constant = nil,&block)
      constant ||= self._default_exceptor
      begin
        block.call
      rescue => e
        instance_exec(ContextDelegator.new(block.binding),e,&constant.exceptors[e.class])
      end
    end

  end
end
