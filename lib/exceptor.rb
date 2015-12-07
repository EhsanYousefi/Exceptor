require "exceptor/version"
require "exceptor/base"
require "exceptor/class_methods"
require "exceptor/instance_methods"
require "exceptor/context_delegator"

module Exceptor
  module Safe
    def self.included(base)
      base.extend(ClassMethods)
      base.include(InstanceMethods)
    end
  end
end
