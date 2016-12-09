//
//  GoodsFavourNetworking.m
//  WBBIClient
//
//  Created by 黃韜 on 15/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "GoodsFavourNetworking.h"
#import <MJExtension.h>
#import "RESTNetworking.h"
#import "GoodsModel.h"
#import "NSString+URL.h"

@implementation GoodsFavourNetworking
{
    NSString *m_string_uri;
}

- (instancetype)init
{
    if (self = [super init]) {
        m_string_uri = @"/shop/favour/";
    }
    return self;
}

- (instancetype)initWithGoodsID:(NSNumber *)goods_id
{
    if (self = [super init]) {
        m_string_uri = [[@"/shop/goods/" AppendSuffix:[goods_id stringValue]]
                        stringByAppendingString:@"favour/"];
    }
    return self;
}

- (void)GetList:(void(^)(NSArray *response))success_response
           fail:(void(^)(HttpResponseJson *response))failure_response
{
    [[[RESTNetworking alloc] initWithURI:m_string_uri] Get:nil response:^(HttpResponseJson *response_data) {
        if (response_data.StatusCode == 200) {
            success_response([GoodsModel mj_objectArrayWithKeyValuesArray:response_data.Result]);
        } else {
            failure_response(response_data);
        }
    }];
}

- (void)Create:(void(^)(HttpResponseJson *response))success_response
    duplicated:(void(^)(HttpResponseJson *response))duplicated_response
          fail:(void(^)(HttpResponseJson *response))failure_response
{
    [[[RESTNetworking alloc] initWithURI:m_string_uri] Post:nil response:^(HttpResponseJson *response_data) {
        if (response_data.StatusCode == 400) {
            duplicated_response(response_data);
        } else if (response_data.StatusCode == 201) {
            success_response(response_data);
        } else {
            failure_response(response_data);
        }
    }];
}

- (void)Delete:(void(^)(HttpResponseJson *response))success_response
          fail:(void(^)(HttpResponseJson *response))failure_response
{
    [[[RESTNetworking alloc] initWithURI:m_string_uri] Delete:nil response:^(HttpResponseJson *response_data) {
        if (response_data.StatusCode == 200) {
            success_response(response_data);
        } else {
            failure_response(response_data);
        }
    }];
}

@end
