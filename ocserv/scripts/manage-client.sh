#!/bin/sh

# Add new user && Generating client certificate
add_user() {
  ### Read client info
  echo -n "Enter username: "
  read $USERNAME
  
  ID=$(od -A n -t d -N 2 /dev/urandom)
  UNIQ_USERNAME="${USERNAME}${ID}"
  PASSWORD=$(od -A n -t d -N 3 /dev/urandom)
  
  useradd -M -s /sbin/nologin $UNIQ_USERNAME
  cat $PASSWORD | passwd $UNIQ_USERNAME
  
#  mkdir /etc/ocserv/certs
  cd /etc/ocserv/certs
  
  certtool --generate-privkey --outfile ${UNIQ_USERNAME}-key.pem
  
cat > ${UNIQ_USERNAME}-tmp.tmpl <<-EOFF
cn = "$USERNAME"
uid = "$ID"
organization = "$CA_ORG"
expiration_days = $CA_DAYS
signing_key
encryption_key
tls_www_client
EOFF
  
  certtool --generate-certificate --load-privkey ${UNIQ_USERNAME}-key.pem --load-ca-certificate ca-cert.pem --load-ca-privkey ca-key.pem --template ${UNIQ_USERNAME}-tmp.tmpl --outfile ${UNIQ_USERNAME}-cert.pem
  
  rm -f ${UNIQ_USERNAME}-tmp.tmpl
  
  echo "- New user created -"
  echo "Username: $UNIQ_USERNAME"
  echo "Password: $PASSWORD"
  echo "Certificate location: certs/${UNIQ_USERNAME}-cert.pem"
  echo "\n"
}  

# Delete user and certificate
del_user () {
  ### Read username 
  echo -n "Enter username to delete: " 
  read $UNIQ_USERNAME

  userdel -r $UNIQ_USERNAME
  rm -rf /etc/ocserv/certs/${UNIQ_USERNAME}*

  echo "- User ${UNIQ_USERNAME} successfully deleted -"
}

case "$1" in
  add)
    add_user
    ;;

  del)
    del_user
    ;;

  *)
    echo "Usage: $0 {add|del}"
    ;;

esac

