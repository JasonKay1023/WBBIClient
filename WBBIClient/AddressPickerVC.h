//
//  AddressPickerVC.h
//  WBBIClient
//
//  Created by 林穎怡 on 2016/1/6.
//  Copyright © 2016年 WBB. All rights reserved.
//

#import "BaseTableViewController.h"

@protocol AddressPickerDelegate <NSObject>

- (void)ReturnResult:(NSString *)ZipCode withShortcut:(NSString *)shortcut;

@end

@interface AddressPickerVC : BaseTableViewController

@property (weak, nonatomic) id<AddressPickerDelegate> Delegate;

- (void)SetData:(NSArray *)list
        andType:(NSString *)type
   withShortcut:(NSString *)shortcut;

@end
