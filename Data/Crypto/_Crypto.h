//
//  _Crypto.h

// aes
#import "AESCryptor.h"
#import "NSData+Random.h"


// rsa
#import "RSACryptor.h"
#import "RSABase64Cryptor.h"

// sha
//#import "NSString+SHA.h"

// md5
//#import "NSString+MD5.h"




// base 64
#import "NSData+Base64.h"
#import "NSString+Base64.h"



// ___________________________________________ RSA  ___________________________________________

// openssl version -a

/**
 *
 * 1. Create the RSA Private Key
 *
 * openssl genrsa -out private_key.pem 1024																			-> Generate 'private_key.pem'
 *
 *
 * 2. Create a certificate signing request with the private key
 * (This step u will enter some Info. For further reference, you'd better write them down or make a screen shot)
 *
 * openssl req -new -key private_key.pem -out rsaCertReq.csr														-> Generate 'rsaCertReq.csr'
 *
 *
 * 3. Create a self-signed certificate with the private key and signing request										-> Generate 'rsaCert.crt'
 *
 * openssl x509 -req -days 3650 -in rsaCertReq.csr -signkey private_key.pem -out rsaCert.crt
 *
 *
 *
 *
 * 4. Convert the certificate to DER format: the certificate contains the public key
 *
 * openssl x509 -outform der -in rsaCert.crt -out public_key.der													-> Generate 'public_key.der' (for IOS to encrypt)
 *
 *
 * 5. Export the private key and certificate to p12 file.
 * (This step will ask u to enter password, it will be used in your IOS Code, do not forget it)
 *
 * openssl pkcs12 -export -out private_key.p12 -inkey private_key.pem -in rsaCert.crt								-> Generate 'private_key.p12' (for IOS to decrypt)
 *
 *
 *
 *
 * 6.
 * openssl rsa -in private_key.pem -out rsa_public_key.pem -pubout													-> Generate 'rsa_public_key.pem' (for JAVA to encrypt)
 *
 * 7.
 * openssl pkcs8 -topk8 -in private_key.pem -out pkcs8_private_key.pem -nocrypt										-> Generate 'pkcs8_private_key.pem' (for JAVA to decrypt)
 *
 *
 */


// ___________________________________________ RSA  ___________________________________________



