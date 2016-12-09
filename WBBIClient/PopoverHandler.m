//
//  PopoverHandler.m
//  WBBIClient
//
//  Created by 黃韜 on 11/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "PopoverHandler.h"

@interface PopoverHandler () <WYPopoverControllerDelegate>
{
    WYPopoverController *popoverController;
}

@end

#pragma mark - Public interface

@implementation PopoverHandler

- (void)Show:(UIViewController *)viewController
    fromRect:(CGRect)rect
      inView:(UIView *)view
andDirection:(WYPopoverArrowDirection)direction
    animated:(BOOL)animated
     options:(WYPopoverAnimationOptions)option
  completion:(void(^)(void))completion
{
    popoverController = [[WYPopoverController alloc] initWithContentViewController:viewController];
    popoverController.delegate = self;
    [popoverController presentPopoverFromRect:rect
                                       inView:view
                     permittedArrowDirections:direction
                                     animated:animated
                                      options:option
                                   completion:completion];
}

#pragma mark - Internal methods

- (void)hide
{
    [popoverController dismissPopoverAnimated:YES completion:^{
        [self popoverControllerDidDismissPopover:popoverController];
    }];
}

#pragma mark - WYPopoverController delegate

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    if (_Delegate) {
        [_Delegate TerminateHandler:self];
    }
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    popoverController.delegate = nil;
    popoverController = nil;
}

@end
