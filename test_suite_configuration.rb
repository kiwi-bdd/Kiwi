#!/usr/bin/ruby

file = ARGV.shift

expected = <<-EOF
beforeAllSpecs
afterAllSpecs
EOF

pattern = "(before|after)AllSpecs$"

unless %x(grep -E -o '#{pattern}' #{file}) == expected
  STDERR.puts "error: expected #{file} to include beforeAllSpecs and afterAllSpecs in its output"
  exit 1
end
