#Fluentd Grok Parser (experimental)

This is a proof of concept to add Grok support for [Fluentd](http://fluentd.org).

##What's Grok?

Grok is a tool to help you parse unstructured logs without writing super complex regular expressions.

##How to use (for now)

- Copy the stuff under in lib into your Fluentd instance

- Under lib/fluent/plugin/, create a new file (say ext_parser.rb) and add the following

    module Fluent
      class TextParser
        self.register_template(<format_name>, <grok_pattern>, <time_format_for_that_grok>)
        ...
      end
    end

Now, you should be able to use <format_name> as a Grok pattern.

For example, Grok has a pattern called %{COMBINEDAPACHELOG} (which is basically the same as `format apache2`. Then, you can register


    module Fluent
      class TextParser
        self.register_template('apache_grok', "%{COMBINEDAPACHELOG}", "%d/%b/%Y:%H:%M:%S %z")
      end
    end

Grok supports many formats out of the box, such as Cisco firewall logs, Nagios logs, etc.

##N.B.

This is a proof of concept. Most likely, many details of it will change.
