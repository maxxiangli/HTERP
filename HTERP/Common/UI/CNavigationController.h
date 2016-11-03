//
//  CNewNavigationController.h
//  QQStock
//
//  Created by kenna on 8/15/13.
//  Copyright (c) 2013 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CNavigationBar : UINavigationBar
- (UIImage *) imageWithColor:(UIColor *) color;
- (void) updateNavigationWithColor:(UIColor *) color;
- (void) updateNavigationWithDefaultColor;
- (void) tranparentNavigationBar;
@end

@interface CNavigationController : UINavigationController
@property(nonatomic, assign) BOOL allowDragBack;
- (void) updateNavigationBarTranparent;
@end
