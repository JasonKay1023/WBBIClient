//
//  AlertHandler.m
//  WBBIClient
//
//  Created by 黃韜 on 10/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "AlertHandler.h"

typedef void (^confirm)();
typedef void (^cancel)();

@interface AlertHandler () <UIAlertViewDelegate>
{
    int m_iCount;
#warning May cause block memory leak
    confirm m_pConfirm;
    cancel m_pCancel;
}

@end

@implementation AlertHandler

- (void)ShowAlert:(UIViewController *)viewController
            title:(NSString *)title
          message:(NSString *)message
     dismissTitle:(NSString *)dismissTitle
    dismissAction:(void (^)())dismissAction
{
    m_iCount = 1;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIAlertController *alert_controller = [UIAlertController alertControllerWithTitle:title
                                                                                  message:message
                                                                           preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *dismiss_action = [UIAlertAction actionWithTitle:dismissTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dismissAction();
        }];
        [alert_controller addAction:dismiss_action];
        [viewController presentViewController:alert_controller
                                     animated:YES
                                   completion:nil];
    } else {
        m_pCancel = dismissAction;
        UIAlertView *alert_view = [[UIAlertView alloc] initWithTitle:title
                                                             message:message
                                                            delegate:self
                                                   cancelButtonTitle:dismissTitle
                                                   otherButtonTitles:nil];
        [alert_view show];
    }
}

- (void)ShowAlert:(UIViewController *)viewController
            title:(NSString *)title
          message:(NSString *)message
     confirmTitle:(NSString *)confirmTitle
    confirmAction:(void (^)())confirmAction
      cancelTitle:(NSString *)cancelTitle
     cancelAction:(void (^)())cancelAction
{
    m_iCount = 2;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIAlertController *alert_controller = [UIAlertController alertControllerWithTitle:title
                                                                                  message:message
                                                                           preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *confirm_action = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            confirmAction();
        }];
        UIAlertAction *cancel_action = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            cancelAction();
        }];
        [alert_controller addAction:confirm_action];
        [alert_controller addAction:cancel_action];
        [viewController presentViewController:alert_controller
                                     animated:YES
                                   completion:nil];
    } else {
        m_pConfirm = confirmAction;
        m_pCancel = cancelAction;
        UIAlertView *alert_view = [[UIAlertView alloc] initWithTitle:title
                                                             message:message
                                                            delegate:self
                                                   cancelButtonTitle:cancelTitle
                                                   otherButtonTitles:confirmTitle, nil];
        [alert_view show];
    }
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (m_iCount == 1) {
        m_pCancel();
    } else if (m_iCount == 2) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            m_pCancel();
        } else {
            m_pConfirm();
        }
    }
}

@end
