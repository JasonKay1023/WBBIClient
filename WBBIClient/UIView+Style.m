//
//  UIView+Style.m
//  WBBIClient
//
//  Created by 黃韜 on 9/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "UIView+Style.h"

@implementation UIView (Style)

- (void)SetCornerRadius:(float)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
}

@end
