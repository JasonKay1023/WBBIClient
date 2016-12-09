//
//  CartSellerItemModel.m
//  WBBIClient
//
//  Created by 黃韜 on 2016/1/8.
//  Copyright © 2016年 WBB. All rights reserved.
//

#import "CartSellerItemModel.h"

@implementation CartSellerItemModel

- (BOOL)isEqual:(id)object
{
    if ([self.Seller isEqual:((CartSellerItemModel *)object).Seller]) {
        return YES;
    }
    return NO;
}

@end
