//
//  RESTNetworking.m
//  WBBIClient
//
//  Created by 黃韜 on 24/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "RESTNetworking.h"
#import "AppConstants.h"
#import <AFOAuth2Manager/AFOAuth2Manager.h>
#import "HttpsRequest.h"
#import "HttpResponseJson.h"
#import "MBProgressHUD.h"

@interface RESTNetworking ()
{
    int retryCount;
}

@property (strong, nonatomic) HttpsRequest *request;

@end

@implementation RESTNetworking

@synthesize request = m_pRequest;

- (instancetype)initWithURI:(NSString *)uri
{
    self = [super init];
    if (self) {
        retryCount = 0;
        m_pRequest = [[HttpsRequest alloc] initWithURI:uri];
    }
    return self;
}

- (void)Authorization:(NSString *)username
             password:(NSString *)password
             response:(void (^)(HttpResponse *response_object))response
{
    NSString *scope = @"read write";
    NSString *uri = @"/oauth2/token/";
    NSURL *base_url = [NSURL URLWithString:BaseURL];
    AFOAuth2Manager *oauth2_manager = [[AFOAuth2Manager alloc] initWithBaseURL:base_url
                                                                      clientID:ClientID
                                                                        secret:ClientSecret];
    if (UseSelfSSL) {
        oauth2_manager.securityPolicy.allowInvalidCertificates = YES;
        oauth2_manager.securityPolicy.validatesDomainName = NO;
        //AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    }
    [oauth2_manager authenticateUsingOAuthWithURLString:uri username:username password:password scope:scope success:^(AFOAuthCredential *credential) {
        //NSLog(@"%@", oauth2_manager.serviceProviderIdentifier);
        //[AFOAuthCredential storeCredential:credential
        //                    withIdentifier:oauth2_manager.serviceProviderIdentifier];
        [AFOAuthCredential storeCredential:credential
                            withIdentifier:HostName];
        //[AFOAuthCredential storeCredential:credential withIdentifier:[base_url host]];
        NSLog(@"Token: %@", credential.accessToken);
        NSLog(@"Refresh: %@", credential.refreshToken);
        
        HttpResponse *result = [[HttpResponse alloc] initWithStatusCode:200 body:@{@"access_token": credential.accessToken,
                                                                                   @"refresh_token": credential.refreshToken}];
        response(result);
        
    } failure:^(NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        HttpResponse *result = [[HttpResponse alloc] initWithStatusCode:401 error:error];
        response(result);
        
    }];
}

- (void)Get:(NSDictionary *)parameters
   response:(void (^)(HttpResponseJson *))response
{
    [m_pRequest Get:parameters auth:YES json:YES response:^(HttpResponse *response_object) {
        
        [self response_processor:response_object
                        response:response
                          method:@"get"
                      parameters:parameters];
        
    }];
}

- (void)GetPhoto:(NSDictionary *)parameters
        response:(void (^)(HttpResponse *))response
{
    [m_pRequest Get:parameters auth:YES json:NO response:^(HttpResponse *response_object) {
        response(response_object);
    }];
}

- (void)Post:(NSDictionary *)parameters
    response:(void (^)(HttpResponseJson *))response
{
    [m_pRequest Post:parameters auth:YES json:YES response:^(HttpResponse *response_object) {
        
        [self response_processor:response_object
                        response:response
                          method:@"post"
                      parameters:parameters];
        
    }];
}

- (void)PostFile:(NSDictionary *)parameters
       postField:(NSDictionary *)postFiles
        response:(void (^)(HttpResponse *response))response
{
    [m_pRequest PostFile:parameters postField:postFiles auth:YES response:^(HttpResponse *response_object) {
        [self response_processor:response_object
                        response:response
                          method:@"post"
                      parameters:parameters];
    }];
}

- (void)PostWithoutAuth:(NSDictionary *)parameters
               response:(void (^)(HttpResponseJson *))response
{
    [m_pRequest Post:parameters auth:NO json:YES response:^(HttpResponse *response_object) {
        
        [self response_processor:response_object
                        response:response
                          method:@"post"
                      parameters:parameters];
        
    }];
}

- (void)Put:(NSDictionary *)parameters
   response:(void (^)(HttpResponseJson *))response
{
    [m_pRequest Put:parameters auth:YES json:YES response:^(HttpResponse *response_object) {
        
        [self response_processor:response_object
                        response:response
                          method:@"put"
                      parameters:parameters];
        
    }];
}

- (void)PutWithoutAuth:(NSDictionary *)parameters
               response:(void (^)(HttpResponseJson *))response
{
    [m_pRequest Put:parameters auth:NO json:YES response:^(HttpResponse *response_object) {
        
        [self response_processor:response_object
                        response:response
                          method:@"put"
                      parameters:parameters];
        
    }];
}

- (void)Patch:(NSDictionary *)parameters
     response:(void (^)(HttpResponseJson *))response
{
    [m_pRequest Patch:parameters auth:YES json:YES response:^(HttpResponse *response_object) {
        
        [self response_processor:response_object
                        response:response
                          method:@"patch"
                      parameters:parameters];
        
    }];
}

- (void)Delete:(NSDictionary *)parameters
      response:(void (^)(HttpResponseJson *))response
{
    [m_pRequest Delete:parameters auth:YES json:YES response:^(HttpResponse *response_object) {
        
        [self response_processor:response_object
                        response:response
                          method:@"delete"
                      parameters:parameters];
        
    }];
}

- (void)response_processor:(HttpResponse *)response response:(void (^)(HttpResponseJson *))responseTo method:(NSString *)method parameters:(NSDictionary *)params
{
    if (response.StatusCode == 401) {
//        
//        if (retryCount != 0) {
//            HttpResponseJson *response_disable = [[HttpResponseJson alloc] initWithStatusCode:response.StatusCode
//                                                                                         body:response.Body];
//            responseTo(response_disable);
//            return;
//        }
//        
//        NSString *uri = @"/oauth2/token/";
//        NSURL *base_url = [NSURL URLWithString:BaseURL];
//        AFOAuth2Manager *oauth2_manager = [[AFOAuth2Manager alloc] initWithBaseURL:base_url
//                                                                          clientID:ClientID
//                                                                            secret:ClientSecret];
//        if (UseSelfSSL) {
//            oauth2_manager.securityPolicy.allowInvalidCertificates = YES;
//            oauth2_manager.securityPolicy.validatesDomainName = NO;
//        }
//        AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:HostName];
//        [oauth2_manager authenticateUsingOAuthWithURLString:uri refreshToken:credential.refreshToken success:^(AFOAuthCredential *credential) {
//            
//            [AFOAuthCredential storeCredential:credential
//                                withIdentifier:HostName];
//            NSLog(@"Token: %@", credential.accessToken);
//            NSLog(@"Refresh: %@", credential.refreshToken);
//            
//            if ([method isEqualToString:@"get"]) {
//                [self Get:params response:responseTo];
//            } else if ([method isEqualToString:@"post"]) {
//                [self Post:params response:responseTo];
//            } else if ([method isEqualToString:@"put"]) {
//                [self Put:params response:responseTo];
//            } else if ([method isEqualToString:@"patch"]) {
//                [self Patch:params response:responseTo];
//            } else if ([method isEqualToString:@"delete"]) {
//                [self Delete:params response:responseTo];
//            }
//            
//        } failure:^(NSError *error) {
//            
//            NSLog(@"Error: %@", error);
//            HttpResponseJson *response_disable = [[HttpResponseJson alloc] initWithStatusCode:0
//                                                                                        error:error];
//            responseTo(response_disable);
//            
//        }];
//        ++retryCount;
        
        HttpResponseJson *response_disable = [[HttpResponseJson alloc] initWithStatusCode:response.StatusCode
                                                                                     body:response.Body];
        responseTo(response_disable);
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (window) {
            MBProgressHUD *progress_hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
            progress_hud.labelText = NSLocalizedString(@"您还未登录呢", @"");
            progress_hud.mode = MBProgressHUDModeText;
            [self show_progress_hud:progress_hud timer:1.5];
        }
        
    } else {
        
        //HttpResponseJson *response_usable = [[HttpResponseJson alloc] initWithStatusCode:response.StatusCode
        //                                                                            body:response.Body];
        //responseTo(response_usable);
        HttpResponseJson *response_usable = [[HttpResponseJson alloc] initWithHttpResponse:response];
        responseTo(response_usable);
        
    }
}

- (void)show_progress_hud:(MBProgressHUD *)progress_hud timer:(NSTimeInterval)timer
{
    [progress_hud showAnimated:YES whileExecutingBlock:^{
        
        [NSThread sleepForTimeInterval:timer];
        
    } completionBlock:^{
        
        [progress_hud removeFromSuperview];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (window) {
            window.userInteractionEnabled = YES;
        }
        
    }];
}

@end
