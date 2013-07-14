//
//  JuliaCell.m
//  Julia
//
//  Created by Rob Napier on 8/6/12.
//

#import "JuliaCell.h"
#import "JuliaOperation.h"

@interface JuliaCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, readwrite, strong) NSMutableArray *operations;
@end

@implementation JuliaCell

- (void)prepareForReuse {
  [self.operations makeObjectsPerformSelector:@selector(cancel)];
  [self.operations removeAllObjects];
  self.imageView.image = nil;
  self.label.text = @"";
}

- (void)awakeFromNib {
  self.operations = [NSMutableArray new];
}

- (JuliaOperation *)operationForScale:(CGFloat)scale
                                 seed:(NSUInteger)seed {
  JuliaOperation *op = [[JuliaOperation alloc] init];
  op.contentScaleFactor = scale;
  
  CGRect bounds = self.bounds;
  op.width = (unsigned)(CGRectGetWidth(bounds) * scale);
  op.height = (unsigned)(CGRectGetHeight(bounds) * scale);
  
  srandom(seed);
  
  op.c = (long double)random()/LONG_MAX + I*(long double)random()/LONG_MAX;  
  op.blowup = random();
  op.rScale = random() % 20;  // Biased, but simple is more important
  op.gScale = random() % 20;
  op.bScale = random() % 20;
    
  __weak JuliaOperation *weakOp = op;
  op.completionBlock = ^{
    if (! weakOp.isCancelled) {
      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        JuliaOperation *strongOp = weakOp;
        if (strongOp && [self.operations containsObject:strongOp]) {
          self.imageView.image = strongOp.image;
          self.label.text = strongOp.description;
          [self.operations removeObject:strongOp];
        }
      }];
    }
  };
  
  if (scale < 0.5) {
    op.queuePriority = NSOperationQueuePriorityVeryHigh;
  }
  else if (scale <= 1) {
    op.queuePriority = NSOperationQueuePriorityHigh;
  }
  else {
    op.queuePriority = NSOperationQueuePriorityNormal;
  }
  
  return op;
}

- (void)configureWithSeed:(NSUInteger)seed
                    queue:(NSOperationQueue *)queue
                   scales:(NSArray *)scales {
  CGFloat maxScale = [[UIScreen mainScreen] scale];
  self.contentScaleFactor = maxScale;

  NSUInteger kIterations = 6;
  CGFloat minScale = maxScale/pow(2, kIterations);

  JuliaOperation *prevOp = nil;
  for (CGFloat scale = minScale; scale <= maxScale; scale *= 2) {
    JuliaOperation *op = [self operationForScale:scale seed:seed];
    if (prevOp) {
      [op addDependency:prevOp];
    }
    [self.operations addObject:op];
    [queue addOperation:op];
    prevOp = op;
  }
}

@end
