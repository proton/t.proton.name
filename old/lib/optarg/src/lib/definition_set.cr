module Optarg
  # :nodoc:
  class DefinitionSet
    macro __set(types, list, array = nil)
      {%
        types = [types] unless types.class_name == "ArrayLiteral"
        a = %w()
      %}
      {% for e, i in types %}
        {% if i == 0 %}
          {%
            a << "if df.is_a?(#{e})"
          %}
        {% else %}
          {%
            a << "elsif df.is_a?(#{e})"
          %}
        {% end %}
        {%
          a << "#{list}[df.key] = df"
          a << "#{array} << df" if array
        %}
      {% end %}
      {%
        a << "end"
      %}
      {{a.join("\n").id}}
    end

    def <<(df : Definitions::Base)
      all[df.key] = df
      __set DefinitionMixins::Option, options
      __set DefinitionMixins::ValueOption, value_options
      __set DefinitionMixins::Argument, arguments, array: argument_list
      __set Definitions::Handler, handlers
      __set Definitions::Terminator, terminators
      __set DefinitionMixins::Value, values
      __set Definitions::StringArrayArgument, string_array_arguments
      __set Definitions::Unknown, unknowns
    end

    getter all = {} of String => Definitions::Base
    getter arguments = {} of String => DefinitionMixins::Argument
    getter options = {} of String => DefinitionMixins::Option
    getter value_options = {} of String => DefinitionMixins::ValueOption
    getter handlers = {} of String => Definitions::Handler
    getter terminators = {} of String => Definitions::Terminator
    getter unknowns = {} of String => Definitions::Unknown
    getter values = {} of String => DefinitionMixins::Value
    getter string_array_arguments = {} of String => Definitions::StringArrayArgument

    getter argument_list = [] of DefinitionMixins::Argument
  end
end
