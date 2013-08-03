//
//  KVCTableViewCell.m
//

#import "KVCTableViewCell.h"

@implementation KVCTableViewCell

- (BOOL)isReady {
  // Only display something if configured
  return (self.object && [self.property length] > 0);
}

- (void)update {
  NSString *text;
  if (self.isReady) {
    // Ask the target for the value of its property that has the
    // name given in self.property. Then convert that into a human
    // readable string
    id value = [self.object valueForKeyPath:self.property];
    text = [value description];
  }
  else {
    text = @"";
  }
  self.textLabel.text = text;
}

- (id)initWithReuseIdentifier:(NSString *)identifier {
  return [self initWithStyle:UITableViewCellStyleDefault
             reuseIdentifier:identifier];
}

- (void)setObject:(id)anObject {
  _object = anObject;
  [self update];
}

- (void)setProperty:(NSString *)aProperty {
  _property = aProperty;
  [self update];
}
@end