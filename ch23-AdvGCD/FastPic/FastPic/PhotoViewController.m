// Based on PhotoScroller

#import "PhotoViewController.h"
#import "ImageScrollView.h"

@implementation PhotoViewController

- (void)loadView {
  ImageScrollView *scrollView = [[ImageScrollView alloc] init];
  scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.view = scrollView;
}

- (void)setImagePath:(NSString *)path size:(CGSize)size {
  [(ImageScrollView *)self.view setImagePath:path size:size];
}


@end
