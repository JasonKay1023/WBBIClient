//
//  GoodsIndexItemV.m
//  WBBIClient
//
//  Created by 黃韜 on 2016/1/10.
//  Copyright © 2016年 WBB. All rights reserved.
//

#import "GoodsIndexItemV.h"

@implementation GoodsIndexItemV

@synthesize AvatarIV = m_imageview_avatar;
@synthesize BrandL = m_label_brand;
@synthesize TitleL = m_label_title;
@synthesize PriceL = m_label_price;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
 }
 */

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.frame = CGRectMake(0, 0, 315, 400);
    }
    return self;
 }

@end
