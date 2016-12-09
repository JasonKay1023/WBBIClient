//
//  UserInfoModifyVC.m
//  WBBIClient
//
//  Created by 黃韜 on 10/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "UserInfoModifyVC.h"
#import "UIView+Style.h"
#import "UIViewController+ProgressHUD.h"
#import "ActionSheetHandler.h"
#import "ImagePickerHandler.h"
#import "PopoverHandler.h"
#import "DatePickerVC.h"
#import "UserNetworking.h"

@interface UserInfoModifyVC () <ImagePickerDelegate>
{
    BOOL m_bBirthdayPicked;
    NSDate *m_pDatePicked;
    BOOL m_bool_male;
}

@property (strong, nonatomic) ActionSheetHandler *avatarPickerAS;
@property (strong, nonatomic) ImagePickerHandler *avatarPickerIP;
@property (strong, nonatomic) PopoverHandler *birthdayPH;
@property (strong, nonatomic) UIImage *avatarI;

#pragma mark - User interface

@property (strong, nonatomic) IBOutlet UIButton *AvatarB;
@property (strong, nonatomic) IBOutlet UIButton *FemaleB;
@property (strong, nonatomic) IBOutlet UIButton *MaleB;
@property (strong, nonatomic) IBOutlet UITextField *NicknameTF;
@property (strong, nonatomic) IBOutlet UISegmentedControl *SexualSC;
@property (strong, nonatomic) IBOutlet UIButton *BirthdayB;
@property (strong, nonatomic) IBOutlet UILabel *BirthdayL;
@property (strong, nonatomic) IBOutlet UIButton *SubmitB;

- (IBAction)AvatarBPressed:(UIButton *)sender;
- (IBAction)BirthdayBPressed:(UIButton *)sender;
- (IBAction)SubmitBPressed:(UIButton *)sender;
- (IBAction)FemaleBPressed:(UIButton *)sender;
- (IBAction)MaleBPressed:(UIButton *)sender;

@end

@implementation UserInfoModifyVC

@synthesize AvatarB = m_pAvatarB;
@synthesize NicknameTF = m_pNicknameTF;
@synthesize SexualSC = m_pSexualSC;
@synthesize BirthdayB = m_pBirthdayB;
@synthesize BirthdayL = m_pBirthdayL;
@synthesize SubmitB = m_pSubmitB;
@synthesize FemaleB = m_pFemaleB;
@synthesize MaleB = m_pMaleB;

@synthesize avatarPickerAS = m_pAvatarPickerAS;
@synthesize avatarPickerIP = m_pAvatarPickerIP;
@synthesize birthdayPH = m_pBirthdayPH;
@synthesize avatarI = m_pAvatarI;

#pragma mark - Object life cycle

