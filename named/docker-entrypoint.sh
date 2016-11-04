#!/bin/bash
set -eo pipefail
shopt -s nullglob


echo "Chenking master or secondary"
if [[ "${SECONDARY}" == "no" ]]; then
echo "Master"
IPS=() 
  for i in "$SECONDARY_IPS";do
  IPS+=("$i")
  done
SEC_IP="acl secondary { 127.0.0.1; $IPS };"
else
echo "Secondary"
SEC_IP='acl secondary { 127.0.0.1; };'
fi

echo "Applying new configuration for named"
cat <<EOF > /etc/named.conf
//
// named.conf
//
// Provided by Red Hat bind package to configure the ISC BIND named(8) DNS
// server as a caching only nameserver (as a localhost DNS resolver only).
//
// See /usr/share/doc/bind*/sample/ for example named configuration files.
//
$SEC_IP

options {
  listen-on port 53 { ${SERVER_IP} };
  directory   "/var/named";
  dump-file   "/var/named/data/cache_dump.db";
  statistics-file "/var/named/data/named_stats.txt";
  memstatistics-file "/var/named/data/named_mem_stats.txt";
  allow-query     { any; };
  allow-recursion { secondary; };
  allow-transfer { secondary; };
  listen-on       { ${SERVER_IP} };
        recursive-clients 1536;
        cleaning-interval 3360;
        check-names master ignore;
        max-cache-size 1073741824;
        transfers-per-ns 150000;
        transfers-out 50000;
        transfers-in 50000;

  dnssec-enable yes;
  dnssec-validation yes;

  /* Path to ISC DLV key */
  bindkeys-file "/etc/named.iscdlv.key";

  managed-keys-directory "/var/named/dynamic";

  pid-file "/run/named/named.pid";
  session-keyfile "/run/named/session.key";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

zone "." IN {
  type hint;
  file "named.ca";
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
include "/etc/named/zones";
EOF

chown root:named /etc/named.conf
cat /etc/named.conf
echo "Creating empy zone file"
touch /etc/named/zones
echo "Checking named config"
named-checkconf

echo "Starting named"
/usr/sbin/named -u named -f
