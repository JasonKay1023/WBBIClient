//
//  IMManager.m
//  EaseMob-IM
//
//  Created by 黃韜 on 3/12/2015.
//  Copyright © 2015 NextApps. All rights reserved.
//

#import "IMManager.h"
#import <UIKit/UIKit.h>
#import <EaseMobSDKFull/EaseMob.h>
#import "IMConstants.h"
#import "EMError+Log.h"
#import "EaseUI.h"
//#import "ApplyViewController.h"

@interface IMManager () <IChatManagerDelegate>
{
    int m_iUnreadMessage;
}

@end

@implementation IMManager

static IMManager *shared_manager = nil;

+ (id)SharedManager
{
    @synchronized(self) {
        if (shared_manager == nil) {
            shared_manager = [[self alloc] init];
        }
    }
    return shared_manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //[[NSNotificationCenter defaultCenter] addObserver:self
        //                                         selector:@selector(UntreatedApplyCount)
        //                                             name:@"setupUntreatedApplyCount"
        //                                           object:nil];
    }
    return self;
}

#pragma mark - IM Initializes

- (void)InitialWithAppKey:(NSString *)appKey
                 apnsCert:(NSString *)certName
{
    [[EaseMob sharedInstance] registerSDKWithAppKey:appKey apnsCertName:certName];
}

- (void)InitialUIWithAppKey:(NSString *)appKey
                   apnsCert:(NSString *)certName
              launchOptions:(NSDictionary *)launchOptions
{
    [[EaseSDKHelper shareHelper] easemobApplication:[UIApplication sharedApplication]
                      didFinishLaunchingWithOptions:launchOptions
                                             appkey:appKey apnsCertName:certName
                                        otherConfig:@{kSDKConfigEnableConsoleLogger: [NSNumber numberWithBool:YES]}];
    // Login & Register State Listner
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(login_state_changed:)
                                                 name:KNOTIFICATION_LOGINCHANGE object:nil];
    [self register_easemob_notification];
    [self login_state_changed:nil];
    
}

- (void)AppDidFinishLauchingWithOption:(NSDictionary *)launchOptions
{
    [[EaseMob sharedInstance] application:[UIApplication sharedApplication]
            didFinishLaunchingWithOptions:launchOptions];
}

- (void)AppDidEnterBackground
{
    [[EaseMob sharedInstance] applicationDidEnterBackground:[UIApplication sharedApplication]];
}

- (void)AppWillEnterForeground
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:[UIApplication sharedApplication]];
}

- (void)AppWillTerminate
{
    [[EaseMob sharedInstance] applicationWillTerminate:[UIApplication sharedApplication]];
}

- (void)AppRemoteNotificationWithDeviceToken:(NSData *)deviceToken
{
    [[EaseMob sharedInstance] application:[UIApplication sharedApplication]didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)AppRemoteNotificationError:(NSError *)error
{
    [[EaseMob sharedInstance] application:[UIApplication sharedApplication]didFailToRegisterForRemoteNotificationsWithError:error];
    NSLog(@"%@", error);
}

#pragma mark - Users' actions

- (void)UserRegisterNewAccount:(NSString *)account
                      password:(NSString *)password
                withCompletion:(void (^)(NSString *username,
                                         NSString *password,
                                         NSError *error))completion
{
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:account password:password withCompletion:^(NSString *username, NSString *password, EMError *error) {
        NSError *ns_error = nil;
        if (error) {
            [error ToConsole];
            ns_error = [error ToError];
        }
        completion(username, password, ns_error);
    } onQueue:nil];
}

- (void)UserLogin:(NSString *)username
         password:(NSString *)password
   withCompletion:(void (^)(NSDictionary *loginInfo,
                            NSError *error))completion
{
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username password:password completion:^(NSDictionary *loginInfo, EMError *error) {
        NSError *ns_error = nil;
        if (error) {
            [error ToConsole];
            ns_error = [error ToError];
        }
        completion(loginInfo, ns_error);
        NSArray * conversations = [[EaseMob sharedInstance].chatManager conversations];
        NSInteger unread_count = 0;
        for (EMConversation *conversation in conversations) {
            unread_count += conversation.unreadMessagesCount;
        }
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:unread_count];
        m_iUnreadMessage = unread_count;
    } onQueue:nil];
}

