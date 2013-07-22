//
//  main.m
//  CoreFoundation
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

#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import "MYStringConversion.h"

#define PrintFunction() printf("\n%s():\n", __FUNCTION__);

#pragma mark Core Foundation Types

static void testTypeMismatch() {
  PrintFunction();
  CFStringRef errName = CFSTR("error");
  CFErrorRef error = CFErrorCreate(NULL, errName, 0, NULL);
  CFPropertyListRef propertyList = error; // This should be a warning, but it isn't.
  
  printf("typeid(propertyList): %lu == typeid(Error): %lu\n", CFGetTypeID(propertyList), CFErrorGetTypeID());
  
  CFRelease(error);
}


#pragma mark Creating Strings

static void testCString() {
  PrintFunction();
  const char *cstring = "Hello World!";
  CFStringRef string = CFStringCreateWithCString(NULL, cstring,
                                                 kCFStringEncodingUTF8);
  CFShow(string);
  CFRelease(string);
}

static void testPascalString() {
  PrintFunction();
  // A common type of network buffer
  struct NetworkBuffer {
    UInt8 length;
    UInt8 data[];
  };
  
  // Some data we pulled off of the network into the buffer
  static struct NetworkBuffer buffer = {
    4, {'T', 'e', 'x', 't'}};
  
  CFStringRef string = CFStringCreateWithPascalString(NULL,
                                                      (ConstStr255Param)&buffer,
                                                      kCFStringEncodingUTF8);
  CFShow(string);
  CFRelease(string);
}


#pragma mark Converting to C strings

static void testCopyUTF8String() {
  PrintFunction();
  CFStringRef string = CFSTR("Hello");
  char * cstring = MYCFStringCopyUTF8String(string);	
  printf("%s\n", cstring);
  free(cstring);
}

static void testGetUTF8String() {
  PrintFunction();
  CFStringRef strings[3] = { CFSTR("One"), CFSTR("Two"), CFSTR("Three") };
  char * buffer = NULL;
  const char * cstring = NULL;

  for (unsigned i = 0; i < 3; ++i) {
    cstring = MYCFStringGetUTF8String(strings[i], &buffer);
    printf("%s\n", cstring);
  }
  
  free(buffer);
}

static void testFastUTF8Conversion() {
  PrintFunction();
  CFStringRef string = CFSTR("Hello");

  const CFIndex kBufferSize = 1024;
  char buffer[kBufferSize];
  CFStringEncoding encoding = kCFStringEncodingUTF8;
  const char *cstring;
  cstring = CFStringGetCStringPtr(string, encoding);
  if (cstring == NULL) {
    if (CFStringGetCString(string, buffer, kBufferSize, encoding)) {
      cstring = buffer;
    }
  }
  
  printf("%s\n", cstring);
}


#pragma mark String Backing Storage

static void testBytesNoCopy() {
  PrintFunction();
  const char *cstr = "Hello";
  char *bytes = CFAllocatorAllocate(kCFAllocatorDefault,
                                    strlen(cstr) + 1, 0);
  strcpy(bytes, cstr);
  CFStringRef str = CFStringCreateWithCStringNoCopy(kCFAllocatorDefault, bytes,
                                                    kCFStringEncodingUTF8,
                                                    kCFAllocatorDefault);
  CFShow(str);
  CFRelease(str);
}

static void testBytesNoCopyMalloc() {
  PrintFunction();
  const char *cstr = "Hello";
  char *bytes = malloc(strlen(cstr) + 1);
  strcpy(bytes, cstr);
  CFStringRef str =
  CFStringCreateWithCStringNoCopy(NULL, bytes, kCFStringEncodingUTF8,
                                  kCFAllocatorMalloc);
  
  CFShow(str);
  
  CFRelease(str);
}

static void testBytesNoCopyNull() {
  PrintFunction();
  const char *cstr = "Hello";
  char *bytes = malloc(strlen(cstr) + 1);
  strcpy(bytes, cstr);
  CFStringRef str =
  CFStringCreateWithCStringNoCopy(NULL, bytes, kCFStringEncodingUTF8, 
                                  kCFAllocatorNull);
  CFShow(str);
  CFRelease(str);
  
  // It's still safe to access bytes here, but not str
  printf("%s\n", bytes);
  
  free(bytes);
}


#pragma mark Callbacks

