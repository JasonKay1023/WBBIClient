//
//  CartNetworking.h
//  WBBIClient
//
//  Created by 黃韜 on 11/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpResponseJson.h"
#import "CartModel.h"
#import "CartSellerItemModel.h"
#import "CartItemModel.h"

@interface CartNetworking : NSObject

- (instancetype)initWithCartID:(NSNumber *)cart_id;

- (void)Get:(void(^)(CartModel *cart))success_response
       fail:(void(^)(HttpResponseJson *response))failure_response;

- (void)Create:(NSNumber *)goods_id
       success:(void(^)(CartItemModel *cart))success_response
          fail:(void(^)(HttpResponseJson *response))failure_response;

- (void)Update:(NSDictionary *)goods_id_quantity
       success:(void(^)(HttpResponseJson *response))success_response
          fail:(void(^)(HttpResponseJson *response))failure_response;

- (void)Delete:(NSNumber *)goods_id
       success:(void(^)(HttpResponseJson *response))success_response
          fail:(void(^)(HttpResponseJson *response))failure_response;

@end