- (void)UserAutoLogin:(NSString *)username
             password:(NSString *)password
       withCompletion:(void (^)(NSDictionary *loginInfo,
                                NSError *error))completion
{
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username password:password completion:^(NSDictionary *loginInfo, EMError *error) {
        NSError *ns_error = nil;
        if (error) {
            [error ToConsole];
            ns_error = [error ToError];
        } else {
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
        }
        completion(loginInfo, ns_error);
        NSArray * conversations = [[EaseMob sharedInstance].chatManager conversations];
        NSInteger unread_count = 0;
        for (EMConversation *conversation in conversations) {
            unread_count += conversation.unreadMessagesCount;
        }
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:unread_count];
        m_iUnreadMessage = unread_count;
    } onQueue:nil];
}

- (void)UserLogout:(void (^)(NSDictionary *, NSError *))completion
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        NSError *ns_error = nil;
        if (error) {
            [error ToConsole];
            ns_error = [error ToError];
        } else {
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
        }
        completion(info, ns_error);
    } onQueue:nil];
}

- (void)UserLogoutCompletely:(void (^)(NSDictionary *, NSError *))completion
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        NSError *ns_error = nil;
        if (error) {
            [error ToConsole];
            ns_error = [error ToError];
        } else {
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
        }
        completion(info, ns_error);
    } onQueue:nil];
}

//- (NSInteger)UntreatedApplyCount
//{
//    return [[[ApplyViewController shareController] dataSource] count];
//}

- (NSInteger)UnreadMessageCount
{
    return m_iUnreadMessage;
}

#pragma mark - Delegate

- (void)didUnreadMessagesCountChanged
{
    NSArray * conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSInteger unread_count = 0;
    for (EMConversation *conversation in conversations) {
        unread_count += conversation.unreadMessagesCount;
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:unread_count];
    m_iUnreadMessage = unread_count;
}

