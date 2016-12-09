//
//  UserIndexModifyVC.m
//  WBBIClient
//
//  Created by 黃韜 on 2015/11/14.
//  Copyright © 2015年 WBB. All rights reserved.
//

#import "UserIndexModifyVC.h"
#import "UIView+Style.h"
#import "ActionSheetHandler.h"
#import "ImagePickerHandler.h"
#import "DatePickerVC.h"
#import "UserJobModifyVC.h"
#import "PopoverHandler.h"
#import "TextInputVC.h"
#import "NSDate+String.h"
#import "UIViewController+ProgressHUD.h"
#import "UserNetworking.h"

@interface UserIndexModifyVC () <ImagePickerDelegate, PopoverHandlerTerminateDelegate>

@property (strong, nonatomic) IBOutlet UIButton *AvatarB;
@property (strong, nonatomic) IBOutlet UITextField *NicknameTF;
@property (strong, nonatomic) IBOutlet UIButton *AddressB;
@property (strong, nonatomic) IBOutlet UIButton *BirthdayB;
@property (strong, nonatomic) IBOutlet UILabel *BirthdayL;
@property (strong, nonatomic) IBOutlet UIButton *JobB;
@property (strong, nonatomic) IBOutlet UILabel *JobL;
@property (strong, nonatomic) IBOutlet UIButton *PhoneB;
@property (strong, nonatomic) IBOutlet UILabel *PhoneL;
@property (strong, nonatomic) IBOutlet UIButton *SignatureB;
@property (strong, nonatomic) IBOutlet UITextView *SignatureTV;

@property (strong, nonatomic) ActionSheetHandler *avatarPickerAS;
@property (strong, nonatomic) ImagePickerHandler *avatarPickerIP;
@property (strong, nonatomic) PopoverHandler *birthdayPH;

@property (strong, nonatomic) NSDate *birthday;

- (IBAction)AvatarBPressed:(UIButton *)sender;
//- (IBAction)AddressBPressed:(UIButton *)sender;
- (IBAction)BirthdayBPressed:(UIButton *)sender;
- (IBAction)JobBPressed:(UIButton *)sender;
- (IBAction)PhoneBPressed:(UIButton *)sender;
- (IBAction)SignatureBPressed:(UIButton *)sender;

@end

@implementation UserIndexModifyVC

@synthesize AvatarB = m_pAvatarB;
@synthesize NicknameTF = m_pNicknameTF;
@synthesize AddressB = m_pAddressB;
@synthesize BirthdayB = m_pBirthdayB;
@synthesize BirthdayL = m_pBirthdayL;
@synthesize JobB = m_pJobB;
@synthesize JobL = m_pJobL;
@synthesize PhoneB = m_pPhoneB;
@synthesize PhoneL = m_pPhoneL;
@synthesize SignatureB = m_pSignatureB;
@synthesize SignatureTV = m_pSignatureTV;

@synthesize avatarPickerAS = m_pAvatarPickerAS;
@synthesize avatarPickerIP = m_pAvatarPickerIP;
@synthesize birthdayPH = m_pBirthdayPH;

@synthesize birthday = m_pBirthday;

#pragma mark - Object life cycle

- (void)test
{
    m_pBirthday = [[NSDate alloc] initWithTimeIntervalSinceNow:-3600000];
}

