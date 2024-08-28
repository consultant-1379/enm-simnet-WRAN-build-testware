#!/bin/sh
SIM=$1

RbsStr=$(echo $SIM | awk -F"MSRBS" '{print $2}'| awk -F"x" '{print $2}')
RBSNUM=(${RbsStr//-/ })
RncStr=(${SIM//RNC/ })
RNCNUM=${RncStr[1]}
RNCNAME="RNC"$RNCNUM

COUNT=1
while [ $COUNT -le $RBSNUM  ]
do
if [ $COUNT -le 9 ]
then
NODENAME=$RNCNAME'MSRBS-V20'$COUNT
else
NODENAME=$RNCNAME'MSRBS-V2'$COUNT
fi
#######################################################
#Making MOSCRIPT
#######################################################

MOSCRIPT=$NODENAME"_Cipher.mo"

if [ -s $MOSCRIPT ]
then
echo "Removing old moscripts"
rm -rf $MOSCRIPT
fi

cat >> $MOSCRIPT << MOSC
SET
(
    mo "ManagedElement=$NODENAME,SystemFunctions=1,SecM=1,Ssh=1"
    // moid = 8
    exception none
    nrOfAttributes 6
    "supportedKeyExchanges" Array String 2
        "ssh-rsa"
        "ssh-dss"
    "supportedCiphers" Array String 5
        "aes256-ctr"
        "aes192-ctr"
        "aes128-ctr"
        "aes128-cbc"
        "3des-cbc"
    "supportedMacs" Array String 3
        "hmac-sha2-256"
        "hmac-sha2-512"
        "hmac-sha1"
    "selectedKeyExchanges" Array String 2
        "ssh-rsa"
        "ssh-dss"
    "selectedCiphers" Array String 5
        "aes256-ctr"
        "aes192-ctr"
        "aes128-ctr"
        "aes128-cbc"
        "3des-cbc"
    "selectedMacs" Array String 3
        "hmac-sha2-256"
        "hmac-sha2-512"
        "hmac-sha1"
)
SET
(
    mo "ManagedElement=$NODENAME,SystemFunctions=1,SecM=1,Tls=1"
    exception none
    nrOfAttributes 1
    "supportedCiphers" Array Struct 11

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

      
    "enabledCiphers" Array Struct 11
       
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
#######################################################
# Making MMLSCRIPT
#######################################################
MMLSCRIPT=$NODENAME"_Cipher.mml"

if [ -s $MMLSCRIPT ]
then
echo "Removing Old mmlscripts"
rm -rf $MMLSCRIPT
fi

echo '.open '$SIM >> $MMLSCRIPT
echo '.select '$NODENAME >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD/$MOSCRIPT'";' >> $MMLSCRIPT

~/inst/netsim_shell < $MMLSCRIPT

rm -rf $MMLSCRIPT
rm -rf $MOSCRIPT
COUNT=`expr $COUNT + 1`
done

###########################################################
#Setting Cipher for RNC node
###########################################################
##########MO Script##############################
RNC_Cipher=$RNCNAME"_Cipher.mo"
cat >> $RNC_Cipher << RNC
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
RNC

####################Mml Script##########################################################
RNC_CipherMml=$RNCNAME"_Cipher.mml"
echo '.open '$SIM >> $RNC_CipherMml
echo '.select '$RNCNAME >> $RNC_CipherMml
echo '.start ' >> $RNC_CipherMml
echo 'useattributecharacteristics:switch="off";' >> $RNC_CipherMml
echo 'kertayle:file="'$PWD/$RNC_Cipher'";' >> $RNC_CipherMml
~/inst/netsim_shell < $RNC_CipherMml
rm -rf $RNC_Cipher
rm -rf $RNC_CipherMml
