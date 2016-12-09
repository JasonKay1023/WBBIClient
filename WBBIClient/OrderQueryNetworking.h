//
//  OrderQueryNetworking.h
//  WBBIClient
//
//  Created by 黃韜 on 16/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpResponseJson.h"
#import "OrderListModel.h"

typedef enum : NSUInteger {
    OrderQueryTypeAll,
    OrderQueryTypeWaitSellerSendGoods,
    OrderQueryTypeWaitBuyerSignFor,
    OrderQueryTypeBuyerSigned,
    OrderQueryTypeSellerTradeFinished,
} OrderQueryType;

@interface OrderQueryNetworking : NSObject

- (void)Get:(OrderQueryType)type
    success:(void(^)(OrderListModel *response))success_response
       fail:(void(^)(HttpResponseJson *response))failure_response;

@end
