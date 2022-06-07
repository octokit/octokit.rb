require 'octokit/default'
require 'octokit/client'
require 'octokit/enterprise_admin_client'
require 'octokit/enterprise_management_console_client'

# We have already required `Client`, `EnterpriseAdminClient` and
# `EnterpriseManagementConsoleClient` above, so the `autoload` declaration in `lib/octokit/base.rb`
# won't do anything. This is the default for Octokit, and leads to a simpler and more reliable
# user experience, even if it makes booting your app a little slower compared to the lazy-loaded
# experience you get if you call `require 'octokit/lazy'`.
require 'octokit/base'
