//
//  ViewController.m
//  RichText
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

#import "ViewController.h"
#import <CoreText/CoreText.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation ViewController

UIFont * GetVariationOfFontWithTrait(UIFont *baseFont,
                                     CTFontSymbolicTraits trait) {
  CGFloat fontSize = [baseFont pointSize];
  
  CFStringRef
  baseFontName = (__bridge CFStringRef)[baseFont fontName];
  CTFontRef baseCTFont = CTFontCreateWithName(baseFontName,
                                              fontSize, NULL);
  
  CTFontRef ctFont =
  CTFontCreateCopyWithSymbolicTraits(baseCTFont, 0, NULL,
                                     trait, trait);
  
  NSString *variantFontName =
  CFBridgingRelease(CTFontCopyName(ctFont,
                                   kCTFontPostScriptNameKey));
  
  UIFont *variantFont = [UIFont fontWithName:variantFontName
                                       size:fontSize];
  CFRelease(ctFont);
  CFRelease(baseCTFont);
  
  return variantFont;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  const CGFloat fontSize = 16.0;
  
  // Create the base string.
  // Note how you can define a string over multiple lines.
  NSString *string =
  @"Here is some simple text that includes bold and italics.\n"
  @"We can even include some color.";
  
  // Create the mutable attributed string
  NSMutableAttributedString *attrString =
  [[NSMutableAttributedString alloc] initWithString:string];

  NSUInteger length = [string length];

  // Set the base font
  UIFont *baseFont = [UIFont systemFontOfSize:fontSize];
  [attrString addAttribute:NSFontAttributeName value:baseFont
                     range:NSMakeRange(0, length)];
  
  // Apply bold using the bold system font
  // and seaching for the word "bold"
  UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
  [attrString addAttribute:NSFontAttributeName value:boldFont
                     range:[string rangeOfString:@"bold"]];
  
  // Apply italics using Core Text to apply a trait
  // (You could have used italicSystemFontOfSize: here, but
  // this demonstrates a more flexible approach.)
  UIFont *italicFont = GetVariationOfFontWithTrait(baseFont,
                                                   kCTFontTraitItalic);
  [attrString addAttribute:NSFontAttributeName value:italicFont
                     range:[string rangeOfString:@"italics"]];
  
  // Apply color
  UIColor *color = [UIColor redColor];
  [attrString addAttribute:NSForegroundColorAttributeName
                     value:color
                     range:[string rangeOfString:@"color"]];
  
  // Right justify the first paragraph
  NSMutableParagraphStyle *
  style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
  style.alignment = NSTextAlignmentRight;
  [attrString addAttribute:NSParagraphStyleAttributeName
                     value:style
                     range:NSMakeRange(0, 1)];
  
  self.textView.attributedText = attrString;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
