//
//  ConnectionViewController.m
//  Connection
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

#import "ConnectionViewController.h"

CFAbsoluteTime SecCertificateNotValidBefore(SecCertificateRef certificate);
CFAbsoluteTime SecCertificateNotValidAfter(SecCertificateRef certificate);

@interface ConnectionViewController ()
@property (nonatomic, readwrite, strong) NSURLConnection *connection;
@end

@implementation ConnectionViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  // IP Address for encrypted.google.com
//  NSURL *url = [NSURL URLWithString:@"https://72.14.204.113"];
  NSURL *url = [NSURL URLWithString:@"https://encrypted.google.com"];

  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  self.connection = [NSURLConnection connectionWithRequest:request
                                                  delegate:self];
}

static OSStatus RNSecTrustEvaluateAsX509(SecTrustRef trust,
                                         SecTrustResultType *result
                                         )
{
  OSStatus status = errSecSuccess;

  SecPolicyRef policy = SecPolicyCreateBasicX509();
  SecTrustRef newTrust;
  CFIndex numberOfCerts = SecTrustGetCertificateCount(trust);
  CFMutableArrayRef certs;
  certs = CFArrayCreateMutable(NULL,
                               numberOfCerts,
                               &kCFTypeArrayCallBacks);
  for (NSUInteger index = 0; index < numberOfCerts; ++index) {
    SecCertificateRef cert;
    cert = SecTrustGetCertificateAtIndex(trust, index);
    CFArrayAppendValue(certs, cert);
  }

  status = SecTrustCreateWithCertificates(certs,
                                          policy,
                                          &newTrust);
  if (status == errSecSuccess) {
    status = SecTrustEvaluate(newTrust, result);
  }

  CFRelease(policy);
  CFRelease(newTrust);
  CFRelease(certs);
  
  return status;
}

- (void)connection:(NSURLConnection *)connection
  willSendRequestForAuthenticationChallenge:
  (NSURLAuthenticationChallenge *)challenge
{
  NSURLProtectionSpace *protSpace = challenge.protectionSpace;
  SecTrustRef trust = protSpace.serverTrust;
  SecTrustResultType result = kSecTrustResultFatalTrustFailure;
    
  OSStatus status = SecTrustEvaluate(trust, &result);
  if (status == errSecSuccess && 
      result == kSecTrustResultRecoverableTrustFailure) {
    SecCertificateRef cert = SecTrustGetCertificateAtIndex(trust, 
                                                           0);
    CFStringRef subject = SecCertificateCopySubjectSummary(cert);

    CFAbsoluteTime start = SecCertificateNotValidBefore(cert);
    CFAbsoluteTime end = SecCertificateNotValidAfter(cert);

    NSLog(@"Begin Date: %@", [NSDate dateWithTimeIntervalSinceReferenceDate:start]);
    NSLog(@"End Date: %@", [NSDate dateWithTimeIntervalSinceReferenceDate:end]);          
    
    NSLog(@"Trying to access %@. Got %@.", protSpace.host, 
          subject);
    CFRange range = CFStringFind(subject, CFSTR(".google.com"), 
                                 kCFCompareAnchored|
                                 kCFCompareBackwards);
    if (range.location != kCFNotFound) {
      status = RNSecTrustEvaluateAsX509(trust, &result);
    }
    CFRelease(subject);
  }
  

  if (status == errSecSuccess) { 
    switch (result) {
      case kSecTrustResultInvalid:
      case kSecTrustResultDeny:
      case kSecTrustResultFatalTrustFailure:
      case kSecTrustResultOtherError:
// We've tried everything:
      case kSecTrustResultRecoverableTrustFailure:  
        NSLog(@"Failing due to result: %lu", result);
        [challenge.sender cancelAuthenticationChallenge:challenge];
        break;
        
      case kSecTrustResultProceed:
      case kSecTrustResultConfirm:
      case kSecTrustResultUnspecified: {
        NSLog(@"Success with result: %lu", result);
        NSURLCredential *cred;
        cred = [NSURLCredential credentialForTrust:trust];
        [challenge.sender useCredential:cred 
             forAuthenticationChallenge:challenge];  
        }
        break;
        
      default:
        NSAssert(NO, @"Unexpected result from trust evaluation:%ld", 
                 result);
        break;
    }
  }
  else {
    // Something was broken
    NSLog(@"Complete failure with code: %lu", status);
    [challenge.sender cancelAuthenticationChallenge:challenge];
  }
}

- (void)connection:(NSURLConnection *)connection 
  didFailWithError:(NSError *)error {
  NSLog(@"didFailWithError:%@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  NSLog(@"didFinishLoading");
  self.connection = nil;
}

@end
