//  Copyright (c) 2013 Rob Napier
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
// Based on Apple's TKDInteractiveTextColoringTextStorage sample code.

#import "PTLScribbleTextStorage.h"

NSString * const PTLDefaultTokenName = @"PTLDefaultTokenName";

NSString * const PTLRedactStyleAttributeName = @"PTLRedactStyleAttributeName";
NSString * const PTLHighlightColorAttributeName = @"PTLHighlightColorAttributeName";

@interface PTLScribbleTextStorage ()
@property (nonatomic, readwrite) NSMutableAttributedString *backingStore;
@property (nonatomic, readwrite) BOOL dynamicTextNeedsUpdate;
@end

@implementation PTLScribbleTextStorage

- (id)init {
  self = [super init];
  if (self) {
    _backingStore = [NSMutableAttributedString new];
  }
  return self;
}

- (NSString *)string {
  return [self.backingStore string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location
                     effectiveRange:(NSRangePointer)range {
  return [self.backingStore attributesAtIndex:location
                               effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range
                      withString:(NSString *)str {
  [self beginEditing];
  [self.backingStore replaceCharactersInRange:range withString:str];
  [self edited:NSTextStorageEditedCharacters|NSTextStorageEditedAttributes
         range:range
changeInLength:str.length - range.length];
  self.dynamicTextNeedsUpdate = YES;
  [self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs
                range:(NSRange)range {
  [self beginEditing];
  [self.backingStore setAttributes:attrs range:range];
  [self edited:NSTextStorageEditedAttributes
         range:range
changeInLength:0];
  [self endEditing];
}

- (void)performReplacementsForCharacterChangeInRange:(NSRange)changedRange {
  NSString *string = [self.backingStore string];

  NSRange startLine = NSMakeRange(changedRange.location, 0);
  NSRange endLine = NSMakeRange(NSMaxRange(changedRange), 0);
  NSRange
  extendedRange = NSUnionRange(changedRange,
                               [string
                                lineRangeForRange:startLine]);
  extendedRange = NSUnionRange(extendedRange,
                               [string
                                lineRangeForRange:endLine]);
  [self applyTokenAttributesToRange:extendedRange];
}

-(void)processEditing {
  if(self.dynamicTextNeedsUpdate) {
    self.dynamicTextNeedsUpdate = NO;
    [self performReplacementsForCharacterChangeInRange:[self editedRange]];
  }
  [super processEditing];
}

- (void)applyTokenAttributesToRange:(NSRange)searchRange {
  NSDictionary *defaultAttributes = self.tokens[PTLDefaultTokenName];

  NSString *string = [self.backingStore string];
  [string enumerateSubstringsInRange:searchRange
                             options:NSStringEnumerationByWords
                          usingBlock:^(NSString *substring,
                                       NSRange substringRange,
                                       NSRange enclosingRange,
                                       BOOL *stop) {
                            NSDictionary *
                            attributesForToken = self.tokens[substring];

                            if(!attributesForToken)
                              attributesForToken = defaultAttributes;

                            if(attributesForToken)
                              [self setAttributes:attributesForToken
                                            range:substringRange];
                          }];
}

@end