- (void)didReceiveMessage:(EMMessage *)message
{
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    NSString *local_push_text = NSLocalizedString(@"im.local_notify.default", @"Message received");
    switch (msgBody.messageBodyType) {
        case eMessageBodyType_Text:
        {
            // 收到的文字消息
            NSString *txt = ((EMTextMessageBody *)msgBody).text;
            local_push_text = txt;
            NSLog(@"收到的文字是 txt -- %@",txt);
        }
            break;
        case eMessageBodyType_Image:
        {
            // 得到一个图片消息body
            EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
            local_push_text = NSLocalizedString(@"im.local_notify.image", @"Image received");
            NSLog(@"大图remote路径 -- %@"   ,body.remotePath);
            NSLog(@"大图local路径 -- %@"    ,body.localPath); // // 需要使用sdk提供的下载方法后才会存在
            NSLog(@"大图的secret -- %@"    ,body.secretKey);
            NSLog(@"大图的W -- %f ,大图的H -- %f",body.size.width,body.size.height);
            NSLog(@"大图的下载状态 -- %lu",(unsigned long)body.attachmentDownloadStatus);
            
            
            // 缩略图sdk会自动下载
            NSLog(@"小图remote路径 -- %@"   ,body.thumbnailRemotePath);
            NSLog(@"小图local路径 -- %@"    ,body.thumbnailLocalPath);
            NSLog(@"小图的secret -- %@"    ,body.thumbnailSecretKey);
            NSLog(@"小图的W -- %f ,大图的H -- %f",body.thumbnailSize.width,body.thumbnailSize.height);
            NSLog(@"小图的下载状态 -- %lu",(unsigned long)body.thumbnailDownloadStatus);
        }
            break;
        case eMessageBodyType_Location:
        {
            EMLocationMessageBody *body = (EMLocationMessageBody *)msgBody;
            local_push_text = NSLocalizedString(@"im.local_notify.location", @"Location received");
            NSLog(@"纬度-- %f",body.latitude);
            NSLog(@"经度-- %f",body.longitude);
            NSLog(@"地址-- %@",body.address);
        }
            break;
        case eMessageBodyType_Voice:
        {
            // 音频sdk会自动下载
            EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
            local_push_text = NSLocalizedString(@"im.local_notify.voice", @"Voice received");
            NSLog(@"音频remote路径 -- %@"      ,body.remotePath);
            NSLog(@"音频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在（音频会自动调用）
            NSLog(@"音频的secret -- %@"        ,body.secretKey);
            NSLog(@"音频文件大小 -- %lld"       ,body.fileLength);
            NSLog(@"音频文件的下载状态 -- %lu"   ,(unsigned long)body.attachmentDownloadStatus);
            NSLog(@"音频的时间长度 -- %lu"      ,(long)body.duration);
        }
            break;
        case eMessageBodyType_Video:
        {
            EMVideoMessageBody *body = (EMVideoMessageBody *)msgBody;
            local_push_text = NSLocalizedString(@"im.local_notify.video", @"Video received");
            
            NSLog(@"视频remote路径 -- %@"      ,body.remotePath);
            NSLog(@"视频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
            NSLog(@"视频的secret -- %@"        ,body.secretKey);
            NSLog(@"视频文件大小 -- %lld"       ,body.fileLength);
            NSLog(@"视频文件的下载状态 -- %lu"   ,(unsigned long)body.attachmentDownloadStatus);
            NSLog(@"视频的时间长度 -- %lu"      ,(long)body.duration);
            NSLog(@"视频的W -- %f ,视频的H -- %f", body.size.width, body.size.height);
            
            // 缩略图sdk会自动下载
            NSLog(@"缩略图的remote路径 -- %@"     ,body.thumbnailRemotePath);
            NSLog(@"缩略图的local路径 -- %@"      ,body.thumbnailRemotePath);
            NSLog(@"缩略图的secret -- %@"        ,body.thumbnailSecretKey);
            NSLog(@"缩略图的下载状态 -- %lu"      ,(unsigned long)body.thumbnailDownloadStatus);
        }
            break;
        case eMessageBodyType_File:
        {
            EMFileMessageBody *body = (EMFileMessageBody *)msgBody;
            local_push_text = NSLocalizedString(@"im.local_notify.file", @"Image received");
            NSLog(@"文件remote路径 -- %@"      ,body.remotePath);
            NSLog(@"文件local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
            NSLog(@"文件的secret -- %@"        ,body.secretKey);
            NSLog(@"文件文件大小 -- %lld"       ,body.fileLength);
            NSLog(@"文件文件的下载状态 -- %lu"   ,(unsigned long)body.attachmentDownloadStatus);
        }
            break;
            
        default:
            break;
    }
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.alertBody = local_push_text;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    NSLog(@"%ld", (long)[self UnreadMessageCount]);
    
}

#pragma mark - Private methods

- (void)login_state_changed:(NSNotification *)notification
{
    //UINavigationController *navigationController = nil;
    
    //BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
    //BOOL loginSuccess = [notification.object boolValue];
    
    //if (isAutoLogin || loginSuccess) {//登陆成功加载主窗口控制器
        //加载申请通知的数据
#warning The world most foolish way to do that.
        //[[ApplyViewController shareController] loadDataSourceFromLocalDB];
        //if (self.mainController == nil) {
        //    self.mainController = [[MainViewController alloc] init];
        //    navigationController = [[UINavigationController alloc] initWithRootViewController:self.mainController];
        //}else{
        //    navigationController  = self.mainController.navigationController;
        //}
        // 环信UIdemo中有用到Parse，您的项目中不需要添加，可忽略此处
        //[self initParse];
    //}
    //else{//登陆失败加载登陆页面控制器
        //self.mainController = nil;
        //
        //LoginViewController *loginController = [[LoginViewController alloc] init];
        //navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
        //[self clearParse];
    //}
    
    //设置7.0以下的导航栏
    //if ([UIDevice currentDevice].systemVersion.floatValue < 7.0){
    //    navigationController.navigationBar.barStyle = UIBarStyleDefault;
    //    [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"titleBar"]
    //                                             forBarMetrics:UIBarMetricsDefault];
    //    [navigationController.navigationBar.layer setMasksToBounds:YES];
    //}
    
    //self.window.rootViewController = navigationController;
}

- (void)register_easemob_notification
{
    [self unregister_easemob_notification];
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        UIUserNotificationType notification_types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notification_types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType notification_types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notification_types];
    }
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unregister_easemob_notification
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)login_process
{
    [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
}

@end
