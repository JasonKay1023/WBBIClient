//
//  UserIndexVC.h
//  WBBIClient
//
//  Created by 黃韜 on 18/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "BaseTableViewController.h"
#import "FlipContainerView.h"

@interface UserIndexVC : BaseTableViewController

@property (nonatomic, weak) id<FlipContainerDelegate> delegate;

@end
