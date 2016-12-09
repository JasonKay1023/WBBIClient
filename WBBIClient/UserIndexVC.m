//
//  UserIndexVC.m
//  WBBIClient
//
//  Created by 黃韜 on 18/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "UserIndexVC.h"
#import <MJExtension.h>
#import <AFOAuth2Manager/AFOAuth2Manager.h>
#import "UIView+Style.h"
#import "AppConstants.h"
#import "ActionSheetHandler.h"
#import "ImagePickerHandler.h"
#import "UIViewController+ProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "PopoverHandler.h"
#import "DatePickerVC.h"
#import "UserNetworking.h"
#import "UserModel.h"
#import "TextInputVC.h"
#import "UserJobModifyVC.h"

@interface UserIndexVC () <UITextViewDelegate, PopoverHandlerTerminateDelegate, ImagePickerDelegate, UITextFieldDelegate>
{
    UserModel *m_pUserInfo;
    NSDate *m_pBirthday;
}

@property (strong, nonatomic) UIImage *avatarI;
@property (strong, nonatomic) ActionSheetHandler *avatarPickerAS;
@property (strong, nonatomic) ImagePickerHandler *avatarPickerIP;

@property (strong, nonatomic) IBOutlet UIImageView *AvatarIV;
@property (strong, nonatomic) IBOutlet UITextField *NicknameTF;
@property (strong, nonatomic) IBOutlet UITextView *SignatureTV;
@property (strong, nonatomic) IBOutlet UILabel *BirthdayL;
@property (strong, nonatomic) IBOutlet UILabel *JobL;
@property (strong, nonatomic) IBOutlet UILabel *PhoneL;
@property (strong, nonatomic) IBOutlet UIButton *AvatarB;
@property (strong, nonatomic) IBOutlet UITextField *NickNameTF;
@property (strong, nonatomic) PopoverHandler *birthdayPH;

- (IBAction)AvatarBPressed:(UIButton *)sender;
- (IBAction)BackBBPressed:(id)sender;
- (IBAction)LogoutBPressed:(id)sender;


@end

@implementation UserIndexVC

@synthesize AvatarIV = m_pAvatarIV;
@synthesize NicknameTF = m_pNicknameTF;
@synthesize BirthdayL = m_pBirthdayL;
@synthesize birthdayPH = m_pBirthdayPH;
@synthesize SignatureTV = m_pSignatureTV;
@synthesize JobL = m_pJobL;
@synthesize PhoneL = m_pPhoneL;
@synthesize avatarI = m_pAvatarI;
@synthesize avatarPickerAS = m_pAvatarPickerAS;
@synthesize avatarPickerIP = m_pAvatarPickerIP;

- (void)viewDidLoad {
    
    self.IsEditMode = YES;
    
    [super viewDidLoad];
    
    self.navigationController.navigationBar.clipsToBounds = NO;
    
    self.title = NSLocalizedString(@"个人中心", @"");
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    //style
    [m_pAvatarIV SetCornerRadius: self.view.bounds.size.width * 0.387 * 0.5];
    
    m_pAvatarIV.layer.masksToBounds = YES;
    
    //m_pStarsV.starNumber = 5;
    
    m_pSignatureTV.delegate = self;
    m_pNicknameTF.delegate = self;
    
    // Inits
    m_pBirthdayPH = [[PopoverHandler alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyByDatePicker:)
                                                 name:kDatePickerKey
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyByJobModifyVC:)
                                                 name:kUserJobModifyKey
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyByTextInputVC:)
                                                 name:kTextInputVCKey
                                               object:nil];
    
    // Datas
    [[UserNetworking new] UserInfo:^(HttpResponseJson *response_data) {
        if (response_data.StatusCode == 200) {
            m_pUserInfo = [UserModel mj_objectWithKeyValues:response_data.Result];
            [self refresh_data];
        } else {
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"获取用户信息失败，请稍后重试...", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
        }
    }];
    m_pSignatureTV.text = NSLocalizedString(@"正在加载个性签名...", @"");
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                height = 248;
                break;
            
            case 1:
                height = 50.0;
            
            default:
                break;
        }
    } else if (indexPath.section == 2) {
        height = 158.0;
    } else {
        height = 50.0;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        DatePickerVC *view_controller = [[UIStoryboard storyboardWithName:@"AssistantTools"
                                                                   bundle:nil]
                                         instantiateViewControllerWithIdentifier:@"DatePickerVC"];
#warning Can be better
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        view_controller.preferredContentSize = CGSizeMake(width, 210.0);
        [m_pBirthdayPH Show:view_controller
                   fromRect:cell.bounds
                     inView:cell
               andDirection:WYPopoverArrowDirectionAny
                   animated:YES
                    options:WYPopoverAnimationOptionFade
                 completion:nil];
        m_pBirthdayPH.Delegate = self;
    } else if (indexPath.section == 2) {
        TextInputVC *input_vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]
                                 instantiateViewControllerWithIdentifier:@"TextInputVC"];
        [input_vc Mark:kTextInputVCKey];
        [input_vc Title:NSLocalizedString(@"个性签名", @"") andContent:m_pUserInfo.Signature];
        if (self.navigationController) {
            [self.navigationController pushViewController:input_vc animated:YES];
        } else {
            [self presentViewController:input_vc animated:YES completion:nil];
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    
}

