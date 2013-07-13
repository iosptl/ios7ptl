//
//  MenuItem.m
//  iHotelApp
//
//  Created by Mugunth on 25/05/11.
//  Copyright 2011 Steinlogic. All rights reserved.
//

#import "MenuItem.h"
#import "Review.h"

@implementation MenuItem

- (id)init
{
  self = [super init];
  if (self) {
    // Initialization code here.
    self.reviews = [NSMutableArray array];
  }
  
  return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
        self.itemId = value;
    else if([key isEqualToString:@"description"])
        self.itemDescription = value;
    else [super setValue:value forUndefinedKey:key];
}


-(void) setValue:(id)value forKey:(NSString *)key
{
  if([key isEqualToString:@"reviews"])
  {
    for(NSMutableDictionary *reviewArrayDict in value)
    {
      Review *thisReview = [[Review alloc] initWithDictionary:reviewArrayDict];
      [self.reviews addObject:thisReview];
    }
  }  
  else
    [super setValue:value forKey:key];
}

-(NSString*) description {
  
  return [NSString stringWithFormat:@"%@ - %@", self.name, self.itemDescription];
}


//=========================================================== 
//  Keyed Archiving
//
//=========================================================== 
- (void)encodeWithCoder:(NSCoder *)encoder 
{
  [encoder encodeObject:self.itemId forKey:@"itemId"];
  [encoder encodeObject:self.image forKey:@"image"];
  [encoder encodeObject:self.name forKey:@"name"];
  [encoder encodeObject:self.spicyLevel forKey:@"spicyLevel"];
  [encoder encodeObject:self.rating forKey:@"rating"];
  [encoder encodeObject:self.itemDescription forKey:@"itemDescription"];
  [encoder encodeObject:self.waitingTime forKey:@"waitingTime"];
  [encoder encodeObject:self.reviewCount forKey:@"reviewCount"];
  [encoder encodeObject:self.reviews forKey:@"reviews"];
}

- (id)initWithCoder:(NSCoder *)decoder 
{
  self = [super init];
  if (self) {
    self.itemId = [decoder decodeObjectForKey:@"itemId"];
    self.image = [decoder decodeObjectForKey:@"image"];
    self.name = [decoder decodeObjectForKey:@"name"];
    self.spicyLevel = [decoder decodeObjectForKey:@"spicyLevel"];
    self.rating = [decoder decodeObjectForKey:@"rating"];
    self.itemDescription = [decoder decodeObjectForKey:@"itemDescription"];
    self.waitingTime = [decoder decodeObjectForKey:@"waitingTime"];
    self.reviewCount = [decoder decodeObjectForKey:@"reviewCount"];
    self.reviews = [decoder decodeObjectForKey:@"reviews"];
  }
  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
  
  [theCopy setItemId:[self.itemId copy]];
  [theCopy setImage:[self.image copy]];
  [theCopy setName:[self.name copy]];
  [theCopy setSpicyLevel:[self.spicyLevel copy]];
  [theCopy setRating:[self.rating copy]];
  [theCopy setItemDescription:[self.itemDescription copy]];
  [theCopy setWaitingTime:[self.waitingTime copy]];
  [theCopy setReviewCount:[self.reviewCount copy]];
  [theCopy setReviews:[self.reviews copy]];
  
  return theCopy;
}
@end