- (void)viewDidLoad
{
    self.IsEditMode = YES;
    m_pAvatarI = nil;
    m_bBirthdayPicked = NO;
    
    [super viewDidLoad];
    
    //Sexual display
    [m_pFemaleB setBackgroundImage:[UIImage imageNamed:@"PBUI-INFO-FILL_female_02.png"]forState:UIControlStateNormal];
    [m_pMaleB setBackgroundImage:[UIImage imageNamed:@"PBUI-INFO-FILL_male_02.png"] forState:UIControlStateNormal];
    
    // User interface styling
    [m_pAvatarB SetCornerRadius:5.0];
    [m_pBirthdayB SetCornerRadius:5.0];
    [m_pSubmitB SetCornerRadius:5.0];
    [m_pFemaleB SetCornerRadius:5.0];
    [m_pMaleB SetCornerRadius:5.0];
    
    // Inits
    m_pBirthdayPH = [[PopoverHandler alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyByDatePicker:)
                                                 name:kDatePickerKey
                                               object:nil];
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
    [m_pAvatarPickerAS ShowActionSheet:self title:NSLocalizedString(@"头像上传", @"") message:NSLocalizedString(@"请上传您的头像", @"") firstTitle:NSLocalizedString(@"从手机相册中选择", @"") firstAction:^{
        
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
}

- (IBAction)SubmitBPressed:(UIButton *)sender
{
    if ([self validate]) {
        Sexual sex = SexualFemale;
        if (m_bool_male) {
            sex = SexualMale;
        }
        [self ShowProgressHUD:ProgressHUDDurationTypeStay message:NSLocalizedString(@"正在提交", @"") mode:ProgressHUDModeTypeIndeterminate userInteractionEnable:YES];
        [[UserNetworking new] UserInfoNickname:m_pNicknameTF.text sexual:&sex birthday:m_pDatePicked jobIndustryID:nil jobPosition:nil signature:nil place:nil GPSX:nil GPSY:nil response:^(HttpResponseJson *response_data) {
            [self HideProgressHUD];
            if (response_data.StatusCode == 200) {
                [self ShowProgressHUD:ProgressHUDDurationTypeStay message:NSLocalizedString(@"正在提交头像", @"") mode:ProgressHUDModeTypeIndeterminate userInteractionEnable:YES];
                [[UserNetworking new] UserAvatarUpload:m_pAvatarI response:^(HttpResponseJson *response_data) {
                    [self HideProgressHUD];
                    if (response_data.StatusCode == 200) {
                        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s message:NSLocalizedString(@"提交成功", @"") mode:ProgressHUDModeTypeText userInteractionEnable:YES];
                        [self next];
                    } else {
                        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s message:NSLocalizedString(@"提交失败", @"") mode:ProgressHUDModeTypeText userInteractionEnable:YES];
                    }
                }];
            } else {
                [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s message:NSLocalizedString(@"提交失败", @"") mode:ProgressHUDModeTypeText userInteractionEnable:YES];
            }
        }];
    } else {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:NSLocalizedString(@"提交失败，请完善个人信息…", @"")
                         mode:ProgressHUDModeTypeText
        userInteractionEnable:YES];
    }
}

- (IBAction)FemaleBPressed:(UIButton *)sender
{
    m_bool_male = NO;
    [m_pFemaleB setBackgroundImage:[UIImage imageNamed:@"PBUI-INFO-FILL_female_01.png"]forState: UIControlStateNormal];
    [m_pMaleB setBackgroundImage:[UIImage imageNamed:@"PBUI-INFO-FILL_male_02.png"] forState: UIControlStateNormal];
}

- (IBAction)MaleBPressed:(UIButton *)sender
{
    m_bool_male = YES;
    [m_pFemaleB setBackgroundImage:[UIImage imageNamed:@"PBUI-INFO-FILL_female_02.png"]forState: UIControlStateNormal];
    [m_pMaleB setBackgroundImage:[UIImage imageNamed:@"PBUI-INFO-FILL_male_01.png"]forState: UIControlStateNormal];
}

/*
- (IBAction)SexSCValueChanged:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
#warning Add Something
        // 女性图片
        
    } else if (sender.selectedSegmentIndex == 1) {
        // 男性图片
        
    }
}*/

#pragma mark - Internal methods

- (BOOL)validate
{
    if (m_pAvatarI && m_pNicknameTF.text.length != 0 && m_bBirthdayPicked) {
        return YES;
    } else {
        return NO;
    }
}

- (void)next
{
    UIViewController *user_info_vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]
                                      instantiateViewControllerWithIdentifier:@"UserPersonalInfoModifyVC"];
    [self.navigationController pushViewController:user_info_vc
                                         animated:YES];
}

#pragma mark - Image picker delegate

- (void)ImagePicker:(ImagePickerHandler *)picker image:(UIImage *)image
{
    if (picker == m_pAvatarPickerIP) {
        [m_pAvatarB setBackgroundImage:image
                              forState:UIControlStateNormal];
        m_pAvatarI = image;
    }
}

#pragma mark - Date picker

- (void)notifyByDatePicker:(NSNotification *)event
{
    NSDate *new_date = (NSDate *)event.object;
    NSDateFormatter *date_format = [[NSDateFormatter alloc] init];
    [date_format setDateFormat:@"YYYY-MM-dd"];
    m_pBirthdayL.textColor = [UIColor blackColor];
    m_pBirthdayL.text = [date_format stringFromDate:new_date];
    m_bBirthdayPicked = YES;
    m_pDatePicked = event.object;
}

@end
