//
//  AlertHandler.h
//  WBBIClient
//
//  Created by 黃韜 on 10/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertHandler : NSObject

- (void)ShowAlert:(UIViewController *)viewController
            title:(NSString *)title
          message:(NSString *)message
     dismissTitle:(NSString *)dismissTitle
    dismissAction:(void (^)())dismissAction;

- (void)ShowAlert:(UIViewController *)viewController
            title:(NSString *)title
          message:(NSString *)message
     confirmTitle:(NSString *)confirmTitle
    confirmAction:(void (^)())confirmAction
      cancelTitle:(NSString *)cancelTitle
     cancelAction:(void (^)())cancelAction;

@end
