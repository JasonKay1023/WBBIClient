//
//  CartItemModel.m
//  WBBIClient
//
//  Created by 黃韜 on 7/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "CartItemModel.h"

@implementation CartItemModel

- (BOOL)isEqual:(id)object
{
    if (self.id == ((CartItemModel *)object).id) {
        return YES;
    }
    return NO;
}

@end
