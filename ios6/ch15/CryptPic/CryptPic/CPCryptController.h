//
//  CPCryptController.h
//  CryptPic
//
//  Created by Rob Napier on 8/9/11.
//  Copyright (c) 2011 Rob Napier. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  kEncryptionModeDisk = 0,
  kEncryptionModeMemory
} CPEncryptionMode;


@interface CPCryptController : NSObject

+ (CPCryptController *)sharedController;
@property (strong, nonatomic) NSData *encryptedData;
@property (strong, nonatomic) NSData *iv;
@property (strong, nonatomic) NSData *salt;
@property (strong, nonatomic) NSData *HMACSalt;
@property (strong, nonatomic) NSData *HMAC;
@property (assign, nonatomic) CPEncryptionMode encryptionMode;

- (BOOL)encryptData:(NSData *)data password:(NSString *)password error:(NSError **)error;
- (NSData *)decryptDataWithPassword:(NSString *)password error:(NSError **)error;
@end
