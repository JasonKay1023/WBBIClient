//
//  UserAddressListVC.h
//  WBBIClient
//
//  Created by 黃韜 on 4/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UserAddressModel.h"

@protocol UserAddressDelegate <NSObject>

- (void)Address:(UserAddressModel *)address;

@end

@interface UserAddressListVC : BaseTableViewController

@property (weak, nonatomic) id<UserAddressDelegate> Delegate;

@end
