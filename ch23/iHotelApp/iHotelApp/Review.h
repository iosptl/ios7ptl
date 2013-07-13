//
//  Review.h
//  
//
//  Created by Mugunth Kumar on 28/05/11.
//  Copyright 2011 Steinlogic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface Review : JSONModel

@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *reviewDate;
@property (nonatomic, strong) NSString *reviewerName;
@property (nonatomic, strong) NSString *reviewId;
@property (nonatomic, strong) NSString *reviewText;

@end
