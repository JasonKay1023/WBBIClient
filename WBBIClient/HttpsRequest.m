//
//  HttpsRequest.m
//  WBBIClient
//
//  Created by 黃韜 on 24/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "HttpsRequest.h"
#import "HttpResponseJson.h"
#import "AppConstants.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <AFOAuth2Manager/AFHTTPRequestSerializer+OAuth2.h>
#import <AFOAuth2Manager/AFOAuth2Manager.h>

@interface HttpsRequest ()

@property (strong, nonatomic) NSURL *urlPath;
@property (strong, nonatomic) AFHTTPRequestOperationManager* manager;

@end

@implementation HttpsRequest

@synthesize urlPath = m_pURLPath;
@synthesize manager = m_pManager;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
/*
 - (instancetype)initWithURI:(NSString *)uri
 {
 NSString *url = [[@"https://" stringByAppendingString:HostName] stringByAppendingString:uri];
 return [self initWithURL:url];
 }*/

- (instancetype)initWithURI:(NSString *)uri
{
    NSString *url = [BaseURL stringByAppendingString:uri];
    return [self initWithURL:url];
}

- (instancetype)initWithURL:(NSString *)url
{
    self = [super init];
    if (self) {
        m_pManager = [[AFHTTPRequestOperationManager alloc]
                      initWithBaseURL:[NSURL URLWithString:url]];
        m_pURLPath = [NSURL URLWithString:url];
    }
    return self;
}

- (void)Get:(NSDictionary *)parameters
       auth:(BOOL)useAuth
       json:(BOOL)useJson
   response:(void (^)(HttpResponse *response))response
{
    if (useJson) {
        m_pManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    if (useAuth) {
        AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:HostName];
        [m_pManager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:(AFSSLPinningModeNone)];
        policy.allowInvalidCertificates = YES;
        policy.validatesDomainName = NO;
        m_pManager.securityPolicy = policy;
    }
    [m_pManager GET:[m_pURLPath absoluteString] parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        HttpResponse *response_data = [[HttpResponse alloc] initWithStatusCode:operation.response.statusCode
                                                                          body:responseObject];
        response(response_data);
        NSLog(@"operation: %@ \nresponseObject: %@", [operation description], [responseObject description]);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        if (operation.responseObject) {
            NSInteger status = operation.response.statusCode;
            HttpResponse *response_data = [[HttpResponse alloc] initWithStatusCode:status
                                                                              body:operation.responseObject];
            response(response_data);
        } else {
            HttpResponse *response_data = [[HttpResponse alloc] initWithStatusCode:0
                                                                             error:error];
            response(response_data);
        }
        NSLog(@"operation: %@ \nresponseObject: %@ \nerror: %@",
              [operation description],
              [operation.responseObject description],
              [error description]);
        
    }];
}

- (void)Post:(NSDictionary *)parameters
        auth:(BOOL)useAuth
        json:(BOOL)useJson
    response:(void (^)(HttpResponse *response))response
{
    if (useJson) {
        m_pManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    if (useAuth) {
        AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:HostName];
        [m_pManager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:(AFSSLPinningModeNone)];
        policy.allowInvalidCertificates = YES;
        policy.validatesDomainName = NO;
        m_pManager.securityPolicy = policy;
    }
    NSLog(@"%@", [m_pURLPath absoluteString]);
    [m_pManager POST:[m_pURLPath absoluteString] parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        HttpResponse *response_data = [[HttpResponse alloc] initWithStatusCode:operation.response.statusCode
                                                                          body:responseObject];
        response(response_data);
        NSLog(@"operation: %@ \nresponseObject: %@", [operation description], [responseObject description]);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        if (operation.responseObject) {
            NSInteger status = operation.response.statusCode;
            HttpResponse *response_data = [[HttpResponse alloc] initWithStatusCode:status
                                                                              body:operation.responseObject];
            response(response_data);
        } else {
            HttpResponse *response_data = [[HttpResponse alloc] initWithStatusCode:0
                                                                             error:error];
            response(response_data);
        }
        NSLog(@"operation: %@ \nresponseObject: %@ \nerror: %@",
              [operation description],
              [operation.responseObject description],
              [error description]);
        
    }];
}

