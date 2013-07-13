//
//  CollectionViewController.m
//  Mandel
//
//  Created by Rob Napier on 8/6/12.
//

#import "CollectionViewController.h"
#import "JuliaCell.h"
#include <sys/sysctl.h>

@interface CollectionViewController ()
@property (nonatomic, readwrite, strong) NSOperationQueue *queue;
@property (nonatomic, readwrite, strong) NSArray *scales;
@end

@implementation CollectionViewController

unsigned int countOfCores() {
  unsigned int ncpu;
  size_t len = sizeof(ncpu);
  sysctlbyname("hw.ncpu", &ncpu, &len, NULL, 0);
  
  return ncpu;
}

- (void)useAllScales {
  CGFloat maxScale = [[UIScreen mainScreen] scale];
  NSUInteger kIterations = 6;
  CGFloat minScale = maxScale/pow(2, kIterations);
  
  NSMutableArray *scales = [NSMutableArray new];
  for (CGFloat scale = minScale; scale <= maxScale; scale *= 2) {
    [scales addObject:@(scale)];
  }
  self.scales = scales;
}

- (void)useMinimumScales {
  self.scales = [self.scales subarrayWithRange:NSMakeRange(0, 1)];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.queue = [[NSOperationQueue alloc] init];
  [self useAllScales];

  self.queue.maxConcurrentOperationCount = countOfCores();
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return 1000;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  JuliaCell *
  cell = [self.collectionView
          dequeueReusableCellWithReuseIdentifier:@"Julia"
          forIndexPath:indexPath];
  [cell configureWithSeed:indexPath.row queue:self.queue scales:self.scales];
  return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  [self.queue cancelAllOperations];
  [self useMinimumScales];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
  [self useAllScales];
}

@end
