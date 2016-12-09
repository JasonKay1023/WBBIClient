//
//  OrderInfoModel.h
//  WBBIClient
//
//  Created by 黃韜 on 23/2/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderStatusModel.h"
#import "OrderModel.h"
#import "OrderItemModel.h"

@interface OrderInfoModel : NSObject

@property (nonatomic, strong) OrderStatusModel *Status;
@property (nonatomic, strong) NSArray<OrderItemModel *> *OrderItem;
@property (nonatomic, strong) OrderModel *Order;

@end
