//
//  OrderNetworking.m
//  WBBIClient
//
//  Created by 黃韜 on 11/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "OrderNetworking.h"
#import <MJExtension.h>
#import "RESTNetworking.h"

@implementation OrderNetworking
{
    NSString *m_string_uri;
}

- (instancetype)init
{
    if (self = [super init]) {
        m_string_uri = @"/shop/order/";
    }
    return self;
}

- (void)CreateFromGoods:(NSNumber *)goods_id
                success:(void(^)(CartModel *response))success_response
                   fail:(void(^)(HttpResponseJson *response))failure_response
{
    NSDictionary *params = @{
                             @"from": @"goods",
                             @"goods": goods_id,
                             };
    [[[RESTNetworking alloc] initWithURI:m_string_uri] Post:params response:^(HttpResponseJson *response_data) {
        if (response_data.StatusCode == 200) {
            success_response([CartModel mj_objectWithKeyValues:response_data.Result]);
        } else {
            failure_response(response_data);
        }
    }];
}

- (void)CreateFromCart:(NSArray *)cart_items
               success:(void(^)(CartModel *response))success_response
                  fail:(void(^)(HttpResponseJson *response))failure_response
{
    NSDictionary *params = @{
                             @"from": @"cart",
                             @"cart_items": cart_items,
                             };
    [[[RESTNetworking alloc] initWithURI:m_string_uri] Post:params response:^(HttpResponseJson *response_data) {
        if (response_data.StatusCode == 200) {
            success_response([CartModel mj_objectWithKeyValues:response_data.Result]);
        } else {
            failure_response(response_data);
        }
    }];
}

- (void)GetOrderList:(OrderStatus)order_status
             success:(void(^)(OrderListModel *response))success_response
                fail:(void(^)(HttpResponseJson *response))failure_response
{
    switch (order_status) {
        case OrderStatusAll:
            
            break;
        
        case OrderStatusWaitSellerSendGoods:
            m_string_uri = [m_string_uri stringByAppendingString:@"?type=wait_seller_send_goods"];
            break;
        
        case OrderStatusWaitBuyerSignFor:
            m_string_uri = [m_string_uri stringByAppendingString:@"?type=wait_buyer_sign_for"];
            break;
        
        case OrderStatusBuyerSigned:
            m_string_uri = [m_string_uri stringByAppendingString:@"?type=buyer_signed"];
            break;
        
        case OrderStatusTradeFinished:
            m_string_uri = [m_string_uri stringByAppendingString:@"?type=seller_trade_finished"];
            break;
        
        default:
            break;
    }
    [[[RESTNetworking alloc] initWithURI:m_string_uri] Get:nil response:^(HttpResponseJson *response_data) {
        if (response_data.StatusCode == 200) {
            success_response([OrderListModel mj_objectWithKeyValues:response_data.Result]);
        } else {
            failure_response(response_data);
        }
    }];
}

@end
