//
//  GoodsNetworking.h
//  WBBIClient
//
//  Created by 黃韜 on 13/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpResponseJson.h"
#import "GoodsModel.h"

@interface GoodsNetworking : NSObject

- (void)Get:(NSNumber *)goods_id
    success:(void(^)(GoodsModel *response))success_response
       fail:(void(^)(HttpResponseJson *response))failure_response;

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
                   fail:(void(^)(HttpResponseJson *response))failure_response;

- (void)UploadPhoto:(NSDictionary *)params
          byGoodsID:(NSNumber *)goods_id
            success:(void(^)(GoodsModel *response))success_response
               fail:(void(^)(HttpResponseJson *response))failure_response;

@end
