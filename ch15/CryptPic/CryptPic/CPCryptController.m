//
//  CPCryptController.m
//  CryptPic
//
//  Created by Rob Napier on 8/9/11.
//  Copyright (c) 2011 Rob Napier. All rights reserved.
//

#import "CPCryptController.h"
#import "RNCryptManager.h"

static NSString * const kModeKey = @"mode";

@implementation CPCryptController

+ (CPCryptController *)sharedController {
  static CPCryptController *sSharedController;
  if (! sSharedController) {
    sSharedController = [[CPCryptController alloc] init];
  }
  return sSharedController;
}

- (BOOL)encryptDataInMemory:(NSData *)data password:(NSString *)password error:(NSError **)error {
  NSData *iv;
  NSData *salt;
  NSData *HMACSalt;
  NSData *HMAC;
  self.encryptedData = [RNCryptManager encryptedDataForData:data
                                                   password:password
                                                         iv:&iv
                                                       salt:&salt
                                                   HMACSalt:&HMACSalt
                                                       HMAC:&HMAC
                                                      error:error];
  self.iv = iv;
  self.salt = salt;
  self.HMACSalt = HMACSalt;
  self.HMAC = HMAC;
  return self.encryptedData ? YES : NO;
}


- (BOOL)encryptDataWithStream:(NSData *)data password:(NSString *)password error:(NSError **)error {

  NSInputStream *pictureStream = [NSInputStream
                                  inputStreamWithData:data];
  [pictureStream open];
  
  NSString *encryptedPath =
  [NSTemporaryDirectory() 
   stringByAppendingPathComponent:@"encrypted.dat"];

  NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath:encryptedPath
                                                                   append:NO];
  [outputStream open];
  
  BOOL result = [RNCryptManager encryptFromStream:pictureStream
                                         toStream:outputStream
                                         password:password
                                            error:error];
  [pictureStream close];
  [outputStream close];
  return result;
}


- (BOOL)encryptData:(NSData *)data password:(NSString *)password error:(NSError **)error {
  if ([self encryptionMode] == kEncryptionModeDisk) {
    return [self encryptDataWithStream:data password:password error:error];
  }
  else {
    return [self encryptDataInMemory:data password:password error:error];
  }
}

- (NSData *)decryptStreamDataWithPassword:(NSString *)password error:(NSError **)error {
  NSString *encryptedPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"encrypted.dat"];
  NSInputStream *inStream = [NSInputStream inputStreamWithFileAtPath:encryptedPath];
  [inStream open];
  
  NSOutputStream *outStream = [NSOutputStream outputStreamToMemory];
  [outStream open];

  NSData *data = nil;
  if ([RNCryptManager decryptFromStream:inStream toStream:outStream password:password error:error]) {
    data = [outStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
  }
  
  [inStream close];
  [outStream close];
  return data;
}

- (NSData *)decryptMemoryDataWithPassword:(NSString *)password error:(NSError **)error {
  return [RNCryptManager decryptedDataForData:self.encryptedData
                                     password:password
                                           iv:self.iv
                                         salt:self.salt
                                     HMACSalt:self.HMACSalt
                                         HMAC:self.HMAC                                        
                                        error:error];
}

- (NSData *)decryptDataWithPassword:(NSString *)password error:(NSError **)error {
  if ([self encryptionMode] == kEncryptionModeDisk) {
    return [self decryptStreamDataWithPassword:password error:error];
  }
  else {
    return [self decryptMemoryDataWithPassword:password error:error];
  }
 
}


@end
