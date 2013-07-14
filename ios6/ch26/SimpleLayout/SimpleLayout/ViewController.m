//
//  ViewController.m
//  SimpleLayout
//
//  Created by Rob Napier on 8/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>
#import "CoreTextLabel.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
   
  CFMutableAttributedStringRef attrString;
  CTFontRef baseFont, boldFont, italicFont;
  
  // Create the base string.
  // Note how you can define a string over multiple lines.
  CFStringRef string = CFSTR
  (
   "Here is some simple text that includes bold and italics.\n"
   "\n"
   "We can even include some color."
   );
  
  // Create the mutable attributed string
  attrString = CFAttributedStringCreateMutable(NULL, 0);
  CFAttributedStringReplaceString(attrString, 
                                  CFRangeMake(0, 0),
                                  string);
  
  // Set the base font
  baseFont = CTFontCreateUIFontForLanguage(kCTFontUserFontType,
                                           16.0,
                                           NULL);
  CFIndex length = CFStringGetLength(string);
  CFAttributedStringSetAttribute(attrString,
                                 CFRangeMake(0, length),
                                 kCTFontAttributeName, 
                                 baseFont);
  
  // Apply bold by finding the bold version of the current font.
  boldFont = CTFontCreateCopyWithSymbolicTraits(baseFont,
                                                0,
                                                NULL,
                                                kCTFontBoldTrait,
                                                kCTFontBoldTrait);
  CFAttributedStringSetAttribute(attrString,
                                 CFStringFind(string, 
                                              CFSTR("bold"),
                                              0),
                                 kCTFontAttributeName, 
                                 boldFont);
  
  // Apply italics
  italicFont = CTFontCreateCopyWithSymbolicTraits(baseFont,
                                                  0,
                                                  NULL,
                                                kCTFontItalicTrait, 
                                                kCTFontItalicTrait);
  CFAttributedStringSetAttribute(attrString,
                                 CFStringFind(string, 
                                              CFSTR("italics"),
                                              0),
                                 kCTFontAttributeName,
                                 italicFont);
  
  // Apply color
  CGColorRef color = [[UIColor redColor] CGColor];
  CFAttributedStringSetAttribute(attrString,
                                 CFStringFind(string,
                                              CFSTR("color"), 
                                              0),
                                 kCTForegroundColorAttributeName,
                                 color);
  
  // Center the last line
  CTTextAlignment alignment = kCTCenterTextAlignment;
  CTParagraphStyleSetting setting = {
    kCTParagraphStyleSpecifierAlignment, 
    sizeof(alignment),
    &alignment};
  
  CTParagraphStyleRef style = CTParagraphStyleCreate(&setting, 1);
  CFRange lastLineRange = CFStringFind(string, CFSTR("\n"),
                                       kCFCompareBackwards);
  ++lastLineRange.location;
  lastLineRange.length =
                CFStringGetLength(string) - lastLineRange.location;
  CFAttributedStringSetAttribute(attrString, lastLineRange,
                                 kCTParagraphStyleAttributeName,
                                 style);

  CoreTextLabel *label = [[CoreTextLabel alloc] 
                          initWithFrame:CGRectInset(self.view.bounds,
                                                    10,
                                                    10)];
  label.attributedString = (__bridge id)attrString;
  [self.view addSubview:label];
  
  CFRelease(attrString);
  CFRelease(baseFont);
  CFRelease(boldFont);
  CFRelease(italicFont);
}

@end
