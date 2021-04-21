module Cli
  # :nodoc:
  macro __any_item_of(df, params)
    {% if params.class_name == "TupleLiteral" %}
      {%
        type = "#{df.id}::Typed::ElementType".id
        typed_value = "#{df.id}::Typed::ElementValue".id
      %}
      ([
        {% for e, i in params %}
        ::{{typed_value}}.new(
          {{e[0]}},
          {% if e[1].class_name == "NamedTupleLiteral" %}
            metadata: ::Cli::OptionValueMetadata(::{{type}}).new(**{{e[1]}})
          {% else %}
            metadata: ::Cli::OptionValueMetadata(::{{type}}).new(desc: {{e[1]}})
          {% end %}
        ),
        {% end %}
      ])
    {% else %}
      {{params}}
    {% end %}
  end
end
