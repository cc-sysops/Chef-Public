#
# Cookbook Name:: postfix-dovecot
# Recipe:: postfix-full
#
# Copyright 2013, Onddo Labs, Sl.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package 'postfix'
case node['platform']
when 'debian', 'ubuntu' then
  package 'postfix-mysql'
end

tables_path = "#{node['postfix']['base_dir']}/tables"
# check if we can get the tables path from the postfixadmin cookbook
if node['postfixadmin'] and node['postfixadmin']['map_files'] and node['postfixadmin']['map_files']['path']
  tables_path = node['postfixadmin']['map_files']['path']
end

#
# master.cf
#

#submission inet n       -       -       -       -       smtpd
#  -o syslog_name=postfix/submission
#  -o smtpd_tls_security_level=encrypt
#  -o smtpd_sasl_auth_enable=yes
#  -o smtpd_client_restrictions=permit_sasl_authenticated,reject
#  -o milter_macro_daemon_name=ORIGINATING
node.default['postfix']['master']['inet:submission'] = {
  'command' => 'smtpd',
  'private' => false,
  'args' => [
    '-o syslog_name=postfix/submission',
    '-o smtpd_tls_security_level=encrypt',
    '-o smtpd_sasl_auth_enable=yes',
    '-o smtpd_client_restrictions=permit_sasl_authenticated,reject',
    '-o milter_macro_daemon_name=ORIGINATING'
  ],
}

#smtps     inet  n       -       -       -       -       smtpd
#  -o syslog_name=postfix/smtps
#  -o smtpd_tls_wrappermode=yes
#  -o smtpd_sasl_auth_enable=yes
#  -o smtpd_client_restrictions=permit_sasl_authenticated,reject
#  -o milter_macro_daemon_name=ORIGINATING
node.default['postfix']['master']['inet:smtps'] = {
  'command' => 'smtpd',
  'private' => false,
  'args' => [
    '-o syslog_name=postfix/smtps',
    '-o smtpd_tls_wrappermode=yes',
    '-o smtpd_sasl_auth_enable=yes',
    '-o smtpd_client_restrictions=permit_sasl_authenticated,reject',
    '-o milter_macro_daemon_name=ORIGINATING',
  ],
}

#dovecot   unix  -       n       n       -       -       pipe
#  flags=DRhu user=vmail:vmail argv=/usr/bin/spamc -e /usr/lib/dovecot/deliver -f {sender} -d ${recipient}
dovecot_argv = [
  "#{node['dovecot']['lib_path']}/deliver",
  '-f {sender}',
  '-d ${recipient}',
]
if node['postfix-dovecot']['spamc']['enabled']
  dovecot_argv.unshift("#{node.default['postfix-dovecot']['spamc']['path']} -e")
end
node.default['postfix']['master']['dovecot'] = {
  'command' => 'pipe',
  'unpriv' => false,
  'chroot' => false,
  'args' => [
    "flags=DRhu user=#{node['postfix-dovecot']['vmail']['user']}:#{node['postfix-dovecot']['vmail']['group']} argv=#{dovecot_argv.join(' ')}",
  ],
}

#
# main.cf
#

node.default['postfix']['main']['mynetworks'] = '127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128'
node.default['postfix']['main']['recipient_delimiter'] = '+'
node.default['postfix']['main']['alias_maps'] = 'hash:/etc/aliases'
node.default['postfix']['main']['alias_database'] = 'hash:/etc/aliases'

node.default['postfix']['main']['smtpd_banner'] = '$myhostname ESMTP $mail_name'
node.default['postfix']['main']['biff'] = false
node.default['postfix']['main']['append_dot_mydomain'] = 'no'
node.default['postfix']['main']['readme_directory'] = false
node.default['postfix']['main']['smtpd_helo_required'] = true

node.default['postfix']['main']['smtpd_helo_restrictions'] = [
  'permit_mynetworks',
  'reject_invalid_hostname',
  'permit',
]
node.default['postfix']['main']['smtpd_recipient_restrictions'] = [
  'permit_mynetworks',
  'permit_sasl_authenticated',
  'reject_invalid_hostname',
  'reject_non_fqdn_hostname',
  'reject_non_fqdn_recipient',
  'reject_unknown_recipient_domain',
  'reject_unauth_pipelining',
  'reject_unauth_destination',
  'permit',
]

