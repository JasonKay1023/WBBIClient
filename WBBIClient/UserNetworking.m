//
//  UserNetworking.m
//  WBBIClient
//
//  Created by 黃韜 on 24/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "UserNetworking.h"
#import "NSDate+String.h"
#import "UIImage+Output.h"

@implementation UserNetworking

// 2.獲取驗證碼：三種情況──註冊、忘記（更改）密碼、更改手機
- (void)GetVerifyCode:(NSString *)phone
                 type:(GetVerifyCodeType)type
             response:(void (^)(HttpResponseJson *))response
{
    NSString *uri = @"/user/vercode/";
    NSString *option;
    switch (type) {
        case GetVerifyCodeTypeRegister:
            option = @"regist";
            break;
        
        case GetVerifyCodeTypeChangePasswd:
            option = @"change_password";
            break;
        
        case GetVerifyCodeTypeChangePhone:
            option = @"change_phone";
            break;
        
        default:
            break;
    }
    NSDictionary *params = @{@"Phone": phone,
                             @"Option": option};
    [[[RESTNetworking alloc] initWithURI:uri] PostWithoutAuth:params response:^(HttpResponseJson *response_data) {
        response(response_data);
    }];
}

// 3.用戶註冊
- (void)UserRegister:(NSString *)username
            password:(NSString *)passwd
          verifyCode:(NSString *)code
            response:(void (^)(HttpResponseJson *))response
{
    NSString *uri = @"/user/user/";
    NSDictionary *params = @{@"Phone": username,
                             @"Password": passwd,
                             @"Code": code};
    [[[RESTNetworking alloc] initWithURI:uri] PostWithoutAuth:params response:^(HttpResponseJson *response_data) {
        response(response_data);
    }];
}

// 4.用戶手機更改
- (void)UserPhoneReset:(NSString *)old_phone
              newPhone:(NSString *)new_phone
               vercode:(NSString *)verify_code
              password:(NSString *)password
              response:(void (^)(HttpResponseJson *))response
{
    NSString *uri = @"/user/user/";
    NSDictionary *params = @{@"OldPhone": old_phone,
                             @"Phone": new_phone,
                             @"Code": verify_code,
                             @"Password": password};
    [[[RESTNetworking alloc] initWithURI:uri] PutWithoutAuth:params response:^(HttpResponseJson *response_data) {
        response(response_data);
    }];
}

// 5.用戶密碼更改
- (void)UserPasswordReset:(NSString *)phone
                  vercode:(NSString *)verify_code
                 password:(NSString *)password
                 response:(void (^)(HttpResponseJson *))response
{
    NSString *uri = @"/user/user/";
    NSDictionary *params = @{@"Phone": phone,
                             @"Code": verify_code,
                             @"Password": password};
    [[[RESTNetworking alloc] initWithURI:uri] PutWithoutAuth:params response:^(HttpResponseJson *response_data) {
        response(response_data);
    }];
}

// 6.用戶實名認證
- (void)RealNameValidate:(NSString *)realname
          identifyNumber:(NSString *)idNumber
                response:(void (^)(HttpResponseJson *))response
{
    NSString *uri = @"/user/realname_validate/";
    NSDictionary *params = @{@"RealName": realname,
                             @"IDNumber": idNumber};
    [[[RESTNetworking alloc] initWithURI:uri] Post:params response:^(HttpResponseJson *response_data) {
        response(response_data);
    }];
}

// 7.用戶實名認證圖片
- (void)RealNamePhotos:(UIImage *)idCardPhotoJpg
     idCardHolderPhoto:(UIImage *)idCardHolderPhotoJpg
              response:(void (^)(HttpResponseJson *))response
{
    NSString *uri = @"/user/realname_validate/";
    //NSDictionary *params = @{@"Option": @"realname_validate"};
    NSDictionary *post_files = @{@"IDCardPhoto": [idCardPhotoJpg ToJPEG:1.0],
                                 @"IDCardHolderPhoto": [idCardHolderPhotoJpg ToJPEG:1.0]};
    [[[RESTNetworking alloc] initWithURI:uri] PostFile:nil postField:post_files response:^(HttpResponse *response_data) {
        HttpResponseJson *response_json = [[HttpResponseJson alloc] initWithHttpResponse:response_data];
        response(response_json);
    }];
}

// 8.用戶實名認證信息獲取
- (void)RealNameInfo:(void (^)(HttpResponseJson *))response
{
    NSString *uri = @"/user/realname_validate/";
    [[[RESTNetworking alloc] initWithURI:uri] Get:nil response:^(HttpResponseJson *response_data) {
        response(response_data);
    }];
}

// 9.獲取用戶信息
- (void)UserInfo:(void (^)(HttpResponseJson *))response
{
    NSString *uri = @"/user/info/";
    [[[RESTNetworking alloc] initWithURI:uri] Get:nil response:^(HttpResponseJson *response_data) {
        response(response_data);
    }];
}

// 10.用戶頭像上傳
- (void)UserAvatarUpload:(UIImage *)avatar
                response:(void (^)(HttpResponseJson *))response
{
    NSString *uri = @"/user/info/";
    //NSDictionary *params = @{@"Option": @"avatar"};
    NSDictionary *post_files = @{@"Avatar": [avatar ToJPEG:1.0]};
    [[[RESTNetworking alloc] initWithURI:uri] PostFile:nil postField:post_files response:^(HttpResponse *response_data) {
        HttpResponseJson *response_json = [[HttpResponseJson alloc] initWithHttpResponse:response_data];
        response(response_json);
    }];
}

// 11.用戶資料創建及修改
- (void)UserInfoNickname:(NSString *)nickname
                  sexual:(Sexual *)sex
                birthday:(NSDate *)birthday
           jobIndustryID:(NSNumber *)industry_id
             jobPosition:(NSString *)position
               signature:(NSString *)signature
                   place:(NSString *)place
                    GPSX:(NSNumber *)gps_x
                    GPSY:(NSNumber *)gps_y
                response:(void (^)(HttpResponseJson *))response
{
    NSString *uri = @"/user/info/";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:9];
    if (nickname) {
        [params setObject:nickname forKey:@"NickName"];
    }
    if (sex) {
        NSString *sexual;
        if (*sex == SexualFemale) {
            sexual = @"F";
        } else {
            sexual = @"M";
        }
        [params setObject:sexual forKey:@"Sexual"];
    }
    if (birthday) {
        if (birthday) {
            [params setObject:[birthday StringFromDate] forKey:@"Birthday"];
        }
    }
    if (industry_id) {
        [params setObject:industry_id forKey:@"JobIndustryID"];
    }
    if (position) {
        [params setObject:position forKey:@"JobPosition"];
    }
    if (signature) {
        [params setObject:signature forKey:@"Signature"];
    }
    if (place) {
        [params setObject:place forKey:@"Place"];
    }
    if (gps_x && gps_y) {
        [params setObject:gps_x forKey:@"GPSX"];
        [params setObject:gps_y forKey:@"GPSY"];
    }
    
    [[[RESTNetworking alloc] initWithURI:uri] Patch:params response:^(HttpResponseJson *response_data) {
        response(response_data);
    }];
}

// 12.用戶職業列表獲取
- (void)JobIndustry:(void (^)(HttpResponseJson *))response
{
    NSString *uri = @"/user/job_industry/";
    [[[RESTNetworking alloc] initWithURI:uri] Get:nil response:^(HttpResponseJson *response_data) {
        response(response_data);
    }];
}

@end
