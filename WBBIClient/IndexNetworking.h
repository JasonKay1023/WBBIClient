//
//  IndexNetworking.h
//  WBBIClient
//
//  Created by 黃韜 on 2016/1/18.
//  Copyright © 2016年 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpResponseJson.h"
#import "IndexGoodsModel.h"

typedef enum : NSUInteger {
    IndexGoodsTypeOfficial,
    IndexGoodsTypeCreation,
    IndexGoodsTypeDiscover,
} IndexGoodsType;

@interface IndexNetworking : NSObject

- (void)GetGoodsType:(IndexGoodsType)type
              before:(NSString *)before_created
               count:(NSInteger)count
             success:(void(^)(IndexGoodsModel *goods))success_response
                fail:(void(^)(HttpResponseJson *response))failure_response;

@end
