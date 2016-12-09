//
//  GoodsCardV.m
//  WBBIClient
//
//  Created by 黃韜 on 2016/1/18.
//  Copyright © 2016年 WBB. All rights reserved.
//

#import "GoodsCardV.h"

@implementation GoodsCardV

#pragma mark - LifeCycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    [super setup];
    
    //UITapGestureRecognizer *tapApproveImageViewGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightButtonAction)];
    // * Pass the touch to the next responder
    //tapApproveImageViewGesture.cancelsTouchesInView = NO;
    //[self.approveImageView addGestureRecognizer:tapApproveImageViewGesture];
    
    //UITapGestureRecognizer *tapRejectImageViewGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftButtonAction)];
    //tapRejectImageViewGesture.cancelsTouchesInView = NO;
    //[self.rejectImageView addGestureRecognizer:tapRejectImageViewGesture];
}

@end
