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
#import "PTLViewController.h"

@interface PTLViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation PTLViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  NSString *string = @"Be Bold! And a little color wouldn’t hurt either.";

  NSDictionary *attrs = @{
                          NSFontAttributeName: [UIFont systemFontOfSize:36]
                          };

  NSMutableAttributedString *
  as = [[NSMutableAttributedString alloc] initWithString:string
                                              attributes:attrs];

  [as addAttribute:NSFontAttributeName
             value:[UIFont boldSystemFontOfSize:36]
             range:[string rangeOfString:@"Bold!"]];

  [as addAttribute:NSForegroundColorAttributeName
             value:[UIColor blueColor]
             range:[string rangeOfString:@"little color"]];

  [as addAttribute:NSFontAttributeName
             value:[UIFont systemFontOfSize:18]
             range:[string rangeOfString:@"little"]];

  [as addAttribute:NSFontAttributeName
             value:[UIFont fontWithName:@"Papyrus" size:36]
             range:[string rangeOfString:@"color"]];

  self.label.attributedText = as;
}

- (IBAction)toggleItalic:(id)sender {
  NSMutableAttributedString *as = [self.label.attributedText mutableCopy];

  [as enumerateAttribute:NSFontAttributeName
                 inRange:NSMakeRange(0, as.length)
                 options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired
              usingBlock:^(id value, NSRange range, BOOL *stop)
   {
     UIFont *font = value;
     UIFontDescriptor *descriptor = font.fontDescriptor;
     UIFontDescriptorSymbolicTraits
     traits = descriptor.symbolicTraits ^ UIFontDescriptorTraitItalic;
     UIFontDescriptor *
     toggledDescriptor = [descriptor fontDescriptorWithSymbolicTraits:traits];

     UIFont *italicFont = [UIFont fontWithDescriptor:toggledDescriptor
                                                size:0];
     [as addAttribute:NSFontAttributeName value:italicFont range:range];
   }];

  self.label.attributedText = as;
}

@end
