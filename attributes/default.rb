node.default['haproxy'] = {
  service: 'haproxy',
  package: 'haproxy',
  config: '/etc/haproxy/haproxy.cfg',
  ca_cert: '/etc/pki/tls/certs/ca.crt',
  key: '/etc/pki/tls/private/haproxy.pem',
}