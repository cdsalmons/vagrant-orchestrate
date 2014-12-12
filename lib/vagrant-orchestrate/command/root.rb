require 'optparse'

module VagrantPlugins
  module Orchestrate
    module Command
      class Root < Vagrant.plugin(2, :command)
        def self.synopsis
          "Orchestrates provsioning of managed servers. Useful across environments"
        end

        def initialize(argv, env)
          super

          @main_args, @sub_command, @sub_args = split_main_and_subcommand(argv)

          @subcommands = Vagrant::Registry.new

          @subcommands.register(:init) do
            require_relative 'init'
            Init
          end

=begin
          @subcommands.register(:list) do
            require File.expand_path("../list", __FILE__)
            List
          end

          @subcommands.register(:outdated) do
            require_relative "outdated"
            Outdated
          end

          @subcommands.register(:remove) do
            require File.expand_path("../remove", __FILE__)
            Remove
          end

          @subcommands.register(:repackage) do
            require File.expand_path("../repackage", __FILE__)
            Repackage
          end

          @subcommands.register(:update) do
            require_relative "update"
            Update
          end
=end
        end

        def execute
          if @main_args.include?("-h") || @main_args.include?("--help")
            # Print the help for all the box commands.
            return help
          end

          # If we reached this far then we must have a subcommand. If not,
          # then we also just print the help and exit.
          command_class = @subcommands.get(@sub_command.to_sym) if @sub_command
          return help if !command_class || !@sub_command
          @logger.debug("Invoking command class: #{command_class} #{@sub_args.inspect}")

          # Initialize and execute the command class
          command_class.new(@sub_args, @env).execute
        end

        # Prints the help out for this command
        def help
          opts = OptionParser.new do |opts|
            opts.banner = "Usage: vagrant orchestrate <subcommand> [<args>]"
            opts.separator ""
            opts.separator "Available subcommands:"

            # Add the available subcommands as separators in order to print them
            # out as well.
            keys = []
            @subcommands.each { |key, value| keys << key.to_s }

            keys.sort.each do |key|
              opts.separator "     #{key}"
            end

            opts.separator ""
            opts.separator "For help on any individual subcommand run `vagrant orchestrate <subcommand> -h`"
          end

          @env.ui.info(opts.help, prefix: false)
        end
      end
    end
  end
end

=begin
require 'optparse'

module VagrantPlugins
  module Orchestrate
    module Command
      class Root < Vagrant.plugin("2", :command)
        def self.synopsis
          "manages boxes: installation, removal, etc."
        end

      end
    end
  end
end
=end
