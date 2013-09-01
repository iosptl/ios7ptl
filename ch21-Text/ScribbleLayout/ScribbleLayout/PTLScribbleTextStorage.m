//
//  ScribbleTextStorage.m
//  ScribbleLayout
//
//  Created by Rob Napier on 8/30/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
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
