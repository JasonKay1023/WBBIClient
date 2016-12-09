//
//  CartSellerItemModel.h
//  WBBIClient
//
//  Created by 黃韜 on 2016/1/8.
//  Copyright © 2016年 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface CartSellerItemModel : NSObject

@property (strong, nonatomic) UserModel *Seller;
@property (strong, nonatomic) NSMutableArray *CartItems;
@property (copy, nonatomic) NSNumber *Discount;
@property (copy, nonatomic) NSNumber *Subtotal;

@end
