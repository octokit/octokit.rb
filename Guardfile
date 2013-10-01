guard 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/helper.rb')  { "spec" }

  notification :tmux,
    :display_message => true,
    :timeout => 5, # in seconds
    :default_message_format => '%s // %s',
    :line_separator => ' > ', # since we are single line we need a separator
    :color_location => 'status-left-fg' # to customize which tmux element will change color
end
