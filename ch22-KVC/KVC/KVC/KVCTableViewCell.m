//
//  KVCTableViewCell.h
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
#import "KVCTableViewCell.h"

@implementation KVCTableViewCell

- (BOOL)isReady {
  // Only display something if configured
  return (self.object && [self.property length] > 0);
}

- (void)update {
  NSString *text;
  if (self.isReady) {
    // Ask the target for the value of its property that has the
    // name given in self.property. Then convert that into a human
    // readable string
    id value = [self.object valueForKeyPath:self.property];
    text = [value description];
  }
  else {
    text = @"";
  }
  self.textLabel.text = text;
}

- (id)initWithReuseIdentifier:(NSString *)identifier {
  return [self initWithStyle:UITableViewCellStyleDefault
             reuseIdentifier:identifier];
}

- (void)setObject:(id)anObject {
  _object = anObject;
  [self update];
}

- (void)setProperty:(NSString *)aProperty {
  _property = aProperty;
  [self update];
}
@end