//
//  CHSearchContactViewController.h
//  HTERP
//
//  Created by macbook on 13/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CCustomViewController.h"

@class CHSearchContactViewController;

@protocol CHSearchContactViewControllerDelegate <NSObject>

- (void)searchController:(CHSearchContactViewController *)searchController didSelectedUsers:(NSArray *)users;

@end

@interface CHSearchContactViewController : CCustomViewController

@property (nonatomic, weak)id <CHSearchContactViewControllerDelegate> delegate;

- (void)resignSearchBarFirstResponder;

@end
