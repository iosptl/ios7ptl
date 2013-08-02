//
//  PTLViewController.m
//  BeBold
//
//  Created by Rob Napier on 7/31/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
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
