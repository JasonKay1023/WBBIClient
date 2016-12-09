//
//  GoodsNetworking.m
//  WBBIClient
//
//  Created by 黃韜 on 13/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "GoodsNetworking.h"
#import <MJExtension.h>
#import "RESTNetworking.h"
#import "NSString+URL.h"

@implementation GoodsNetworking
{
    NSString *m_string_uri;
}

- (instancetype)init
{
    if (self = [super init]) {
        m_string_uri = @"/shop/goods/";
    }
    return self;
}

- (void)Get:(NSNumber *)goods_id
    success:(void (^)(GoodsModel *))success_response
       fail:(void (^)(HttpResponseJson *))failure_response
{
    m_string_uri = [m_string_uri AppendSuffix:[goods_id stringValue]];
    [[[RESTNetworking alloc] initWithURI:m_string_uri] Get:nil response:^(HttpResponseJson *response_data) {
        if (response_data.StatusCode == 200) {
            success_response([GoodsModel mj_objectWithKeyValues:response_data.Result]);
        } else {
            failure_response(response_data);
        }
    }];
}

- (void)CreateWithTitle:(NSString *)brand
                  brand:(NSString *)title
           introduction:(NSString *)introduction
                 madeIn:(NSString *)made_in
               madeFrom:(NSString *)made_from
              accessory:(NSString *)accessory
                 length:(NSNumber *)length
                  width:(NSNumber *)width
                 height:(NSNumber *)height
                  price:(NSNumber *)price
         sellerLatitude:(NSNumber *)seller_latitude
       sellerLongtitude:(NSNumber *)seller_longtitude
         sellerLocation:(NSString *)seller_location
           bagAttribute:(NSNumber *)bag_attribute
         sceneAttribute:(NSArray *)scene_attribute
                success:(void(^)(GoodsModel *response))success_response
                   fail:(void(^)(HttpResponseJson *response))failure_response
{
    NSDictionary *params = @{
                             @"Brand": brand,
                             @"Title": title,
                             @"Introduction": introduction,
                             @"MadeIn": made_in,
                             @"MadeFrom": made_from,
                             @"Accessory": accessory,
                             @"Length": length,
                             @"Width": width,
                             @"Height": height,
                             @"Price": price,
                             @"SellerLatitude": seller_latitude,
                             @"SellerLongitude": seller_longtitude,
                             @"SellerLocation": seller_location,
                             @"BagAttribute": @[bag_attribute],
                             @"SceneAttributes": scene_attribute,
                             };
    [[[RESTNetworking alloc] initWithURI:m_string_uri] Post:params response:^(HttpResponseJson *response_data) {
        if (response_data.StatusCode == 201) {
            success_response([GoodsModel mj_objectWithKeyValues:response_data.Result]);
        } else {
            failure_response(response_data);
        }
    }];
}

- (void)UploadPhoto:(NSDictionary *)params
          byGoodsID:(NSNumber *)goods_id
            success:(void(^)(GoodsModel *response))success_response
               fail:(void(^)(HttpResponseJson *response))failure_response
{
    m_string_uri = [[m_string_uri AppendSuffix:[goods_id stringValue]] stringByAppendingString:@"photos/"];
    [[[RESTNetworking alloc]initWithURI:m_string_uri]PostFile:nil postField:params response:^(HttpResponse *response_data) {
        HttpResponseJson *json = [[HttpResponseJson alloc] initWithHttpResponse:response_data];
        if (response_data.StatusCode == 200) {
            success_response([GoodsModel mj_objectWithKeyValues:json.Result]);
        } else {
            failure_response(json);
        }
    }];
}

@end
