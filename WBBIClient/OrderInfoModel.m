//
//  OrderInfoModel.m
//  WBBIClient
//
//  Created by 黃韜 on 23/2/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "OrderInfoModel.h"

@implementation OrderInfoModel

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"OrderItem": [OrderItemModel class],
             };
}

@end
