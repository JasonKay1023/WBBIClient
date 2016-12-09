//
//  OrderExpressNetworking.h
//  WBBIClient
//
//  Created by 黃韜 on 16/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpResponseJson.h"

@interface OrderExpressNetworking : NSObject

- (void)Get:(NSNumber *)goods_id
    success:(void(^)(HttpResponseJson *response))success_response
       fail:(void(^)(HttpResponseJson *response))failure_response;

@end
