//
//  BaseViewController.h
//  WBBIClient
//
//  Created by 黃韜 on 9/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

#pragma mark - Edit mode

@property (nonatomic, assign) BOOL IsEditMode;

- (void)HideKeyboard;

@end
