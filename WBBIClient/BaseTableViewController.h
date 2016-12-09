//
//  BaseTableViewController.h
//  WBBIClient
//
//  Created by 黃韜 on 13/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UITableViewController

#pragma mark - Edit mode

@property (nonatomic, assign) BOOL IsEditMode;

- (void)HideKeyboard;

@end
