//
//  MBHShapeBinLayout.h
//  MrBlockhead
//
//  Created by Rob Napier on 9/3/13.
//  Copyright (c) 2013 Rob Napier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBHShapeBinLayout : UICollectionViewFlowLayout

- (void)startDraggingIndexPath:(NSIndexPath *)indexPath fromPoint:(CGPoint)p;
- (void)updateDragLocation:(CGPoint)p;
- (void)clearDraggedIndexPath;
@end
