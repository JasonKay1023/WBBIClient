//
//  GoodsLikeNetworking.h
//  WBBIClient
//
//  Created by 黃韜 on 15/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpResponseJson.h"

@interface GoodsLikeNetworking : NSObject

- (instancetype)initWithGoodsID:(NSNumber *)goods_id;

- (void)Create:(void(^)(HttpResponseJson *response))success_response
    duplicated:(void(^)(HttpResponseJson *response))duplicated_response
          fail:(void(^)(HttpResponseJson *response))failure_response;

- (void)Delete:(void(^)(HttpResponseJson *response))success_response
          fail:(void(^)(HttpResponseJson *response))failure_response;

- (void)GetList:(void(^)(NSArray *response))success_response
           fail:(void(^)(HttpResponseJson *response))failure_response;

@end
