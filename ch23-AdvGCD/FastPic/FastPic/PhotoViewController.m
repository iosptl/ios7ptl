// Based on PhotoScroller

#import "PhotoViewController.h"
#import "ImageScrollView.h"

@interface PhotoViewController ()
@property (nonatomic) UIProgressView *progressView;
@end

@implementation PhotoViewController

- (void)loadView {
  ImageScrollView *scrollView = [[ImageScrollView alloc] init];
  scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.view = scrollView;

  self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
  self.progressView.center = self.view.center;
  [self.view addSubview:self.progressView];
}

- (void)setImagePath:(NSString *)path size:(CGSize)size {
  [(ImageScrollView *)self.view setImagePath:path size:size];
}

- (void)setProgress:(NSProgress *)progress {
  if (_progress) {
    [_progress removeObserver:self forKeyPath:@"completedUnitCount"];
  }

  _progress = progress;

  if (_progress) {
    [_progress addObserver:self forKeyPath:@"completedUnitCount" options:0 context:(__bridge void*)self];
  }
}

- (void)dealloc {
  [_progress removeObserver:self forKeyPath:@"completedUnitCount"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (context == (__bridge void*)self) {
    NSProgress *progress = self.progress;
    if (progress.completedUnitCount >= progress.totalUnitCount) {
      [self.progressView removeFromSuperview];
    }
    else {
      self.progressView.progress = progress.fractionCompleted;
    }
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

@end
