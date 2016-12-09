//
//  SceneNetworking.h
//  WBBIClient
//
//  Created by 黃韜 on 14/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpResponseJson.h"
#import "KVModel.h"

@interface SceneNetworking : NSObject

- (void)GetList:(void(^)(NSArray *response))success_response
           fail:(void(^)(HttpResponseJson *response))failure_response;

@end
