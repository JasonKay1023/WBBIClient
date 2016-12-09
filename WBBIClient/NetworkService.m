//
//  NetworkService.m
//  WBBIClient
//
//  Created by 黃韜 on 23/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//
/*
#import "NetworkService.h"
#import <AFNetworking/AFNetworking.h>

@implementation NetworkService

- (void)GetVerifyCode:(NSString *)phone
{
    
}

- (void)UserRegister:(NSString *)username
            password:(NSString *)passwd
          verifyCode:(NSString *)code
{
    NSString *uri = @"user";
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:base_url];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *json_params = @{@"Phone": username, @"Code": code, @"Password": passwd};
    [manager POST:uri parameters:json_params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"Json: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@", error);
        
    }];
}

- (void)UserInfoModify:(NSString *)nickname
                sexual:(Sexual)sex
              birthday:(NSDate *)birthday
           jobIndustry:(NSString *)industry
           jobPosition:(NSString *)position
             signature:(NSString *)signature
                 place:(NSString *)place
{
    
}

@end
*/