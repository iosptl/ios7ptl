#import "RNMoney.h"

@implementation RNMoney
static NSString * const kRNMoneyAmountKey = @"amount";
static NSString * const kRNMoneyCurrencyCodeKey =
                                           @"currencyCode";

- (RNMoney *)initWithAmount:(NSDecimalNumber *)anAmount 
               currencyCode:(NSString *)aCode {
  if ((self = [super init])) {
    _amount = anAmount;
    if (aCode == nil) {
      NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
      _currencyCode = [formatter currencyCode];
    }
    else {
      _currencyCode = aCode;
    }
  }
  return self;
}

- (RNMoney *)initWithAmount:(NSDecimalNumber *)anAmount {
  return [self initWithAmount:anAmount
                 currencyCode:nil];
}

- (RNMoney *)initWithIntegerAmount:(NSInteger)anAmount
                      currencyCode:(NSString *)aCode {
    return [self initWithAmount:
            [NSDecimalNumber decimalNumberWithDecimal:
             [@(anAmount) decimalValue]]
                   currencyCode:aCode];
}

- (RNMoney *)initWithIntegerAmount:(NSInteger)anAmount {
  return [self initWithIntegerAmount:anAmount
                        currencyCode:nil];
}

- (id)init {
  return [self initWithAmount:[NSDecimalNumber zero]];
}

- (id)initWithCoder:(NSCoder *)coder {
  
  NSDecimalNumber *amount = [coder decodeObjectForKey:
                             kRNMoneyAmountKey];
  NSString *currencyCode = [coder decodeObjectForKey:
                            kRNMoneyCurrencyCodeKey];
  return [self initWithAmount:amount
                 currencyCode:currencyCode];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:_amount forKey:kRNMoneyAmountKey];
  [aCoder encodeObject:_currencyCode
                forKey:kRNMoneyCurrencyCodeKey];
}

- (NSString *)localizedStringForLocale:(NSLocale *)aLocale 
{
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] 
                                  init];
  [formatter setLocale:aLocale];
  [formatter setCurrencyCode:self.currencyCode];
  [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
  return [formatter stringFromNumber:self.amount];
}

- (NSString *)localizedString {
  return [self localizedStringForLocale:
          [NSLocale currentLocale]];
}

- (NSString *)description {
  return [self localizedString];
}

@end
