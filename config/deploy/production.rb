# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
# Don't declare `role :all`, it's a meta role
role :app, %w{nohm@nohm.eu}
role :web, %w{nohm@nohm.eu}
role :db,  %w{nohm@nohm.eu}

set :deploy_to, "/var/www/"
