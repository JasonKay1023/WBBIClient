//
//  OrderQueryNetworking.m
//  WBBIClient
//
//  Created by 黃韜 on 16/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "OrderQueryNetworking.h"
#import <MJExtension.h>
#import "RESTNetworking.h"

@implementation OrderQueryNetworking
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

- (void)Get:(OrderQueryType)type
    success:(void(^)(OrderListModel *response))success_response
       fail:(void(^)(HttpResponseJson *response))failure_response
{
    NSString *param_type;
    switch (type) {
        case OrderQueryTypeAll:
            param_type = @"";
            break;
            
        case OrderQueryTypeWaitSellerSendGoods:
            param_type = @"?type=wait_seller_send_goods";
            break;
        
        case OrderQueryTypeWaitBuyerSignFor:
            param_type = @"?type=wait_buyer_sign_for";
            break;
            
        case OrderQueryTypeBuyerSigned:
            param_type = @"?type=buyer_signed";
            break;
        
        case OrderQueryTypeSellerTradeFinished:
            param_type = @"?type=seller_trade_finished";
            break;
            
        default:
            break;
    }
    [m_string_uri stringByAppendingString:param_type];
    [[[RESTNetworking alloc] initWithURI:m_string_uri] Get:nil response:^(HttpResponseJson *response_data) {
        if (response_data.StatusCode == 200) {
            success_response([OrderListModel mj_objectWithKeyValues:response_data.Result]);
        } else {
            failure_response(response_data);
        }
    }];
}

@end
