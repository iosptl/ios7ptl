//
//  DragLayout.h
//  CollectionDrag
//
//  Created by Rob Napier on 9/20/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragLayout : UICollectionViewFlowLayout
- (void)startDraggingIndexPath:(NSIndexPath *)indexPath
                     fromPoint:(CGPoint)p;
- (void)updateDragLocation:(CGPoint)point;
- (void)stopDragging;
@end
