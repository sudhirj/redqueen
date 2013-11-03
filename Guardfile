# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :bundler do
  watch('Gemfile')
  # Uncomment next line if your Gemfile contains the `gemspec' command.
  watch(/^.+\.gemspec/)
end

guard :rspec do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end


# # Add files and commands to this file, like the example:
# #   watch(%r{file/path}) { `command(s)` }
# #
# guard 'shell' do
#   watch(/(.*).txt/) {|m| `tail #{m[0]}` }
# end
