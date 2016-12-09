//
//  HttpsRequest.h
//  WBBIClient
//
//  Created by 黃韜 on 24/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpResponseJson.h"

@interface HttpsRequest : NSObject

- (instancetype)initWithURL:(NSString *)url;
- (instancetype)initWithURI:(NSString *)uri;

- (void)Get:(NSDictionary *)parameters
       auth:(BOOL)useAuth
       json:(BOOL)useJson
   response:(void (^)(HttpResponse *response))response;

- (void)Post:(NSDictionary *)parameters
        auth:(BOOL)useAuth
        json:(BOOL)useJson
    response:(void (^)(HttpResponse *response))response;

- (void)PostFile:(NSDictionary *)parameters
       postField:(NSDictionary *)postFiles
            auth:(BOOL)useAuth
        response:(void (^)(HttpResponse *response))response;

- (void)Put:(NSDictionary *)parameters
       auth:(BOOL)useAuth
       json:(BOOL)useJson
   response:(void (^)(HttpResponse *response))response;

- (void)Patch:(NSDictionary *)parameters
         auth:(BOOL)useAuth
         json:(BOOL)useJson
     response:(void (^)(HttpResponse *response))response;

- (void)Delete:(NSDictionary *)parameters
          auth:(BOOL)useAuth
          json:(BOOL)useJson
      response:(void (^)(HttpResponse *response))response;

@end
