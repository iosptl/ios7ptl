//
//  main.m
//  Money
//

#import <Foundation/Foundation.h>
#import "RNMoney.h"

int main (int argc, const char * argv[])
{
  @autoreleasepool {
    NSLocale *russiaLocale = [[NSLocale alloc] 
                              initWithLocaleIdentifier:@"ru_RU"];
    
    RNMoney *money = [[RNMoney alloc]
                      initWithIntegerAmount:100];
    NSLog(@"Local display of local currency: %@", money);
    NSLog(@"Russian display of local currency: %@", 
          [money localizedStringForLocale:russiaLocale]);
    
    
    RNMoney *euro = [[RNMoney alloc] initWithIntegerAmount:200
                                              currencyCode:@"EUR"];
    NSLog(@"Local display of Euro: %@", euro);
    NSLog(@"Russian display of Euro: %@", 
          [euro localizedStringForLocale:russiaLocale]);    
  }
  return 0;
}

