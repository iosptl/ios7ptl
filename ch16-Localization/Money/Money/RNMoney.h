#import <Foundation/Foundation.h>

@interface RNMoney : NSObject <NSCoding>
@property (nonatomic, readonly, strong)
                                   NSDecimalNumber *amount;
@property (nonatomic, readonly, strong)
                                    NSString *currencyCode;

- (RNMoney *)initWithAmount:(NSDecimalNumber *)anAmount 
         currencyCode:(NSString *)aCode;
- (RNMoney *)initWithAmount:(NSDecimalNumber *)anAmount;

- (RNMoney *)initWithIntegerAmount:(NSInteger)anAmount
                      currencyCode:(NSString *)aCode;
- (RNMoney *)initWithIntegerAmount:(NSInteger)anAmount;

- (NSString *)localizedStringForLocale:(NSLocale *)aLocale;
- (NSString *)localizedString;

@end
