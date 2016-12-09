//
//  UserAddressNetworking.m
//  WBBIClient
//
//  Created by 黃韜 on 15/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "UserAddressNetworking.h"
#import <MJExtension.h>
#import "RESTNetworking.h"
#import "NSString+URL.h"

@implementation UserAddressNetworking
{
    NSString *m_string_uri;
    NSString *m_num_goodsid;
}

- (instancetype)init
{
    if (self = [super init]) {
        m_string_uri = @"/shop/address/";
    }
    return self;
}

- (instancetype)initWithAddressID:(NSNumber *)goods_id
{
    if (self = [super init]) {
        m_string_uri = @"/shop/address/";
        m_num_goodsid = [goods_id stringValue];
    }
    return self;
}

- (void)BuyerName:(NSString *)buyer_name
       districtID:(NSString *)district_zipcode
          zipCode:(NSString *)zip_code
          address:(NSString *)address
            phone:(NSString *)phone
          success:(void(^)(UserAddressModel *response))success_response
             fail:(void(^)(HttpResponseJson *response))failure_response
{
    NSDictionary *params = @{@"BuyerName": buyer_name,
                             @"DistrictZipCode": district_zipcode,
                             @"ZipCode": zip_code,
                             @"Address": address,
                             @"Phone": phone};
    if (m_num_goodsid) {
        m_string_uri = [m_string_uri AppendSuffix:m_num_goodsid];
        [[[RESTNetworking alloc] initWithURI:m_string_uri] Put:params response:^(HttpResponseJson *response_data) {
            if (response_data.StatusCode == 200) {
                success_response([UserAddressModel mj_objectWithKeyValues:response_data.Result]);
            } else {
                failure_response(response_data);
            }
        }];
    } else {
        [[[RESTNetworking alloc] initWithURI:m_string_uri] Post:params response:^(HttpResponseJson *response_data) {
            if (response_data.StatusCode == 201) {
                success_response([UserAddressModel mj_objectWithKeyValues:response_data.Result]);
            } else {
                failure_response(response_data);
            }
        }];
    }
}

- (void)GetList:(void(^)(NSArray *response))success_response
           fail:(void(^)(HttpResponseJson *response))failure_response
{
    [[[RESTNetworking alloc] initWithURI:m_string_uri] Get:nil response:^(HttpResponseJson *response_data) {
        if (response_data.StatusCode == 200) {
            success_response([UserAddressModel mj_keyValuesArrayWithObjectArray:response_data.Result]);
        } else {
            failure_response(response_data);
        }
    }];
}

- (void)Get:(void(^)(UserAddressModel *response))success_response
       fail:(void(^)(HttpResponseJson *response))failure_response
{
    if (m_num_goodsid) {
        m_string_uri = [m_string_uri AppendSuffix:m_num_goodsid];
    } else {
        return;
    }
    [[[RESTNetworking alloc] initWithURI:m_string_uri] Get:nil response:^(HttpResponseJson *response_data) {
        if (response_data.StatusCode == 200) {
            success_response([UserAddressModel mj_objectWithKeyValues:response_data.Result]);
        } else {
            failure_response(response_data);
        }
    }];
}

- (void)Delete:(void(^)(HttpResponseJson *response))success_response
          fail:(void(^)(HttpResponseJson *response))failure_response
{
    if (m_num_goodsid) {
        m_string_uri = [m_string_uri AppendSuffix:m_num_goodsid];
    } else {
        return;
    }
    [[[RESTNetworking alloc] initWithURI:m_string_uri] Delete:nil response:^(HttpResponseJson *response_data) {
        if (response_data.StatusCode == 200) {
            success_response(response_data);
        } else {
            failure_response(response_data);
        }
    }];
}

@end
