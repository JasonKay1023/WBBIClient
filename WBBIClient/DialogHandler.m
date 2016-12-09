//
//  DialogHandler.m
//  WBBIClient
//
//  Created by 黃韜 on 12/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "DialogHandler.h"
#import <CustomIOSAlertView/CustomIOSAlertView.h>

typedef void (^action)();

@interface DialogHandler () <CustomIOSAlertViewDelegate>
{
    CustomIOSAlertView *m_pDialog;
#warning May cause block memory leak
    action cancel;
    action first;
    action second;
}

@end

@implementation DialogHandler

- (void)Dialog:(UIViewController *)viewController
          view:(UIView *)view
   cancelTitle:(NSString *)cancelTitle
  cancelAction:(void(^)(void))cancelAction
    firstTitle:(NSString *)firstTitle
   firstAction:(void (^)(void))firstAction
   secondTitle:(NSString *)secondTitle
  secondAction:(void (^)(void))secondAction
{
    cancel = cancelAction;
    first = firstAction;
    second = secondAction;
    
    m_pDialog = [[CustomIOSAlertView alloc] init];
    [m_pDialog setButtonTitles:@[cancelTitle, firstTitle, secondTitle]];
    [m_pDialog setDelegate:self];
    [m_pDialog setContainerView:view];
    [m_pDialog show];
}

#pragma mark - Internal methods

- (void)hide
{
    [m_pDialog close];
    m_pDialog = nil;
}

#pragma mark - Custom iOS alert view delegate

- (void)customIOS7dialogButtonTouchUpInside:(id)alertView
                       clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self hide];
    
    switch (buttonIndex) {
        case 0:
            if (cancel != nil) {
                cancel();
            }
            break;
        
        case 1:
            if (first != nil) {
                first();
            }
            break;
        
        case 2:
            if (second != nil) {
                second();
            }
            break;
        
        default:
            break;
    }
}

@end
