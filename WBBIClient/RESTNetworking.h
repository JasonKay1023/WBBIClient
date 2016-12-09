//
//  RESTNetworking.h
//  WBBIClient
//
//  Created by 黃韜 on 24/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpResponseJson.h"

@interface RESTNetworking : NSObject

- (instancetype)initWithURI:(NSString *)uri;

- (void)Authorization:(NSString *)username
             password:(NSString *)password
             response:(void (^)(HttpResponse *response_object))response;

- (void)Get:(NSDictionary *)parameters
   response:(void (^)(HttpResponseJson *response_data))response;

- (void)GetPhoto:(NSDictionary *)parameters
        response:(void (^)(HttpResponse *response_data))response;

- (void)Post:(NSDictionary *)parameters
    response:(void (^)(HttpResponseJson *response_data))response;

- (void)PostFile:(NSDictionary *)parameters
       postField:(NSDictionary *)postFiles
        response:(void (^)(HttpResponse *response_data))response;

- (void)PostWithoutAuth:(NSDictionary *)parameters
               response:(void (^)(HttpResponseJson *response_data))response;

- (void)Put:(NSDictionary *)parameters
   response:(void (^)(HttpResponseJson *response_data))response;

- (void)PutWithoutAuth:(NSDictionary *)parameters
              response:(void (^)(HttpResponseJson *response_data))response;

- (void)Patch:(NSDictionary *)parameters
     response:(void (^)(HttpResponseJson *response_data))response;

- (void)Delete:(NSDictionary *)parameters
      response:(void (^)(HttpResponseJson *response_data))response;

@end
