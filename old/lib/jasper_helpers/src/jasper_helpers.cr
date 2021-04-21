require "./jasper_helpers/*"

module JasperHelpers
  alias OptionHash = Hash(Symbol, Nil | String | Symbol | Bool | Int8 | Int16 | Int32 | Int64 | Float32 | Float64 | Time | Bytes | Array(String) | Array(Int32) | Array(String | Int32))

  include Tags
  include Text
  include Forms
  include Links
end