# TLS parameters
node.default['postfix']['main']['smtpd_tls_cert_file'] = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
node.default['postfix']['main']['smtpd_tls_key_file'] = '/etc/ssl/private/ssl-cert-snakeoil.key'
node.default['postfix']['main']['smtpd_use_tls'] = true
node.default['postfix']['main']['smtpd_tls_session_cache_database'] = 'btree:${data_directory}/smtpd_scache'
node.default['postfix']['main']['smtp_tls_session_cache_database'] = 'btree:${data_directory}/smtp_scache'

# SASL authentication
node.default['postfix']['main']['smtpd_sasl_auth_enable'] = true
node.default['postfix']['main']['smtpd_sasl_path'] = 'private/auth'
node.default['postfix']['main']['smtpd_sasl_type'] = 'dovecot'
node.default['postfix']['main']['smtpd_tls_auth_only'] = true

# Virtual delivery
node.default['postfix']['main']['virtual_mailbox_domains'] = [
  "proxy:mysql:#{tables_path}/mysql_virtual_domains_maps.cf",
]
node.default['postfix']['main']['virtual_alias_maps'] = [
  "proxy:mysql:#{tables_path}/mysql_virtual_alias_maps.cf",
  "proxy:mysql:#{tables_path}/mysql_virtual_alias_domain_maps.cf",
  "proxy:mysql:#{tables_path}/mysql_virtual_alias_domain_catchall_maps.cf",
]
node.default['postfix']['main']['virtual_mailbox_maps'] = [
  "proxy:mysql:#{tables_path}/mysql_virtual_mailbox_maps.cf",
  "proxy:mysql:#{tables_path}/mysql_virtual_alias_domain_mailbox_maps.cf",
]
node.default['postfix']['main']['virtual_mailbox_base'] = node['postfix-dovecot']['vmail']['home']
node.default['postfix']['main']['virtual_uid_maps'] = "static:#{node['postfix-dovecot']['vmail']['uid']}"
node.default['postfix']['main']['virtual_gid_maps'] = "static:#{node['postfix-dovecot']['vmail']['gid']}"
node.default['postfix']['main']['virtual_transport'] = 'dovecot'
node.default['postfix']['main']['dovecot_destination_recipient_limit'] = 1

# Amazon SES
if node['postfix-dovecot']['ses']['enabled']
  ses_credentials = "#{node['postfix-dovecot']['ses']['username']}:#{node['postfix-dovecot']['ses']['password']}"
  node.default['postfix']['main']['relayhost'] = node['postfix-dovecot']['ses']['servers'][0]
  node.default['postfix']['main']['smtp_sasl_auth_enable'] = true
  node.default['postfix']['main']['smtp_sasl_security_options'] = 'noanonymous'
  node.default['postfix']['main']['smtp_use_tls'] = true
  node.default['postfix']['main']['smtp_tls_security_level'] = 'encrypt'
  node.default['postfix']['main']['smtp_tls_note_starttls_offer'] = true
  # node.default['postfix']['main']['smtp_sasl_password_maps'] = 'hash:/etc/postfix/sasl_passwd'
  node.default['postfix']['tables']['sasl_passwd'] = {
    '_type' => 'hash',
    '_add' => { 'smtp_sasl_password_maps' => nil },
  }
  node['postfix-dovecot']['ses']['servers'].each do |server|
    node.default['postfix']['tables']['sasl_passwd'][server] = ses_credentials
  end
  case node['platform']
  when 'redhat','centos','scientific','fedora','suse','amazon' then
    node.default['postfix']['main']['smtp_tls_CAfile'] = '/etc/ssl/certs/ca-bundle.crt'
  when 'debian', 'ubuntu' then
    node.default['postfix']['main']['smtp_tls_CAfile'] = '/etc/ssl/certs/ca-certificates.crt'
  else
    Chef::Log.warn("Unsupported platform: #{node['platform']}, trying to guess CA certificates file location")
    node.default['postfix']['main']['smtp_tls_CAfile'] = '/etc/ssl/certs/ca-certificates.crt'
  end
end

node['postfix']['main'].each do |key, value|
  if value.kind_of?(Array)
    node.default['postfix']['main'][key] = value.join(', ')
  end
end


include_recipe 'postfix-full::default'

directory '/var/spool/postfix/etc' do
  owner 'root'
  group 'root'
  mode '00755'
end

file '/var/spool/postfix/etc/resolv.conf' do
  owner 'root'
  group 'root'
  mode '00644'
  content IO.read('/etc/resolv.conf')
  notifies :restart, 'service[postfix]'
end

