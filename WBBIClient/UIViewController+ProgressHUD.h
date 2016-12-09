//
//  UIViewController+ProgressHUD.h
//  WBBIClient
//
//  Created by 黃韜 on 24/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _ProgressHUDDurationType {
    ProgressHUDDurationTypeStay = 0,
    ProgressHUDDurationTypeSoon1s,
    ProgressHUDDurationTypeSoon1_5s,
    ProgressHUDDurationTypeSoon2s,
    ProgressHUDDurationTypeSoon3s,
    ProgressHUDDurationTypeSoon5s
} ProgressHUDDurationType;

typedef enum _ProgressHUDModeType {
    ProgressHUDModeTypeIndeterminate,
    ProgressHUDModeTypeDeterminate,
    ProgressHUDModeTypeDeterminateHorizontalBar,
    ProgressHUDModeTypeAnnularDeterminate,
    ProgressHUDModeTypeCustomView,
    ProgressHUDModeTypeText,
} ProgressHUDModeType;

@interface UIViewController (ProgressHUD)

- (void)ShowProgressHUD:(ProgressHUDDurationType)duration
                message:(NSString *)message
                   mode:(ProgressHUDModeType)mode
  userInteractionEnable:(BOOL)enable;

- (void)HideProgressHUD;

@end
