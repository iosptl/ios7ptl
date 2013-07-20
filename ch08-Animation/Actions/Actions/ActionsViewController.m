//
//  ActionsViewController.m
//  Actions
//

#import "ActionsViewController.h"
#import "CircleLayer.h"

@implementation ActionsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  CircleLayer *circleLayer = [CircleLayer new];
  circleLayer.radius = 20;
  circleLayer.frame = self.view.bounds;
  [self.view.layer addSublayer:circleLayer];
  
  CABasicAnimation *anim = [CABasicAnimation
                            animationWithKeyPath:@"position"];
  anim.duration = 2;
  NSMutableDictionary *actions = [NSMutableDictionary
                                  dictionaryWithDictionary:
                                  [circleLayer actions]];
  actions[@"position"] = anim;
  
  CABasicAnimation *fadeAnim = [CABasicAnimation 
                                animationWithKeyPath:@"opacity"];
  fadeAnim.fromValue = @0.4;
  fadeAnim.toValue = @1.0;

  CABasicAnimation *growAnim = [CABasicAnimation
                                animationWithKeyPath:
                                @"transform.scale"];
  growAnim.fromValue = @0.8;
  growAnim.toValue = @1.0;
  
  CAAnimationGroup *groupAnim = [CAAnimationGroup animation];
  groupAnim.animations = @[fadeAnim, growAnim];
  
  actions[kCAOnOrderIn] = groupAnim;
  
  circleLayer.actions = actions;

  UIGestureRecognizer *g = [[UITapGestureRecognizer alloc] 
                            initWithTarget:self
                            action:@selector(tap:)];
  [self.view addGestureRecognizer:g];
}

- (void)tap:(UIGestureRecognizer *)recognizer {
  CircleLayer *circleLayer = 
      (CircleLayer*)(self.view.layer.sublayers)[0];
  circleLayer.position = CGPointMake(100, 100);
  [CATransaction setAnimationDuration:2];
  circleLayer.radius = 100.0;
}

@end
