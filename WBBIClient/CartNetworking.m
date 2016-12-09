//
//  CartNetworking.m
//  WBBIClient
//
//  Created by 黃韜 on 11/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "CartNetworking.h"
#import <MJExtension.h>
#import "RESTNetworking.h"
#import "NSString+URL.h"

@implementation CartNetworking
{
    NSString *m_string_uri;
}

- (instancetype)initWithCartID:(NSNumber *)cart_id
{
    if (self = [super init]) {
        m_string_uri = [@"/shop/cart_item/" AppendSuffix:[cart_id stringValue]];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        m_string_uri = @"/shop/cart_item/";
    }
    return self;
}

- (void)Get:(void(^)(CartModel *cart))success_response
       fail:(void(^)(HttpResponseJson *response))failure_response;
{
    [[[RESTNetworking alloc] initWithURI:@"/shop/cart/"] Get:nil response:^(HttpResponseJson *response_data) {
        if (response_data.StatusCode == 200) {
            success_response([CartModel mj_objectWithKeyValues:response_data.Result]);
        } else {
            failure_response(response_data);
        }
    }];
}

- (void)Create:(NSNumber *)goods_id
       success:(void(^)(CartItemModel *cart))success_response
          fail:(void(^)(HttpResponseJson *response))failure_response
{
    NSDictionary *params = @{
                             @"goods_id":goods_id
                             };
    [[[RESTNetworking alloc] initWithURI:m_string_uri] Post:params response:^(HttpResponseJson *response_data) {
        if (response_data.StatusCode == 200) {
            success_response([CartItemModel mj_objectWithKeyValues:response_data.Result]);
        } else {
            failure_response(response_data);
        }
    }];
}

- (void)Update:(NSDictionary *)goods_id_quantity
       success:(void(^)(HttpResponseJson *response))success_response
          fail:(void(^)(HttpResponseJson *response))failure_response;
{
    m_string_uri = @"/shop/cart/";
    [[[RESTNetworking alloc] initWithURI:m_string_uri] Post:goods_id_quantity response:^(HttpResponseJson *response_data) {
        if (response_data.StatusCode == 200) {
            success_response(response_data);
        } else {
            failure_response(response_data);
        }
    }];
}

- (void)Delete:(NSNumber *)goods_id
       success:(void(^)(HttpResponseJson *response))success_response
          fail:(void(^)(HttpResponseJson *response))failure_response
{
    m_string_uri = [m_string_uri AppendSuffix:[goods_id stringValue]];
    [[[RESTNetworking alloc] initWithURI:m_string_uri] Delete:nil response:^(HttpResponseJson *response_data) {
        if (response_data.StatusCode == 200) {
            success_response(response_data);
        } else {
            failure_response(response_data);
        }
    }];
}

@end
