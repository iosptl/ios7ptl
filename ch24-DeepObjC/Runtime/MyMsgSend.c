//
//  MyMsgSend.c
//  Runtime
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

#include <stdio.h>
#include <objc/runtime.h>
#include "MyMsgSend.h"

static const void *myMsgSend(id receiver, const char *name) {
  SEL selector = sel_registerName(name);
  IMP methodIMP =
  class_getMethodImplementation(object_getClass(receiver),
                                selector);
  return methodIMP(receiver, selector);
}

void RunMyMsgSend() {
  // NSObject *object = [[NSObject alloc] init];
  Class class = (Class)objc_getClass("NSObject");
  id object = class_createInstance(class, 0);
  myMsgSend(object, "init");
  
  // id description = [object description];
  id description = (id)myMsgSend(object, "description");
  
  // const char *cstr = [description UTF8String];
  const char *cstr = myMsgSend(description, "UTF8String");
  
  printf("%s\n", cstr);
}
