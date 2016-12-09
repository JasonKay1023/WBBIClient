//
//  UserAddressNetworking.h
//  WBBIClient
//
//  Created by 黃韜 on 15/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpResponseJson.h"
#import "UserAddressModel.h"

@interface UserAddressNetworking : NSObject

- (instancetype)initWithAddressID:(NSNumber *)goods_id;

- (void)BuyerName:(NSString *)buyer_name
       districtID:(NSString *)district_zipcode
          zipCode:(NSString *)zip_code
          address:(NSString *)address
            phone:(NSString *)phone
          success:(void(^)(UserAddressModel *response))success_response
             fail:(void(^)(HttpResponseJson *response))failure_response;

- (void)GetList:(void(^)(NSArray *response))success_response
           fail:(void(^)(HttpResponseJson *response))failure_response;

- (void)Get:(void(^)(UserAddressModel *response))success_response
       fail:(void(^)(HttpResponseJson *response))failure_response;

- (void)Delete:(void(^)(HttpResponseJson *response))success_response
          fail:(void(^)(HttpResponseJson *response))failure_response;

@end
