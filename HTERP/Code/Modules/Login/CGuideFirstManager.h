//
//  CGuideFirstManager.h
//  HTERP
//
//  Created by li xiang on 16/11/17.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGuideFirstManager : NSObject

- (BOOL)canShowFistView;

//已经显示了引导页
- (void)showedFirstView;
+ (CGuideFirstManager *)getInstance;
@end
