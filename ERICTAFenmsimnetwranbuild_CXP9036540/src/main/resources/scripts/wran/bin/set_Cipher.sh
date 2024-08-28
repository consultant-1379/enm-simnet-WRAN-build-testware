#!/bin/sh

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
    mo "ManagedElement=1,SystemFunctions=1,Security=1,Ssh=1"
    // moid = 8
    exception none
    nrOfAttributes 6
    "supportedKeyExchange" Array String 2
        "ssh-rsa"
        "ssh-dss"
    "supportedCipher" Array String 5
        "aes256-ctr"
        "aes192-ctr"
        "aes128-ctr"
        "aes128-cbc"
        "3des-cbc"
    "supportedMac" Array String 3
        "hmac-sha2-256"
        "hmac-sha2-512"
        "hmac-sha1"
    "selectedKeyExchange" Array String 2
        "ssh-rsa"
        "ssh-dss"
    "selectedCipher" Array String 5
        "aes256-ctr"
        "aes192-ctr"
        "aes128-ctr"
        "aes128-cbc"
        "3des-cbc"
    "selectedMac" Array String 3
        "hmac-sha2-256"
        "hmac-sha2-512"
        "hmac-sha1"
        
)
SET
(
    mo "ManagedElement=1,SystemFunctions=1,Security=1,Tls=1"
    exception none
    nrOfAttributes 1
    "supportedCipher" Array Struct 11



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
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kRSA"
        "mac" String "SHA1"
        "name" String "AES256-SHA"
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
        "authentication" String "aRSA"
        "encryption" String "3DES"
        "export" String ""
        "keyExchange" String "kRSA"
        "mac" String "SHA1"
        "name" String "DES-CBC3-SHA"
        "protocolVersion" String "SSLv3"


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
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kRSA"
        "mac" String "SHA1"
        "name" String "AES128-SHA"
        "protocolVersion" String "SSLv3"

        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "DES"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "SHA1"
        "name" String "EDH-RSA-DES-CBC-SHA"
        "protocolVersion" String "SSLv3"
        
        
        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "DES"
        "export" String ""
        "keyExchange" String "kRSA"
        "mac" String "SHA1"
        "name" String "DES-CBC-SHA"
        "protocolVersion" String "SSLv3"

      
    "enabledCipher" Array Struct 11
       
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
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kRSA"
        "mac" String "SHA1"
        "name" String "AES256-SHA"
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
        "authentication" String "aRSA"
        "encryption" String "3DES"
        "export" String ""
        "keyExchange" String "kRSA"
        "mac" String "SHA1"
        "name" String "DES-CBC3-SHA"
        "protocolVersion" String "SSLv3"


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
        "authentication" String "aRSA"
        "encryption" String "AES"
        "export" String ""
        "keyExchange" String "kRSA"
        "mac" String "SHA1"
        "name" String "AES128-SHA"
        "protocolVersion" String "SSLv3"


        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "DES"
        "export" String ""
        "keyExchange" String "kDH"
        "mac" String "SHA1"
        "name" String "EDH-RSA-DES-CBC-SHA"
        "protocolVersion" String "SSLv3"



        nrOfElements 7
        "authentication" String "aRSA"
        "encryption" String "DES"
        "export" String ""
        "keyExchange" String "kRSA"
        "mac" String "SHA1"
        "name" String "DES-CBC-SHA"
        "protocolVersion" String "SSLv3"
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