- (IBAction)AvatarBPressed:(UIButton *)sender
{
    m_pAvatarPickerAS = [[ActionSheetHandler alloc] init];
    [m_pAvatarPickerAS ShowActionSheet:self title:NSLocalizedString(@"头像上传", @"") message:NSLocalizedString(@"请上传您的头像", @"") firstTitle:NSLocalizedString(@"从手机相册选择", @"") firstAction:^{
        
        m_pAvatarPickerIP = [[ImagePickerHandler alloc] init];
        [m_pAvatarPickerIP AddImageObserver:self];
        [m_pAvatarPickerIP ShowImagePicker:self
                                fromSource:UIImagePickerControllerSourceTypePhotoLibrary
                                    toSize:CGSizeMake(150.0, 150.0)
                                  andScale:0.0];
        
    } secondTitle:NSLocalizedString(@"拍照", @"") secondAction:^{
        
        m_pAvatarPickerIP = [[ImagePickerHandler alloc] init];
        [m_pAvatarPickerIP AddImageObserver:self];
        [m_pAvatarPickerIP ShowImagePicker:self
                                fromSource:UIImagePickerControllerSourceTypeCamera
                                    toSize:CGSizeMake(150.0, 150.0)
                                  andScale:0.0];
        
    } cancelTitle:NSLocalizedString(@"取消", @"") cancelAction:^{
        
    }];
}

- (IBAction)BackBBPressed:(id)sender
{
    [self.delegate showFront];
}

- (IBAction)LogoutBPressed:(id)sender
{
    [AFOAuthCredential deleteCredentialWithIdentifier:HostName];
    [self ShowProgressHUD:(ProgressHUDDurationTypeSoon1_5s)
                  message:NSLocalizedString(@"注销成功", @"")
                     mode:(ProgressHUDModeTypeText)
    userInteractionEnable:YES];
    [self.delegate showFront];
}

#pragma mark - Internal methods

- (void)refresh_data
{
    if (m_pUserInfo.Avatar) {
        NSString *avatar_url = [BaseURL stringByAppendingString:m_pUserInfo.Avatar];
        [m_pAvatarIV sd_setImageWithURL: [NSURL URLWithString:avatar_url]];
    }
    m_pNicknameTF.text = m_pUserInfo.NickName;
    m_pBirthdayL.text = m_pUserInfo.Birthday;
    m_pJobL.text = m_pUserInfo.JobIndustry;
    m_pPhoneL.text = m_pUserInfo.Phone;
    m_pSignatureTV.text = m_pUserInfo.Signature;
}

#pragma mark - Image picker delegate

- (void)ImagePicker:(ImagePickerHandler *)picker image:(UIImage *)image
{
    if (picker == m_pAvatarPickerIP) {
        m_pAvatarI = image;
    }/*
    [self ShowProgressHUD:ProgressHUDDurationTypeStay
                  message:NSLocalizedString(@"正在修改头像...", @"")
                     mode:ProgressHUDModeTypeIndeterminate
    userInteractionEnable:YES];*/
    
    [[UserNetworking new] UserAvatarUpload:m_pAvatarI response:^(HttpResponseJson *response_data) {
        [self HideProgressHUD];
        if (response_data.StatusCode == 200) {
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"更改成功", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
            [m_pAvatarIV setImage:image];
        } else {
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"更改失败", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
        }
    }];
}

