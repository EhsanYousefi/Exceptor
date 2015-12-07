require_relative 'class_attr'
module Exceptor
  class Base

    extend ClassAttr
    class_attr :exceptors

    def self.inherited(subclass)
      subclass.exceptors = subclass.exceptors.dup if subclass.exceptors
      super
    end

    def self.on(exception, &block)
      if exception == :default
        if self.exceptors
          self.exceptors.default = block
        else
          self.exceptors = {}.tap { |o| o.default = block }
        end
      else
        self.exceptors ||= {}
        self.exceptors[exception] = block
      end
    end

  end
end
