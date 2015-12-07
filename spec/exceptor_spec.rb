require 'spec_helper'
describe Exceptor do

  describe 'Exceptor::Base' do

    it 'should define an handler for specified exception' do

      block = proc { |context| 'Exception Successfully Rescued' }
      klass = Class.new(Exceptor::Base) do
        on(StandardError, &block)
      end

      expect(klass.exceptors[StandardError]).to eql block

    end

    it 'There should be a default handler' do

      block = proc { |context| 'Exception Successfully Rescued' }

      klass = Class.new(Exceptor::Base) {}
      expect(klass.exceptors[:default]).to eql nil
      expect(klass.exceptors[:invalid]).to eql nil

      klass.class_eval do
        on(:default, &block)
      end
      expect(klass.exceptors[:default]).to eql block
      expect(klass.exceptors[:invalid]).to eql block

    end

  end

  describe 'Exceptor' do

    context('Instance') do

      let(:exceptor_class) do
        Class.new(Exceptor::Base) do
          on(:default) do |context,error|
            "#{@instance_var}_#{method_call}_#{context.local_var}_#{error.class}"
          end
          on(StandardError) do |context,error|
            "#{@instance_var}|#{method_call}|#{context.local_var}|#{error.class}"
          end
        end
      end

      it 'should rescue defined exception(in case of StandardError)' do

        ExceptorInstanceClass = exceptor_class

        klass = Class.new do
          include Exceptor::Safe

          def raise_exception
            @instance_var = "__instance__var__"
            local_var = "__local__var__"
            exceptor(ExceptorInstanceClass) do
              raise StandardError
            end
          end

          def method_call
            '__method__call__'
          end
        end

        object = klass.new
        expect(object.raise_exception).to eql "__instance__var__|__method__call__|__local__var__|StandardError"

      end

      it 'should rescue defined exception(in case of ArgumentError)' do

        klass = Class.new do
          include Exceptor::Safe

          def raise_exception
            @instance_var = "__instance__var__"
            local_var = "__local__var__"
            exceptor(ExceptorInstanceClass) do
              raise ArgumentError
            end
          end

          def method_call
            '__method__call__'
          end
        end

        object = klass.new
        expect(object.raise_exception).to eql "__instance__var_____method__call_____local__var___ArgumentError"

      end

      it 'should rescue defined exception with default_exceptor' do

        klass = Class.new do
          include Exceptor::Safe
          default_exceptor ExceptorInstanceClass

          def raise_exception
            @instance_var = "__instance__var__"
            local_var = "__local__var__"
            exceptor do
              raise ArgumentError
            end
          end

          def method_call
            '__method__call__'
          end
        end

        object = klass.new
        expect(object.raise_exception).to eql "__instance__var_____method__call_____local__var___ArgumentError"

      end

      it 'should rescue defined exception with default_exceptor(In case of subclass)' do

        klass = Class.new do
          include Exceptor::Safe
          default_exceptor ExceptorInstanceClass

          def raise_exception
            @instance_var = "__instance__var__"
            local_var = "__local__var__"
            exceptor do
              raise ArgumentError
            end
          end

          def method_call
            '__method__call__'
          end
        end

        object = klass.new
        expect(object.raise_exception).to eql "__instance__var_____method__call_____local__var___ArgumentError"

        subclass = Class.new(klass).new
        expect(subclass.raise_exception).to eql "__instance__var_____method__call_____local__var___ArgumentError"

      end


    end

    context 'Class' do

      let(:exceptor_class) do
        Class.new(Exceptor::Base) do
          on(:default) do |context,error|
            "#{class_variable_get("@@class_var")}_#{method_call}_#{context.local_var}_#{error.class}"
          end
          on(StandardError) do |context,error|
            "#{class_variable_get("@@class_var")}|#{self.method_call}|#{context.local_var}|#{error.class}"
          end
        end
      end

      it 'should rescue defined exception(in case of StandardError)' do

        ExceptorClass = exceptor_class

        klass = Class.new do
          include Exceptor::Safe

          def self.raise_exception
            class_variable_set("@@class_var","__instance__var__")
            local_var = "__local__var__"
            exceptor(ExceptorClass) do
              raise StandardError
            end
          end

          def self.method_call
            '__method__call__'
          end
        end

        expect(klass.raise_exception).to eql "__instance__var__|__method__call__|__local__var__|StandardError"

      end

      it 'should rescue defined exception(in case of ArgumentError)' do

        klass = Class.new do
          include Exceptor::Safe

          def self.raise_exception
            class_variable_set("@@class_var","__instance__var__")
            local_var = "__local__var__"
            exceptor(ExceptorClass) do
              raise ArgumentError
            end
          end

          def self.method_call
            '__method__call__'
          end
        end

        expect(klass.raise_exception).to eql "__instance__var_____method__call_____local__var___ArgumentError"

      end

      it 'should rescue defined exception with default_exceptor' do

        klass = Class.new do
          include Exceptor::Safe
          default_exceptor ExceptorClass

          def self.raise_exception
            class_variable_set("@@class_var","__instance__var__")
            local_var = "__local__var__"
            exceptor do
              raise ArgumentError
            end
          end

          def self.method_call
            '__method__call__'
          end
        end

        expect(klass.raise_exception).to eql "__instance__var_____method__call_____local__var___ArgumentError"

      end

      it 'should rescue defined exception with default_exceptor(In case of subclass)' do

        klass = Class.new do
          include Exceptor::Safe
          default_exceptor ExceptorClass

          def self.raise_exception
            class_variable_set("@@class_var","__instance__var__")
            local_var = "__local__var__"
            exceptor do
              raise ArgumentError
            end
          end

          def self.method_call
            '__method__call__'
          end
        end

        expect(klass.raise_exception).to eql "__instance__var_____method__call_____local__var___ArgumentError"

        subclass = Class.new(klass)
        expect(subclass.raise_exception).to eql "__instance__var_____method__call_____local__var___ArgumentError"

      end

    end
  end

  describe 'Default Exceptor' do

    it 'it should define new default_exceptor in subclass without touching parentclass default_exceptor' do

      klass = Class.new do
        include Exceptor::Safe
        default_exceptor :parent_default_exceptor
      end

      expect(klass._default_exceptor).to eql :parent_default_exceptor

      subclass = Class.new(klass)
      subclass.class_eval do
        default_exceptor :sublcass_default_exceptor
      end

      expect(subclass._default_exceptor).to eql :sublcass_default_exceptor
      expect(klass._default_exceptor).to eql :parent_default_exceptor

    end
  end
end
