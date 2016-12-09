//
//  ActionSheetHandler.m
//  WBBIClient
//
//  Created by 黃韜 on 10/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "ActionSheetHandler.h"

typedef void (^first)();
typedef void (^second)();
typedef void (^cancel)();

@interface ActionSheetHandler () <UIActionSheetDelegate>
{
    int m_iCount;
#warning May cause block memory leak
    first m_pFirst;
    second m_pSecond;
    cancel m_pCancel;
}

@end

@implementation ActionSheetHandler

- (void)ShowActionSheet:(UIViewController *)viewController
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
        m_pFirst = confirmAction;
        m_pCancel = cancelAction;
        UIActionSheet *action_sheet = [[UIActionSheet alloc] initWithTitle:title
                                                                  delegate:self
                                                         cancelButtonTitle:cancelTitle
                                                    destructiveButtonTitle:confirmTitle
                                                         otherButtonTitles:nil];
        [action_sheet showInView:viewController.view];
    }
}

- (void)ShowActionSheet:(UIViewController *)viewController
                  title:(NSString *)title
                message:(NSString *)message
             firstTitle:(NSString *)firstTitle
            firstAction:(void (^)())firstAction
            secondTitle:(NSString *)secondTitle
           secondAction:(void (^)())secondAction
            cancelTitle:(NSString *)cancelTitle
           cancelAction:(void (^)())cancelAction
{
    m_iCount = 3;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIAlertController *alert_controller = [UIAlertController alertControllerWithTitle:title
                                                                                  message:message
                                                                           preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *first_action = [UIAlertAction actionWithTitle:firstTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            firstAction();
        }];
        UIAlertAction *second_action = [UIAlertAction actionWithTitle:secondTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            secondAction();
        }];
        UIAlertAction *cancel_action = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            cancelAction();
        }];
        [alert_controller addAction:first_action];
        [alert_controller addAction:second_action];
        [alert_controller addAction:cancel_action];
        [viewController presentViewController:alert_controller
                                     animated:YES
                                   completion:nil];
    } else {
        m_pFirst = firstAction;
        m_pSecond = secondAction;
        m_pCancel = cancelAction;
        UIActionSheet *action_sheet = [[UIActionSheet alloc] initWithTitle:title
                                                                  delegate:self
                                                         cancelButtonTitle:cancelTitle
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:firstTitle, secondTitle, nil];
        [action_sheet showInView:viewController.view];
    }
}

#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        m_pCancel();
        return;
    }
    if (m_iCount == 2) {
        switch (buttonIndex) {
            case 0:
                m_pFirst();
                break;
                
            default:
                break;
        }
    } else if (m_iCount == 3) {
        switch (buttonIndex) {
            case 0:
                m_pFirst();
                break;
            
            case 1:
                m_pSecond();
                
            default:
                break;
        }
    }
}

@end
