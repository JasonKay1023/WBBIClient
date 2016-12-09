//
//  OrderItemModel.h
//  WBBIClient
//
//  Created by 黃韜 on 7/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsModel.h"
#import "OrderModel.h"

@interface OrderItemModel : NSObject

@property (assign, nonatomic) NSInteger id;
@property (strong, nonatomic) GoodsModel *Goods;
@property (copy, nonatomic) NSNumber *Quantity;
@property (copy, nonatomic) NSNumber *Price;
@property (strong, nonatomic) OrderModel *Order;
@property (copy, nonatomic) NSString *Created;

@end
