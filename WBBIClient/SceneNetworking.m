//
//  SceneNetworking.m
//  WBBIClient
//
//  Created by 黃韜 on 14/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "SceneNetworking.h"
#import <MJExtension.h>
#import "RESTNetworking.h"

@implementation SceneNetworking
{
    NSString *m_string_uri;
}

- (instancetype)init
{
    if (self = [super init]) {
        m_string_uri = @"/shop/type/scene/";
    }
    return self;
}

- (void)GetList:(void (^)(NSArray *))success_response
           fail:(void (^)(HttpResponseJson *))failure_response
{
    [[[RESTNetworking alloc] initWithURI:m_string_uri] Get:nil response:^(HttpResponseJson *response_data) {
        if (response_data.StatusCode == 200) {
            success_response([KVModel mj_objectArrayWithKeyValuesArray:response_data.Result]);
        } else {
            failure_response(response_data);
        }
    }];
}

@end
