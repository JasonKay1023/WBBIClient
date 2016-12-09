//
//  IndexNetworking.m
//  WBBIClient
//
//  Created by 黃韜 on 2016/1/18.
//  Copyright © 2016年 WBB. All rights reserved.
//

#import "IndexNetworking.h"
#import <MJExtension.h>
#import "RESTNetworking.h"
#import "NSString+URL.h"

@implementation IndexNetworking
{
    NSString *m_string_uri;
}

- (instancetype)init
{
    if (self = [super init]) {
        m_string_uri = @"/shop/index/";
    }
    return self;
}

- (void)GetGoodsType:(IndexGoodsType)type
              before:(NSString *)before_created
               count:(NSInteger)count
             success:(void (^)(IndexGoodsModel *))success_response
                fail:(void (^)(HttpResponseJson *))failure_response
{
    switch (type) {
        case IndexGoodsTypeOfficial:
            m_string_uri = [m_string_uri stringByAppendingString:@"official/"];
            break;
            
        case IndexGoodsTypeCreation:
            m_string_uri = [m_string_uri stringByAppendingString:@"creation/"];
            break;
            
        case IndexGoodsTypeDiscover:
            m_string_uri = [m_string_uri stringByAppendingString:@"discover/"];
            break;
            
        default:
            break;
    }
    
    NSDictionary *params;
    if (before_created == nil) {
        params = @{
                   @"count": [NSNumber numberWithInteger:count],
                   };
    } else {
        params = @{
                   @"created_before": before_created,
                   @"count": [NSNumber numberWithInteger:count],
                   };
    }
    
    [[[RESTNetworking alloc] initWithURI:m_string_uri] Get:params response:^(HttpResponseJson *response_data) {
        if (response_data.StatusCode == 200) {
            success_response([IndexGoodsModel mj_objectWithKeyValues:response_data.Result]);
        } else {
            failure_response(response_data);
        }
    }];
}

@end
