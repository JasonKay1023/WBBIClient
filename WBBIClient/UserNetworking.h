//
//  UserNetworking.h
//  WBBIClient
//
//  Created by 黃韜 on 24/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESTNetworking.h"

typedef enum : NSUInteger {
    GetVerifyCodeTypeRegister,
    GetVerifyCodeTypeChangePasswd,
    GetVerifyCodeTypeChangePhone,
} GetVerifyCodeType;

typedef enum : NSUInteger {
    SexualMale,
    SexualFemale,
} Sexual;

@interface UserNetworking : NSObject

// 2.獲取驗證碼：三種情況──註冊、忘記（更改）密碼、更改手機 OK
- (void)GetVerifyCode:(NSString *)phone
                 type:(GetVerifyCodeType)type
             response:(void (^)(HttpResponseJson *))response;

// 3.用戶註冊 OK
- (void)UserRegister:(NSString *)username
            password:(NSString *)passwd
          verifyCode:(NSString *)code
            response:(void (^)(HttpResponseJson *))response;

// 4.用戶手機更改 OK
- (void)UserPhoneReset:(NSString *)old_phone
              newPhone:(NSString *)new_phone
               vercode:(NSString *)verify_code
              password:(NSString *)password
              response:(void (^)(HttpResponseJson *))response;

// 5.用戶密碼更改 OK
- (void)UserPasswordReset:(NSString *)phone
                  vercode:(NSString *)verify_code
                 password:(NSString *)password
                 response:(void (^)(HttpResponseJson *))response;

// 6.用戶實名認證 OK
- (void)RealNameValidate:(NSString *)realname
          identifyNumber:(NSString *)idNumber
                response:(void (^)(HttpResponseJson *))response;

// 7.用戶實名認證圖片 OK
- (void)RealNamePhotos:(UIImage *)idCardPhotoJpg
     idCardHolderPhoto:(UIImage *)idCardHolderPhotoJpg
              response:(void (^)(HttpResponseJson *))response;

// 8.用戶實名認證信息獲取 OK
- (void)RealNameInfo:(void (^)(HttpResponseJson *))response;

// 9.獲取用戶信息 OK
- (void)UserInfo:(void (^)(HttpResponseJson *))response;

// 10.用戶頭像上傳 OK
- (void)UserAvatarUpload:(UIImage *)avatar
                response:(void (^)(HttpResponseJson *))response;

// 11.用戶資料創建及修改 OK
- (void)UserInfoNickname:(NSString *)nickname
                  sexual:(Sexual *)sex
                birthday:(NSDate *)birthday
           jobIndustryID:(NSNumber *)industry_id
             jobPosition:(NSString *)position
               signature:(NSString *)signature
                   place:(NSString *)place
                    GPSX:(NSNumber *)gps_x
                    GPSY:(NSNumber *)gps_y
                response:(void (^)(HttpResponseJson *))response;

// 12.用戶職業列表獲取 OK
- (void)JobIndustry:(void (^)(HttpResponseJson *))response;

@end
