//
//  IMManager.h
//  EaseMob-IM
//
//  Created by 黃韜 on 3/12/2015.
//  Copyright © 2015 NextApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMManager : NSObject

+ (id)SharedManager;

- (void)InitialWithAppKey:(NSString *)appKey
                 apnsCert:(NSString *)certName;
- (void)InitialUIWithAppKey:(NSString *)appKey
                   apnsCert:(NSString *)certName
              launchOptions:(NSDictionary *)launchOptions;
- (void)AppDidFinishLauchingWithOption:(NSDictionary *)launchOptions;
- (void)AppDidEnterBackground;
- (void)AppWillEnterForeground;
- (void)AppWillTerminate;

- (void)UserRegisterNewAccount:(NSString *)account
                      password:(NSString *)password
                withCompletion:(void (^)(NSString *username,
                                         NSString *password,
                                         NSError *error))completion;

- (void)UserLogin:(NSString *)username
         password:(NSString *)password
   withCompletion:(void (^)(NSDictionary *loginInfo,
                            NSError *error))completion;

- (void)UserAutoLogin:(NSString *)username
             password:(NSString *)password
       withCompletion:(void (^)(NSDictionary *loginInfo,
                                NSError *error))completion;

- (void)UserLogout:(void (^)(NSDictionary *loginInfo,
                             NSError *error))completion;

// won't receive any message from apns
- (void)UserLogoutCompletely:(void (^)(NSDictionary *loginInfo,
                                       NSError *error))completion;

//- (NSInteger)UntreatedApplyCount;

- (NSInteger)UnreadMessageCount;

@end