- (void)viewDidLoad
{
    self.IsEditMode = YES;
    
    [super viewDidLoad];
    
    [self test];
    
    // User interface styling
    [m_pAvatarB SetCornerRadius:5.0];
    [m_pAddressB SetCornerRadius:5.0];
    [m_pBirthdayB SetCornerRadius:5.0];
    [m_pJobB SetCornerRadius:5.0];
    [m_pPhoneB SetCornerRadius:5.0];
    [m_pSignatureB SetCornerRadius:5.0];
    
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
    
    // Data loading
    
    m_pBirthdayL.text = [m_pBirthday StringFromDate];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    if (m_pAvatarPickerIP != nil) {
        [m_pAvatarPickerIP RemoveImageObserver:self];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - User interface

- (IBAction)AvatarBPressed:(UIButton *)sender
{
    m_pAvatarPickerAS = [[ActionSheetHandler alloc] init];
    [m_pAvatarPickerAS ShowActionSheet:self title:NSLocalizedString(@"UserIndexModifyVC.PickAvatar", @"") message:NSLocalizedString(@"UserIndexModifyVC.PickAvatarMessage", @"") firstTitle:NSLocalizedString(@"UserIndexModifyVC.FromCamera", @"") firstAction:^{
        
        m_pAvatarPickerIP = [[ImagePickerHandler alloc] init];
        [m_pAvatarPickerIP AddImageObserver:self];
        [m_pAvatarPickerIP ShowImagePicker:self
                                fromSource:UIImagePickerControllerSourceTypeCamera
                                    toSize:CGSizeMake(150.0, 150.0)
                                  andScale:0.0];
        
    } secondTitle:NSLocalizedString(@"UserIndexModifyVC.FromAlbum", @"") secondAction:^{
        
        m_pAvatarPickerIP = [[ImagePickerHandler alloc] init];
        [m_pAvatarPickerIP AddImageObserver:self];
        [m_pAvatarPickerIP ShowImagePicker:self
                                fromSource:UIImagePickerControllerSourceTypePhotoLibrary
                                    toSize:CGSizeMake(150.0, 150.0)
                                  andScale:0.0];
        
    } cancelTitle:NSLocalizedString(@"UserIndexModifyVC.PickCancel", @"") cancelAction:^{
        
    }];
}

- (IBAction)BirthdayBPressed:(UIButton *)sender
{
    DatePickerVC *view_controller = [[UIStoryboard storyboardWithName:@"AssistantTools"
                                                               bundle:nil]
                                     instantiateViewControllerWithIdentifier:@"DatePickerVC"];
#warning Can be better
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view_controller.preferredContentSize = CGSizeMake(width, 210.0);
    [m_pBirthdayPH Show:view_controller
               fromRect:m_pBirthdayL.bounds
                 inView:m_pBirthdayL
           andDirection:WYPopoverArrowDirectionAny
               animated:YES
                options:WYPopoverAnimationOptionFade
             completion:nil];
    m_pBirthdayPH.Delegate = self;
    [view_controller SetDate:m_pBirthday];
}

- (IBAction)JobBPressed:(UIButton *)sender
{
    UserJobModifyVC *user_job_vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]
                                    instantiateViewControllerWithIdentifier:@"UserJobModifyVC"];
    if (self.navigationController != nil) {
        [self.navigationController pushViewController:user_job_vc animated:YES];
    } else {
        [self presentViewController:user_job_vc
                           animated:YES
                         completion:nil];
    }
}

- (IBAction)PhoneBPressed:(UIButton *)sender
{
    TextInputVC *view_controller = [[UIStoryboard storyboardWithName:@"User" bundle:nil]
                                    instantiateViewControllerWithIdentifier:@"UserPhoneModifyVC"];
    //[view_controller Mark:@"phone"];
    //[view_controller Title:@"Hello" andContent:@"Thank you"];
    if (self.navigationController != nil) {
        [self.navigationController pushViewController:view_controller animated:YES];
    } else {
        [self presentViewController:view_controller animated:YES completion:nil];
    }
}

- (IBAction)SignatureBPressed:(UIButton *)sender
{
    
}

#pragma mark - Image picker delegate

- (void)ImagePicker:(ImagePickerHandler *)picker image:(UIImage *)image
{
    if (picker == m_pAvatarPickerIP) {
        [m_pAvatarB setBackgroundImage:image
                              forState:UIControlStateNormal];
    }
}

#pragma mark - Popover Handler Terminate Delegate

- (void)TerminateHandler:(PopoverHandler *)handler
{
    [self ShowProgressHUD:ProgressHUDDurationTypeStay
                  message:NSLocalizedString(@"UserIndexModifyVC.BirthdaySubmitting", @"")
                     mode:ProgressHUDModeTypeIndeterminate
    userInteractionEnable:YES];
    [[UserNetworking new] UserInfoNickname:nil sexual:nil birthday:m_pBirthday jobIndustryID:nil jobPosition:nil signature:nil place:nil GPSX:nil GPSY:nil response:^(HttpResponseJson *response_data) {
        [self HideProgressHUD];
        if (response_data.StatusCode == 200) {
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"UserIndexModifyVC.Successfully", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
        } else {
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"UserIndexModifyVC.Failed", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
        }
    }];
}

#pragma mark - Date picker

- (void)notifyByDatePicker:(NSNotification *)event
{
    NSDate *new_date = (NSDate *)event.object;
    m_pBirthday = new_date;
    NSDateFormatter *date_format = [[NSDateFormatter alloc] init];
    [date_format setDateFormat:@"YYYY-MM-dd"];
    m_pBirthdayL.textColor = [UIColor blackColor];
    m_pBirthdayL.text = [date_format stringFromDate:new_date];
}

#pragma mark - Job modify view controller

- (void)notifyByJobModifyVC:(NSNotification *)event
{
    //NSString *industry_id = [(NSDictionary *)event.object objectForKey:@"industry_id"];
    NSString *industry_name = [(NSDictionary *)event.object objectForKey:@"industry_name"];
    NSString *job_name = [(NSDictionary *)event.object objectForKey:@"job_name"];
    m_pJobL.text = [[industry_name stringByAppendingString:@" - "] stringByAppendingString:job_name];
    m_pJobL.textColor = [UIColor blackColor];
}

@end