- (void)PostFile:(NSDictionary *)parameters
       postField:(NSDictionary *)postFiles
            auth:(BOOL)useAuth
        response:(void (^)(HttpResponse *response))response
{
    if (useAuth) {
        AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:HostName];
        [m_pManager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:(AFSSLPinningModeNone)];
        policy.allowInvalidCertificates = YES;
        policy.validatesDomainName = NO;
        m_pManager.securityPolicy = policy;
    }
    [m_pManager POST:[m_pURLPath absoluteString] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSString *key in postFiles) {
            NSData *fileData = [postFiles objectForKey:key];
            [formData appendPartWithFileData:fileData
                                        name:key
                                    fileName:key
                                    mimeType:@"image/jpeg"];
            NSLog(@"%@ %lu", key, (unsigned long)fileData.length);
        }
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        HttpResponse *response_data = [[HttpResponse alloc] initWithStatusCode:operation.response.statusCode
                                                                          body:responseObject];
        response(response_data);
        NSLog(@"operation: %@ \nresponseObject: %@", [operation description], [responseObject description]);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        if (operation.responseObject) {
            NSInteger status = operation.response.statusCode;
            HttpResponse *response_data = [[HttpResponse alloc] initWithStatusCode:status
                                                                              body:operation.responseObject];
            response(response_data);
        } else {
            HttpResponse *response_data = [[HttpResponse alloc] initWithStatusCode:0
                                                                             error:error];
            response(response_data);
        }
        NSLog(@"operation: %@ \nresponseObject: %@ \nerror: %@",
              [operation description],
              [operation.responseObject description],
              [error description]);
        
    }];
}

- (void)Put:(NSDictionary *)parameters
       auth:(BOOL)useAuth
       json:(BOOL)useJson
   response:(void (^)(HttpResponse *response))response
{
    if (useJson) {
        m_pManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    if (useAuth) {
        AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:HostName];
        [m_pManager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:(AFSSLPinningModeNone)];
        policy.allowInvalidCertificates = YES;
        policy.validatesDomainName = NO;
        m_pManager.securityPolicy = policy;
    }
    [m_pManager PUT:[m_pURLPath absoluteString] parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        HttpResponse *response_data = [[HttpResponse alloc] initWithStatusCode:operation.response.statusCode
                                                                          body:responseObject];
        response(response_data);
        NSLog(@"operation: %@ \nresponseObject: %@", [operation description], [responseObject description]);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        if (operation.responseObject) {
            NSInteger status = operation.response.statusCode;
            HttpResponse *response_data = [[HttpResponse alloc] initWithStatusCode:status
                                                                              body:operation.responseObject];
            response(response_data);
        } else {
            HttpResponse *response_data = [[HttpResponse alloc] initWithStatusCode:0
                                                                             error:error];
            response(response_data);
        }
        NSLog(@"operation: %@ \nresponseObject: %@ \nerror: %@",
              [operation description],
              [operation.responseObject description],
              [error description]);
        
    }];
}

- (void)Patch:(NSDictionary *)parameters
         auth:(BOOL)useAuth
         json:(BOOL)useJson
     response:(void (^)(HttpResponse *response))response
{
    if (useJson) {
        m_pManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    if (useAuth) {
        AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:HostName];
        [m_pManager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:(AFSSLPinningModeNone)];
        policy.allowInvalidCertificates = YES;
        policy.validatesDomainName = NO;
        m_pManager.securityPolicy = policy;
    }
    [m_pManager PATCH:[m_pURLPath absoluteString] parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        HttpResponse *response_data = [[HttpResponse alloc] initWithStatusCode:operation.response.statusCode
                                                                          body:responseObject];
        response(response_data);
        NSLog(@"operation: %@ \nresponseObject: %@", [operation description], [responseObject description]);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        if (operation.responseObject) {
            NSInteger status = operation.response.statusCode;
            HttpResponse *response_data = [[HttpResponse alloc] initWithStatusCode:status
                                                                              body:operation.responseObject];
            response(response_data);
        } else {
            HttpResponse *response_data = [[HttpResponse alloc] initWithStatusCode:0
                                                                             error:error];
            response(response_data);
        }
        NSLog(@"operation: %@ \nresponseObject: %@ \nerror: %@",
              [operation description],
              [operation.responseObject description],
              [error description]);
        
    }];
}

- (void)Delete:(NSDictionary *)parameters
          auth:(BOOL)useAuth
          json:(BOOL)useJson
      response:(void (^)(HttpResponse *response))response
{
    if (useJson) {
        m_pManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    if (useAuth) {
        AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:HostName];
        [m_pManager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:(AFSSLPinningModeNone)];
        policy.allowInvalidCertificates = YES;
        policy.validatesDomainName = NO;
        m_pManager.securityPolicy = policy;
    }
    [m_pManager DELETE:[m_pURLPath absoluteString] parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        HttpResponse *response_data = [[HttpResponse alloc] initWithStatusCode:operation.response.statusCode
                                                                          body:responseObject];
        response(response_data);
        NSLog(@"operation: %@ \nresponseObject: %@", [operation description], [responseObject description]);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        if (operation.responseObject) {
            NSInteger status = operation.response.statusCode;
            HttpResponse *response_data = [[HttpResponse alloc] initWithStatusCode:status
                                                                              body:operation.responseObject];
            response(response_data);
        } else {
            HttpResponse *response_data = [[HttpResponse alloc] initWithStatusCode:0
                                                                             error:error];
            response(response_data);
        }
        NSLog(@"operation: %@ \nresponseObject: %@ \nerror: %@",
              [operation description],
              [operation.responseObject description],
              [error description]);
        
    }];
}

@end