#pragma mark - Date picker

- (void)notifyByDatePicker:(NSNotification *)event
{
    NSDate *new_date = (NSDate *)event.object;
    NSDateFormatter *date_format = [[NSDateFormatter alloc] init];
    [date_format setDateFormat:@"YYYY-MM-dd"];
    m_pBirthdayL.textColor = [UIColor blackColor];
    m_pBirthdayL.text = [date_format stringFromDate:new_date];
    m_pBirthday = new_date;
}

#pragma mark - Text input vc

- (void)notifyByTextInputVC:(NSNotification *)event
{
    NSString *signature = [event.object objectForKey:@"result"];
    /*
    [self ShowProgressHUD:ProgressHUDDurationTypeStay
                  message:NSLocalizedString(@"正在更改个性签名…", @"")
                     mode:ProgressHUDModeTypeIndeterminate
    userInteractionEnable:YES];*/
    
    [[UserNetworking new] UserInfoNickname:nil sexual:nil birthday:nil jobIndustryID:nil jobPosition:nil signature:signature place:nil GPSX:nil GPSY:nil response:^(HttpResponseJson *response_data) {
        
        [self HideProgressHUD];
        if (response_data.StatusCode == 200) {
            
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"更改成功", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
            m_pSignatureTV.text = signature;
            
        } else {
            
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"更改失败", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
            
        }
    }];
}

#pragma mark - Job modify view controller

- (void)notifyByJobModifyVC:(NSNotification *)event
{
    NSNumber *industry_id = [(NSDictionary *)event.object objectForKey:@"industry_id"];
    NSString *industry_name = [(NSDictionary *)event.object objectForKey:@"industry_name"];
    NSString *job_name = [(NSDictionary *)event.object objectForKey:@"job_name"];
    
    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
    format.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *number = industry_id;
    /*
    [self ShowProgressHUD:ProgressHUDDurationTypeStay
                  message:NSLocalizedString(@"正在更改职业…", @"")
                     mode:ProgressHUDModeTypeIndeterminate
    userInteractionEnable:YES];*/
    [[UserNetworking new] UserInfoNickname:nil sexual:nil birthday:nil jobIndustryID:number jobPosition:job_name signature:nil place:nil GPSX:nil GPSY:nil response:^(HttpResponseJson *response_data) {
        [self HideProgressHUD];
        if (response_data.StatusCode == 200) {
            
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"更改成功", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
            m_pJobL.text = [[industry_name stringByAppendingString:@" - "] stringByAppendingString:job_name];
            
        } else {
            
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"更改失败", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
            
        }
    }];
}

#pragma mark - Popover handler terminate delegate

- (void)TerminateHandler:(PopoverHandler *)handler
{
    if (!m_pBirthday) {
        return;
    }
    if ([m_pBirthdayL.text isEqualToString:m_pUserInfo.Birthday]) {
        return;
    }/*
    [self ShowProgressHUD:ProgressHUDDurationTypeStay
                  message:NSLocalizedString(@"正在更改生日…", @"")
                     mode:ProgressHUDModeTypeIndeterminate
    userInteractionEnable:YES];*/
    [[UserNetworking new] UserInfoNickname:nil sexual:nil birthday:m_pBirthday jobIndustryID:nil jobPosition:nil signature:nil place:nil GPSX:nil GPSY:nil response:^(HttpResponseJson *response_data) {
        [self HideProgressHUD];
        if (response_data.StatusCode == 200) {
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"更改成功", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
        } else {
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"更改失败", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
        }
    }];
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text isEqualToString:m_pUserInfo.NickName]) {
        return YES;
    }
    /*
    [self ShowProgressHUD:ProgressHUDDurationTypeStay
                  message:NSLocalizedString(@"正在更改昵称…", @"")
                     mode:ProgressHUDModeTypeDeterminate
    userInteractionEnable:YES];*/
    
    [[UserNetworking new] UserInfoNickname:textField.text sexual:nil birthday:nil jobIndustryID:nil jobPosition:nil signature:nil place:nil GPSX:nil GPSY:nil response:^(HttpResponseJson *response_data) {
        [self HideProgressHUD];
        if (response_data.StatusCode == 200) {
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"更改成功", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
            m_pNicknameTF.text = textField.text;
        } else {
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"更改失败", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
        }
    }];
    return YES;
}

@end
