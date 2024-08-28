#!/bin/sh

### VERSION HISTORY
#####################################################################################
#     Version     : 1.1
#
#     Revision    : CXP 903 6540-1-1
#
#     Author      : zchianu
#
#     JIRA        : NSS-27832
#
#     Description : Updating Ciphers for RNC and RBS nodes .
#
#     Date        : 07 November 2019
#
####################################################################################


SIM=$1

if [ "$#" -ne 1  ]
then
 echo
 echo "Usage: $0 <sim name>"
 echo
 echo "Example: $0 RNCV71659x1-FT-RBSU4460x40-RNC01"
 echo
 exit 1
fi

MOSCRIPT=$SIM"_Cipher.mo"
rm -rf $MOSCRIPT

cat >> $MOSCRIPT << MOSC
SET
(
    mo "ManagedElement=1,SystemFunctions=1,Security=1,Tls=1"
    exception none
    nrOfAttributes 3
    "supportedCipher" Array Struct 49
        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "AEAD"
        "name" String "ECDHE-RSA-AES256-GCM-SHA384"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aECDSA"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "AEAD"
        "name" String "ECDHE-ECDSA-AES256-GCM-SHA384"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "SHA384"
        "name" String "ECDHE-RSA-AES256-SHA384"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aECDSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "SHA384"
        "name" String "ECDHE-ECDSA-AES256-SHA384"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "SHA1"
        "name" String "ECDHE-RSA-AES256-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aECDSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "SHA1"
        "name" String "ECDHE-ECDSA-AES256-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aDSS"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "AEAD"
        "name" String "DHE-DSS-AES256-GCM-SHA384"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "AEAD"
        "name" String "DHE-RSA-AES256-GCM-SHA384"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "SHA256"
        "name" String "DHE-RSA-AES256-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aDSS"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "SHA256"
        "name" String "DHE-DSS-AES256-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "SHA1"
        "name" String "DHE-RSA-AES256-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aDSS"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "SHA1"
        "name" String "DHE-DSS-AES256-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kECDH/RSA"
        "mac" String "AEAD"
        "name" String "ECDH-RSA-AES256-GCM-SHA384"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kECDH/ECDSA"
        "mac" String "AEAD"
        "name" String "ECDH-ECDSA-AES256-GCM-SHA384"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH/RSA"
        "mac" String "SHA384"
        "name" String "ECDH-RSA-AES256-SHA384"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH/ECDSA"
        "mac" String "SHA384"
        "name" String "ECDH-ECDSA-AES256-SHA384"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH/RSA"
        "mac" String "SHA1"
        "name" String "ECDH-RSA-AES256-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH/ECDSA"
        "mac" String "SHA1"
        "name" String "ECDH-ECDSA-AES256-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kRSA"
        "mac" String "AEAD"
        "name" String "AES256-GCM-SHA384"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kRSA"
        "mac" String "SHA256"
        "name" String "AES256-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kRSA"
        "mac" String "SHA1"
        "name" String "AES256-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "AEAD"
        "name" String "ECDHE-RSA-AES128-GCM-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aECDSA"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "AEAD"
        "name" String "ECDHE-ECDSA-AES128-GCM-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "SHA256"
        "name" String "ECDHE-RSA-AES128-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aECDSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "SHA256"
        "name" String "ECDHE-ECDSA-AES128-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "SHA1"
        "name" String "ECDHE-RSA-AES128-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aECDSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "SHA1"
        "name" String "ECDHE-ECDSA-AES128-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aDSS"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "AEAD"
        "name" String "DHE-DSS-AES128-GCM-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "AEAD"
        "name" String "DHE-RSA-AES128-GCM-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "SHA256"
        "name" String "DHE-RSA-AES128-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aDSS"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "SHA256"
        "name" String "DHE-DSS-AES128-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "SHA1"
        "name" String "DHE-RSA-AES128-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aDSS"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "SHA1"
        "name" String "DHE-DSS-AES128-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kECDH/RSA"
        "mac" String "AEAD"
        "name" String "ECDH-RSA-AES128-GCM-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kECDH/ECDSA"
        "mac" String "AEAD"
        "name" String "ECDH-ECDSA-AES128-GCM-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH/RSA"
        "mac" String "SHA256"
        "name" String "ECDH-RSA-AES128-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH/ECDSA"
        "mac" String "SHA256"
        "name" String "ECDH-ECDSA-AES128-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH/RSA"
        "mac" String "SHA1"
        "name" String "ECDH-RSA-AES128-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH/ECDSA"
        "mac" String "SHA1"
        "name" String "ECDH-ECDSA-AES128-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kRSA"
        "mac" String "AEAD"
        "name" String "AES128-GCM-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kRSA"
        "mac" String "SHA256"
        "name" String "AES128-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kRSA"
        "mac" String "SHA1"
        "name" String "AES128-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "3DES"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "SHA1"
        "name" String "ECDHE-RSA-DES-CBC3-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aECDSA"
        "encryption" String "3DES"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "SHA1"
        "name" String "ECDHE-ECDSA-DES-CBC3-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "3DES"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "SHA1"
        "name" String "EDH-RSA-DES-CBC3-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aDSS"
        "encryption" String "3DES"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "SHA1"
        "name" String "EDH-DSS-DES-CBC3-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "3DES"
        "export" String ""
        "keyExchange" String "kECDH/RSA"
        "mac" String "SHA1"
        "name" String "ECDH-RSA-DES-CBC3-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "3DES"
        "export" String ""
        "keyExchange" String "kECDH/ECDSA"
        "mac" String "SHA1"
        "name" String "ECDH-ECDSA-DES-CBC3-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "3DES"
        "export" String ""
        "keyExchange" String "kRSA"
        "mac" String "SHA1"
        "name" String "DES-CBC3-SHA"
        "protocolVersion" String "SSLv3"

    "cipherFilter" String "DEFAULT"
    "enabledCipher" Array Struct 49
        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "AEAD"
        "name" String "ECDHE-RSA-AES256-GCM-SHA384"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aECDSA"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "AEAD"
        "name" String "ECDHE-ECDSA-AES256-GCM-SHA384"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "SHA384"
        "name" String "ECDHE-RSA-AES256-SHA384"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aECDSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "SHA384"
        "name" String "ECDHE-ECDSA-AES256-SHA384"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "SHA1"
        "name" String "ECDHE-RSA-AES256-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aECDSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "SHA1"
        "name" String "ECDHE-ECDSA-AES256-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aDSS"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "AEAD"
        "name" String "DHE-DSS-AES256-GCM-SHA384"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "AEAD"
        "name" String "DHE-RSA-AES256-GCM-SHA384"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "SHA256"
        "name" String "DHE-RSA-AES256-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aDSS"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "SHA256"
        "name" String "DHE-DSS-AES256-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "SHA1"
        "name" String "DHE-RSA-AES256-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aDSS"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "SHA1"
        "name" String "DHE-DSS-AES256-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kECDH/RSA"
        "mac" String "AEAD"
        "name" String "ECDH-RSA-AES256-GCM-SHA384"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kECDH/ECDSA"
        "mac" String "AEAD"
        "name" String "ECDH-ECDSA-AES256-GCM-SHA384"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH/RSA"
        "mac" String "SHA384"
        "name" String "ECDH-RSA-AES256-SHA384"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH/ECDSA"
        "mac" String "SHA384"
        "name" String "ECDH-ECDSA-AES256-SHA384"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH/RSA"
        "mac" String "SHA1"
        "name" String "ECDH-RSA-AES256-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH/ECDSA"
        "mac" String "SHA1"
        "name" String "ECDH-ECDSA-AES256-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kRSA"
        "mac" String "AEAD"
        "name" String "AES256-GCM-SHA384"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kRSA"
        "mac" String "SHA256"
        "name" String "AES256-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kRSA"
        "mac" String "SHA1"
        "name" String "AES256-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "AEAD"
        "name" String "ECDHE-RSA-AES128-GCM-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aECDSA"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "AEAD"
        "name" String "ECDHE-ECDSA-AES128-GCM-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "SHA256"
        "name" String "ECDHE-RSA-AES128-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aECDSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "SHA256"
        "name" String "ECDHE-ECDSA-AES128-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "SHA1"
        "name" String "ECDHE-RSA-AES128-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aECDSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "SHA1"
        "name" String "ECDHE-ECDSA-AES128-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aDSS"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "AEAD"
        "name" String "DHE-DSS-AES128-GCM-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "AEAD"
        "name" String "DHE-RSA-AES128-GCM-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "SHA256"
        "name" String "DHE-RSA-AES128-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aDSS"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "SHA256"
        "name" String "DHE-DSS-AES128-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "SHA1"
        "name" String "DHE-RSA-AES128-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aDSS"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "SHA1"
        "name" String "DHE-DSS-AES128-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kECDH/RSA"
        "mac" String "AEAD"
        "name" String "ECDH-RSA-AES128-GCM-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kECDH/ECDSA"
        "mac" String "AEAD"
        "name" String "ECDH-ECDSA-AES128-GCM-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH/RSA"
        "mac" String "SHA256"
        "name" String "ECDH-RSA-AES128-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH/ECDSA"
        "mac" String "SHA256"
        "name" String "ECDH-ECDSA-AES128-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH/RSA"
        "mac" String "SHA1"
        "name" String "ECDH-RSA-AES128-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kECDH/ECDSA"
        "mac" String "SHA1"
        "name" String "ECDH-ECDSA-AES128-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AESGCM"
        "export" String ""
        "keyExchange" String "kRSA"
        "mac" String "AEAD"
        "name" String "AES128-GCM-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kRSA"
        "mac" String "SHA256"
        "name" String "AES128-SHA256"
        "protocolVersion" String "TLSv1.2"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kRSA"
        "mac" String "SHA1"
        "name" String "AES128-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "3DES"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "SHA1"
        "name" String "ECDHE-RSA-DES-CBC3-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aECDSA"
        "encryption" String "3DES"
        "export" String ""
        "keyExchange" String "kECDH"
        "mac" String "SHA1"
        "name" String "ECDHE-ECDSA-DES-CBC3-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "3DES"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "SHA1"
        "name" String "EDH-RSA-DES-CBC3-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aDSS"
        "encryption" String "3DES"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "SHA1"
        "name" String "EDH-DSS-DES-CBC3-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "3DES"
        "export" String ""
        "keyExchange" String "kECDH/RSA"
        "mac" String "SHA1"
        "name" String "ECDH-RSA-DES-CBC3-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aECDH"
        "encryption" String "3DES"
        "export" String ""
        "keyExchange" String "kECDH/ECDSA"
        "mac" String "SHA1"
        "name" String "ECDH-ECDSA-DES-CBC3-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "3DES"
        "export" String ""
        "keyExchange" String "kRSA"
        "mac" String "SHA1"
        "name" String "DES-CBC3-SHA"
        "protocolVersion" String "SSLv3" 
)
    CREATE
	(
	    parent "ManagedElement=1,SystemFunctions=1,Security=1"
	    identity "1"
	    moType Ssh
	    exception none
	    nrOfAttributes 5 
	    "SshId" String "1"
	"supportedCipher" Array String 9
			"aes256-gcm@openssh.com"
			"aes256-ctr"
			"aes192-ctr"
			"aes128-gcm@openssh.com"
			"aes128-ctr"
			"AEAD_AES_256_GCM"
			"AEAD_AES_128_GCM"
			"aes128-cbc"
			"3des-cbc"
	"supportedKeyExchange" Array String 10
			"ecdh-sha2-nistp384"
			"ecdh-sha2-nistp521"
			"ecdh-sha2-nistp256"
			"diffie-hellman-group-exchange-sha256"
			"diffie-hellman-group16-sha512"
			"diffie-hellman-group18-sha512"
			"diffie-hellman-group14-sha256"
			"diffie-hellman-group14-sha1"
			"diffie-hellman-group-exchange-sha1"
			"diffie-hellman-group1-sha1"
       "supportedMac" Array String 5
			"hmac-sha2-256"
			"hmac-sha2-512"
			"hmac-sha1"
			"AEAD_AES_128_GCM"
			"AEAD_AES_256_GCM"
		
	)
	CREATE
	(
	    parent "ManagedElement=1,SystemFunctions=1,Security=1"
	    identity "1"
	    moType Ssh
	    exception none
	    nrOfAttributes 4 
	    "SshId" String "1"
	"selectedKeyExchange" Array String 10
			"ecdh-sha2-nistp384"
			"ecdh-sha2-nistp521"
			"ecdh-sha2-nistp256"
			"diffie-hellman-group-exchange-sha256"
			"diffie-hellman-group16-sha512"
			"diffie-hellman-group18-sha512"
			"diffie-hellman-group14-sha256"
			"diffie-hellman-group14-sha1"
			"diffie-hellman-group-exchange-sha1"
			"diffie-hellman-group1-sha1"
	"selectedCipher" Array String 9
                        "aes256-gcm@openssh.com"
                        "aes256-ctr"
                        "aes192-ctr"
                        "aes128-gcm@openssh.com"
                        "aes128-ctr"
                        "AEAD_AES_256_GCM"
                        "AEAD_AES_128_GCM"
                        "aes128-cbc"
                        "3des-cbc"
	    "selectedMac" Array String 5
			"hmac-sha2-256"
			"hmac-sha2-512"
			"hmac-sha1"
			"AEAD_AES_128_GCM"
			"AEAD_AES_256_GCM"
	)

MOSC


#######################################################################################
#Making MMLSCRIPT
#######################################################################################

MMLSCRIPT=$SIM"_Cipher.mml"
rm -rf $MMLSCRIPT

echo '.open '$SIM >> $MMLSCRIPT
echo '.select network' >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD'/'$MOSCRIPT'";' >> $MMLSCRIPT

~/inst/netsim_shell < $MMLSCRIPT

rm -rf $MMLSCRIPT
rm -rf $MOSCRIPT
