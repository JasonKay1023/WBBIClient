//
//  UIViewController+ProgressHUD.m
//  WBBIClient
//
//  Created by 黃韜 on 24/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "UIViewController+ProgressHUD.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

#define ProgressHUDKey @"MBProgressHUDKey"

@implementation UIViewController (ProgressHUD)

- (void)ShowProgressHUD:(ProgressHUDDurationType)duration
                message:(NSString *)message
                   mode:(ProgressHUDModeType)mode
  userInteractionEnable:(BOOL)enable;
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window) {
        MBProgressHUD *progress_hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
        progress_hud.labelText = message;
        MBProgressHUDMode tmp_mode;
        switch (mode) {
            case ProgressHUDModeTypeIndeterminate:
                tmp_mode = MBProgressHUDModeIndeterminate;
                break;
            
            case ProgressHUDModeTypeDeterminate:
                tmp_mode = MBProgressHUDModeDeterminate;
                break;
            
            case ProgressHUDModeTypeDeterminateHorizontalBar:
                tmp_mode = MBProgressHUDModeDeterminateHorizontalBar;
                break;
            
            case ProgressHUDModeTypeAnnularDeterminate:
                tmp_mode = MBProgressHUDModeDeterminate;
                break;
            
            case ProgressHUDModeTypeCustomView:
                tmp_mode = MBProgressHUDModeCustomView;
                break;
            
            case ProgressHUDModeTypeText:
                tmp_mode = MBProgressHUDModeText;
                break;
        }
        progress_hud.mode = tmp_mode;
        window.userInteractionEnabled = enable;
        switch (duration) {
            case ProgressHUDDurationTypeStay:
                [progress_hud show:YES];
                objc_setAssociatedObject(window, ProgressHUDKey, progress_hud, OBJC_ASSOCIATION_RETAIN);
                break;
            
            case ProgressHUDDurationTypeSoon1s:
                [self show_progress_hud:progress_hud timer:1.0];
                break;
            
            case ProgressHUDDurationTypeSoon1_5s:
                [self show_progress_hud:progress_hud timer:1.5];
                break;
            
            case ProgressHUDDurationTypeSoon2s:
                [self show_progress_hud:progress_hud timer:2.0];
                break;
            
            case ProgressHUDDurationTypeSoon3s:
                [self show_progress_hud:progress_hud timer:3.0];
                break;
            
            case ProgressHUDDurationTypeSoon5s:
                [self show_progress_hud:progress_hud timer:5.0];
                break;
            
            default:
                break;
        }
    }
}

- (void)HideProgressHUD
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window) {
        MBProgressHUD *progress_hud = objc_getAssociatedObject(window, ProgressHUDKey);
        if (progress_hud) {
            [progress_hud hide:YES];
            [progress_hud removeFromSuperview];
            objc_removeAssociatedObjects(progress_hud);
            window.userInteractionEnabled = YES;
        }
    }
}

- (void)show_progress_hud:(MBProgressHUD *)progress_hud timer:(NSTimeInterval)timer
{
    [progress_hud showAnimated:YES whileExecutingBlock:^{
        
        [NSThread sleepForTimeInterval:timer];
        
    } completionBlock:^{
        
        [progress_hud removeFromSuperview];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (window) {
            window.userInteractionEnabled = YES;
        }
        
    }];
}

@end
