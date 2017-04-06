begin
  klasa = 'Fog::DNS::AWS::Record'.split('::')
  klass = klasa.inject(Object) { |mod, class_name|
    mod.const_get(class_name)
  }
  module Fog
    module DNS
      class AWS
        class Record

          def name
            @attributes['name'].gsub('\052', '*')
          end

        end
      end
    end
  end
rescue NameError => e
  # noop
end

# begin
#   klasa = 'Fog::DNS::DigitalOcean::Record'.split('::')
#   klass = klasa.inject(Object) { |mod, class_name|
#     mod.const_get(class_name)
#   }
#   module Fog
#     module DNS
#       class DigitalOcean
#         class Record
#
#           def name
#             @attributes['name']
#           end
#
#         end
#       end
#     end
#   end
# rescue NameError => e
#   # noop
# end

