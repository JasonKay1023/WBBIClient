//
//  PopoverHandler.h
//  WBBIClient
//
//  Created by 黃韜 on 11/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WYPopoverController/WYPopoverController.h>

@class PopoverHandler;

@protocol PopoverHandlerTerminateDelegate <NSObject>

- (void)TerminateHandler:(PopoverHandler *)handler;

@end

@interface PopoverHandler : NSObject

@property (nonatomic, weak) id<PopoverHandlerTerminateDelegate> Delegate;

- (void)Show:(UIViewController *)viewController
    fromRect:(CGRect)rect
      inView:(UIView *)view
andDirection:(WYPopoverArrowDirection)direction
    animated:(BOOL)animated
     options:(WYPopoverAnimationOptions)option
  completion:(void(^)(void))completion;

@end
