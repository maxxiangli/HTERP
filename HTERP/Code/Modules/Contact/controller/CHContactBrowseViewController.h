//
//  CHContactBrowseViewController.h
//  HTERP
//
//  Created by macbook on 12/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "CCustomViewController.h"
#import "CHCompanyCompent.h"
#import "CHDeparment.h"

@interface CHContactBrowseViewController : CCustomViewController

@property (nonatomic, strong) CHCompanyCompent *company;
@property (nonatomic, strong) CHDeparment *curDeparment;


@end
