//
//  ActionSheetHandler.h
//  WBBIClient
//
//  Created by 黃韜 on 10/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionSheetHandler : NSObject

- (void)ShowActionSheet:(UIViewController *)viewController
                  title:(NSString *)title
                message:(NSString *)message
           confirmTitle:(NSString *)confirmTitle
          confirmAction:(void (^)())confirmAction
            cancelTitle:(NSString *)cancelTitle
           cancelAction:(void (^)())cancelAction;

- (void)ShowActionSheet:(UIViewController *)viewController
                  title:(NSString *)title
                message:(NSString *)message
             firstTitle:(NSString *)firstTitle
            firstAction:(void (^)())firstAction
            secondTitle:(NSString *)secondTitle
           secondAction:(void (^)())secondAction
            cancelTitle:(NSString *)cancelTitle
           cancelAction:(void (^)())cancel;

@end
