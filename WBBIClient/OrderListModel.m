//
//  OrderListModel.m
//  WBBIClient
//
//  Created by 黃韜 on 16/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "OrderListModel.h"

@implementation OrderListModel

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"Orders": [OrderInfoModel class],
             };
}

@end
