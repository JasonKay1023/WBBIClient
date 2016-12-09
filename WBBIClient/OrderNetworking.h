//
//  OrderNetworking.h
//  WBBIClient
//
//  Created by 黃韜 on 11/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpResponseJson.h"
#import "CartModel.h"
#import "CartSellerItemModel.h"
#import "CartItemModel.h"
#import "OrderListModel.h"

typedef enum : NSUInteger {
    OrderStatusAll,
    OrderStatusWaitSellerSendGoods,
    OrderStatusWaitBuyerSignFor,
    OrderStatusBuyerSigned,
    OrderStatusTradeFinished
} OrderStatus;

@interface OrderNetworking : NSObject

- (void)CreateFromGoods:(NSNumber *)goods_id
                success:(void(^)(CartModel *response))success_response
                   fail:(void(^)(HttpResponseJson *response))failure_response;

- (void)CreateFromCart:(NSArray *)cart_items
               success:(void(^)(CartModel *response))success_response
                  fail:(void(^)(HttpResponseJson *response))failure_response;

- (void)GetOrderList:(OrderStatus)order_status
             success:(void(^)(OrderListModel *response))success_response
                fail:(void(^)(HttpResponseJson *response))failure_response;

@end
