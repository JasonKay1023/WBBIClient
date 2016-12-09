//
//  GoodsBottomV.m
//  WBBIClient
//
//  Created by 黃韜 on 14/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "GoodsBottomV.h"

@implementation GoodsBottomV

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)IsFavour:(BOOL)yes
{
    if (yes) {
        _FavourB.tintColor = [UIColor redColor];
    } else {
        _FavourB.tintColor = [UIColor greenColor];
    }
}

@end
