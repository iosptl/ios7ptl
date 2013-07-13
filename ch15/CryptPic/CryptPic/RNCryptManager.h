//
//  RNCryptManager.h
//  CryptPic
//
//  Copyright (c) 2012 Rob Napier
//
//  This code is licensed under the MIT License:
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#import <CommonCrypto/CommonHMAC.h>

extern NSString * const kRNCryptManagerErrorDomain;

typedef enum : NSInteger {
  kRNCryptManagerErrorBadHMAC = 1
} RNCryptManagerError;

@interface RNCryptManager : NSObject
+ (BOOL)encryptFromStream:(NSInputStream *)fromStream
                 toStream:(NSOutputStream *)toStream
                 password:(NSString *)password
                    error:(NSError **)error;

+ (BOOL)decryptFromStream:(NSInputStream *)fromStream
                 toStream:(NSOutputStream *)toStream
                 password:(NSString *)password
                    error:(NSError **)error;

+ (NSData *)encryptedDataForData:(NSData *)data
                        password:(NSString *)password
                              iv:(NSData **)iv
                            salt:(NSData **)salt
                        HMACSalt:(NSData **)HMACSalt
                            HMAC:(NSData **)HMAC
                           error:(NSError **)error;

+ (NSData *)decryptedDataForData:(NSData *)data
                        password:(NSString *)password 
                              iv:(NSData *)iv
                            salt:(NSData *)salt
                        HMACSalt:(NSData *)HMACSalt
                            HMAC:(NSData *)HMAC
                           error:(NSError **)error;
@end
