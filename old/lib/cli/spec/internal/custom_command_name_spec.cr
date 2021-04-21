require "../spec_helper"

module CliInternalCustomCommandNameFeature
  class Command < Cli::Supercommand
    command_name "custom"
  end

  it name do
    Command.__klass.global_name.should eq "custom"
  end
end
