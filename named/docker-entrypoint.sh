#!/bin/bash
set -eo pipefail
shopt -s nullglob

########## Functions

function named_conf {
echo "Checking master or secondary"
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
}


function zone_config_file {
echo "Creating config zone file"
touch /etc/named/zones
if [[ "${SECONDARY}" == "no" ]];then
for ZONE in ${ZONES} ; do
echo "Adding zone ${ZONE} to /etc/named/zones"
cat <<EOF >> /etc/named/zones
zone "${ZONE}" {
        type master;
        file "/var/named/master/${ZONE}";
};
EOF
echo "Creating zone file for domain ${ZONE}"
cat <<EOF > /var/named/master/${ZONE}
$TTL    3600
@ IN  SOA     ns.${ZONE}. hostmaster.${ZONE}. (
                                2016012700  ; Serial
                                28800           ; Refresh
                                7200            ; Retry
                                604800          ; Expire
                                3600 )         ; Default Minimum TTL

    IN  NS ns.${ZONE}
EOF
done
else
for ZONE in ${ZONES} ; do
if [[ "${SECONDARY}" == "no" ]]; then
cat <<EOF >> /etc/named/zones
zone "${ZONE}" {
        type master;
        file "/var/named/master/${ZONE}";
};
EOF
elif [[ "${SECONDARY}" == "yes" ]]; then
cat <<EOF >> /etc/named/zones
zone "${ZONE}" {
        type slave;
        file "/var/named/master/${ZONE}";
        masters { ${MASTER_IPS} };
};
EOF
fi
done
fi
}

function named_chown { 
mkdir -p /var/named/master
chown named:named /etc/named/zones
chown -R named:named /var/named/master
cat /etc/named.conf
}

function checkconf {
echo "Checking named config"
named-checkconf 
}

function starting_named {
echo "Starting named"
/usr/sbin/named -u named -f
}


############# Exec functions

named_conf
chown root:named /etc/named.conf
if [[ ! -f /etc/named/zones ]]; then
zone_config_file
named_chown
else
  echo "Config zone file exists"
fi
checkconf
starting_named