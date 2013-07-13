//
//  MadelCell.h
//  Mandel
//
//  Created by Rob Napier on 8/6/12.
//

#import <UIKit/UIKit.h>

@interface JuliaCell : UICollectionViewCell
- (void)configureWithSeed:(NSUInteger)seed
                    queue:(NSOperationQueue *)queue
                   scales:(NSArray *)scales;

@end