static void testNRArray() {
  PrintFunction();
  CFArrayCallBacks nrCallbacks = kCFTypeArrayCallBacks;
  nrCallbacks.retain = NULL;
  nrCallbacks.release = NULL;
  CFMutableArrayRef nrArray = CFArrayCreateMutable(NULL, 0, &nrCallbacks);
  CFStringRef string = CFStringCreateWithCString(NULL, "Stuff", kCFStringEncodingUTF8);
  CFArrayAppendValue(nrArray, string);
  
  CFShow(nrArray);
  
  CFRelease(nrArray);
  CFRelease(string);
}


#pragma mark CFArray

static void testCFArray() {
  PrintFunction();
  CFStringRef strings[3] = { CFSTR("One"), CFSTR("Two"), CFSTR("Three") };
  
  CFArrayRef array = CFArrayCreate(NULL, (void *)strings, 3,
                                   &kCFTypeArrayCallBacks);
  
  NSArray *nsArray = @[@"One", @"Two", @"Three"];
  
  BOOL result = [(__bridge id)array isEqual:nsArray];
  printf("Arrays equal: %d\n", result);
  
  CFRelease(array);
}


#pragma mark CFDictionary

static void testCFDictionary() {
  PrintFunction();

#define kCount 3
  CFStringRef keys[kCount] = { CFSTR("One"), CFSTR("Two"), CFSTR("Three") };	
  CFStringRef values[kCount] = { CFSTR("Foo"), CFSTR("Bar"), CFSTR("Baz") };	
  CFDictionaryRef dict = CFDictionaryCreate(NULL, 
                                            (void *)keys,
                                            (void *)values,
                                            kCount, 
                                            &kCFTypeDictionaryKeyCallBacks,
                                            &kCFTypeDictionaryValueCallBacks);
  
  NSDictionary *nsDict = @{@"One": @"Foo",
                          @"Two": @"Bar",
                          @"Three": @"Baz"};

  BOOL result = [(__bridge id)dict isEqual:nsDict];
  printf("Dicts equal: %d\n", result);
  
  CFRelease(dict);
}

static void testCFDictionaryNULL() {
  PrintFunction();
  CFMutableDictionaryRef dict = CFDictionaryCreateMutable(NULL, 0, NULL, &kCFTypeDictionaryValueCallBacks);
  CFDictionarySetValue(dict, NULL, CFSTR("Foo"));
  
  const void *value;
  Boolean fooPresent = CFDictionaryGetValueIfPresent(dict, NULL, &value);
  
  printf("fooPresent: %d\n", fooPresent);
  printf("values equal: %d\n", CFEqual(value, CFSTR("Foo")));
  
  CFRelease(dict);
}


#pragma mark Toll-free bridging

static void testTollFree() {
  PrintFunction();
  NSArray *nsArray = @[@"Foo"];
  CFIndex count = CFArrayGetCount((CFArrayRef)nsArray);
  printf("count=%lu\n", count);
}

static void testTollFreeReverse() {
  PrintFunction();
  CFMutableArrayRef cfArray = CFArrayCreateMutable(NULL, 0,
                                                   &kCFTypeArrayCallBacks);
  
  CFArrayAppendValue(cfArray, CFSTR("Foo"));

  NSUInteger count = [(__bridge id)cfArray count];
  printf("count=%u\n", count);
  
  CFRelease(cfArray);
}

static void testTreeInArray() {
  PrintFunction();
  CFTreeContext ctx = {0, (void*)CFSTR("Info"), CFRetain,
    CFRelease, CFCopyDescription};
  CFTreeRef tree = CFTreeCreate(NULL, &ctx);
  NSArray *array = @[(__bridge id)tree];
  
  CFRelease(tree);

  NSLog(@"Array=%@", array);
}

int main(int argc, char *argv[]) {
  @autoreleasepool {
    testTypeMismatch();
    testCString();
    testPascalString();
    testCopyUTF8String();
    testGetUTF8String();
    testFastUTF8Conversion();
    testBytesNoCopy();
    testBytesNoCopyMalloc();
    testBytesNoCopyNull();
    testNRArray();
    testCFArray();
    testCFDictionary();
    testCFDictionaryNULL();
    testTollFree();
    testTollFreeReverse();
    testTreeInArray();

    return 0;
  }
}
