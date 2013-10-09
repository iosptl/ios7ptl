//
//  main.m
//  Runtime
//
//  Created by Rob Napier on 8/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "PrintObjectMethods.h"
#import "MyMsgSend.h"
#import "FastCall.h"

int main(int argc, char *argv[])
{
  @autoreleasepool {
    printf("PrintObjectMethods()\n");
    PrintObjectMethods();
    printf("\n\nRunMyMsgSend()\n");
    RunMyMsgSend();
    printf("\n\nFastCall()\n");
    FastCall();
    return 0; //UIApplicationMain(argc, argv, nil, nil);
  }
}
