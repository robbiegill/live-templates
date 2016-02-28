require 'yaml'
require 'nokogiri'

module Formatters
  class RubyMine
    def self.dump!(file)
      group = LiveTemplateGroup.new(file)

      builder = Nokogiri::XML::Builder.new do |xml|
        xml.templateSet(group: group.name) do
          group.templates.each do |template|
            xml.template(template.attributes) do
              template.variables do |var|
                xml.variable(name: var, expression: '', defaultValue: '', alwaysStopAt: 'true')
              end
              xml.context_ do
                group.contexts.each { |name| xml.option(name: name, value: 'true') }
              end
            end
          end
        end
      end

      builder.to_xml
    end

    class LiveTemplateGroup
      attr_reader :data

      def initialize(file)
        @data = YAML.load_file file
      end

      def name
        data['name']
      end

      def templates
        data['templates'].map { |name, data| Template.new name, data }
      end

      def contexts
        data['contexts']
      end

      class Template
        attr_reader :name, :data

        def initialize(name, data)
          @name = name
          @data = data
        end

        def attributes
          {
            name: name,
            value: value,
            description: description,
            toReformat: 'true',
            toShortenFQNames: 'true'
          }.merge(additional_attributes)
        end

        def variables
          value.scan(/\$\S*\$/).map{ |m| m.tr '$', '' }.each do |var|
            yield var unless var == 'END'
          end
        end

        def description
          data['description']
        end

        def value
          data['template']
        end

        def additional_attributes
          data['additional_attributes'] || {}
        end
      end
    end
  end
end
