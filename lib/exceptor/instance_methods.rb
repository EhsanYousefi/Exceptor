module Exceptor
  module InstanceMethods

    def exceptor(constant = nil,&block)
      constant ||= self.class._default_exceptor
      begin
        block.call
      rescue => e
        instance_exec(ContextDelegator.new(block.binding),e,&constant.exceptors[e.class])
      end
    end

  end
end
