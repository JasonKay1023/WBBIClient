//
//  DialogHandler.h
//  WBBIClient
//
//  Created by 黃韜 on 12/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DialogHandler : NSObject

- (void)Dialog:(UIViewController *)viewController
          view:(UIView *)view
   cancelTitle:(NSString *)cancelTitle
  cancelAction:(void(^)(void))cancelAction
    firstTitle:(NSString *)firstTitle
   firstAction:(void(^)(void))firstAction
   secondTitle:(NSString *)secondTitle
  secondAction:(void(^)(void))secondAction;

@end
