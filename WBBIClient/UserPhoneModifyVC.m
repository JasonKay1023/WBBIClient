//
//  UserPhoneModifyVC.m
//  WBBIClient
//
//  Created by 黃韜 on 19/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "UserPhoneModifyVC.h"
#import "UIView+Style.h"
#import "UserNetworking.h"
#import "UIViewController+ProgressHUD.h"

@interface UserPhoneModifyVC () <UITextFieldDelegate>
{
    //NSInteger passwdTFCount;
    NSInteger getVerifyCodeTimeOut;
}

@property (strong, nonatomic) IBOutlet UITextField *PasswordTF;
@property (strong, nonatomic) IBOutlet UITextField *OldPhoneTF;
@property (strong, nonatomic) IBOutlet UITextField *NewPhoneTF;
@property (strong, nonatomic) IBOutlet UITextField *VerifyCodeTF;
@property (strong, nonatomic) IBOutlet UIButton *GetVerifyCodeB;
@property (strong, nonatomic) IBOutlet UILabel *GetVerifyCodeL;
@property (strong, nonatomic) IBOutlet UIButton *SubmitB;

- (IBAction)GetVerifyCodeBPressed:(UIButton *)sender;
- (IBAction)SubmitBPressed:(UIButton *)sender;

@end

@implementation UserPhoneModifyVC

@synthesize PasswordTF = m_pPasswordTF;
@synthesize OldPhoneTF = m_pOldPhoneTF;
@synthesize NewPhoneTF = m_pNewPhoneTF;
@synthesize VerifyCodeTF = m_pVerifyCodeTF;
@synthesize GetVerifyCodeB = m_pGetVerifyCodeB;
@synthesize GetVerifyCodeL = m_pGetVerifyCodeL;
@synthesize SubmitB = m_pSubmitB;

#pragma mark - Object life cycle

- (void)viewDidLoad
{
    self.IsEditMode = YES;
    
    [super viewDidLoad];
    //
    [m_pGetVerifyCodeB setBackgroundImage:[UIImage imageNamed:@"PBUI_PhoneModify_-input_02"] forState:UIControlStateNormal];
    [m_pGetVerifyCodeB setImage:[UIImage imageNamed:@"PBUI_PhoneModify_-input_02"] forState:UIControlStateNormal];
    
    // User interface styling
    [m_pGetVerifyCodeB SetCornerRadius:5.0];
    [m_pSubmitB SetCornerRadius:5.0];
    
    // Text field delegate
    m_pPasswordTF.delegate = self;
    m_pOldPhoneTF.delegate = self;
    m_pNewPhoneTF.delegate = self;
    m_pVerifyCodeTF.delegate = self;

}

- (void)viewDidAppear:(BOOL)animated
{
    [m_pPasswordTF becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self HideKeyboard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - User interface

- (IBAction)GetVerifyCodeBPressed:(UIButton *)sender
{
    [m_pGetVerifyCodeB setBackgroundImage:[UIImage imageNamed:@"PBUI_PhoneModify_-input_01.png"] forState:UIControlStateNormal];
    [self send_verify_code];
}

- (IBAction)SubmitBPressed:(UIButton *)sender
{
    if ([self validate_input]) {
        [self send_request];
    }
}

#pragma mark - Internal methods

- (void)send_verify_code
{
    if (m_pNewPhoneTF.text.length != 11) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:NSLocalizedString(@"您输入的手机号码无效，请重新输入…", @"")
                         mode:ProgressHUDModeTypeText
        userInteractionEnable:YES];
    }
    if (!m_pGetVerifyCodeB.enabled) {
        return;
    }
    getVerifyCodeTimeOut = 60;
    m_pGetVerifyCodeB.enabled = NO;
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(get_verify_code_label_update:)
                                   userInfo:nil
                                    repeats:YES];
    [m_pVerifyCodeTF becomeFirstResponder];
    [self ShowProgressHUD:ProgressHUDDurationTypeStay
                  message:NSLocalizedString(@"正在发送验证码…", @"")
                     mode:ProgressHUDModeTypeText
    userInteractionEnable:YES];
    [[UserNetworking new] GetVerifyCode:m_pNewPhoneTF.text type:GetVerifyCodeTypeChangePhone response:^(HttpResponseJson *response_json) {
        [self HideProgressHUD];
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:response_json.Reason
                         mode:ProgressHUDModeTypeText
        userInteractionEnable:YES];
        if (response_json.StatusCode == 201) {
            // OK
        } else if (response_json.StatusCode == 429) {
            // Time too quick
        } else {
            if (getVerifyCodeTimeOut != 0) {
                getVerifyCodeTimeOut = 1;
            }
        }
    }];
}

- (void)get_verify_code_label_update:(NSTimer *)timer
{
    if (getVerifyCodeTimeOut == 0) {
        m_pGetVerifyCodeB.enabled = YES;
        m_pGetVerifyCodeL.text = NSLocalizedString(@"", @"");
        [m_pGetVerifyCodeB setBackgroundImage:[UIImage imageNamed:@"PBUI_PhoneModify_-input_02"] forState:UIControlStateNormal];
        [m_pGetVerifyCodeB setImage:[UIImage imageNamed:@"PBUI_PhoneModify_-input_02"] forState:UIControlStateNormal];
        [timer invalidate];
    } else {
        m_pGetVerifyCodeB.enabled = NO;
        getVerifyCodeTimeOut -= 1;
        m_pGetVerifyCodeL.text = [NSString stringWithFormat:@"%ld", (long)getVerifyCodeTimeOut];
       [m_pGetVerifyCodeB setBackgroundImage:[UIImage imageNamed:@"PBUI_PhoneModify_-input_01"] forState:UIControlStateNormal];
        [m_pGetVerifyCodeB setImage:[UIImage imageNamed:@"PBUI_PhoneModify_-input_01"] forState:UIControlStateNormal];

    }
}

- (BOOL)validate_input
{
    if (m_pNewPhoneTF.text.length != 11 || m_pOldPhoneTF.text.length != 11) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:NSLocalizedString(@"您输入的手机号码无效，请重新输入…", @"")
                         mode:ProgressHUDModeTypeText
        userInteractionEnable:YES];
        return NO;
    }
    if (m_pPasswordTF.text.length < 6 || m_pPasswordTF.text.length > 20) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:NSLocalizedString(@"您输入的用户密码无效，请重新输入…", @"")
                         mode:ProgressHUDModeTypeText
        userInteractionEnable:YES];
        return NO;
    }
    if ([m_pOldPhoneTF.text isEqualToString:m_pNewPhoneTF.text]) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:NSLocalizedString(@"您输入的新手机和旧手机一致，请重新检查…", @"")
                         mode:ProgressHUDModeTypeText
        userInteractionEnable:YES];
        return NO;
    }
    if (m_pVerifyCodeTF.text.length != 4) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:NSLocalizedString(@"您输入的验证码有误，请重新输入…", @"")
                         mode:ProgressHUDModeTypeText
        userInteractionEnable:YES];
        return NO;
    }
    return YES;
}

- (void)send_request
{
    [self ShowProgressHUD:ProgressHUDDurationTypeStay
                  message:NSLocalizedString(@"正在提交…", @"")
                     mode:ProgressHUDModeTypeIndeterminate
    userInteractionEnable:YES];
    /*
    [[UserNetworking new] UserRegister:m_pPhoneTF.text password:m_pPasswordTF.text verifyCode:m_pVerifyCodeTF.text response:^(HttpResponseJson *response_json) {
        
        [self HideProgressHUD];
        
        if (response_json.StatusCode == 201) {
            [self register_successfully];
        } else {
            [self HideProgressHUD];
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:response_json.Reason
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
        }
        
    }];*/
    [[UserNetworking new] UserPhoneReset:m_pOldPhoneTF.text newPhone:m_pNewPhoneTF.text vercode:m_pVerifyCodeTF.text password:m_pPasswordTF.text response:^(HttpResponseJson *response_data) {
        [self HideProgressHUD];
        
        if (response_data.StatusCode == 200) {
            [self register_successfully];
        } else {
            [self HideProgressHUD];
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:response_data.Reason
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
        }
    }];
}

- (void)register_successfully
{
    [self ShowProgressHUD:ProgressHUDDurationTypeStay
                  message:NSLocalizedString(@"正在登录…", @"")
                     mode:ProgressHUDModeTypeIndeterminate
    userInteractionEnable:YES];
    [[RESTNetworking new] Authorization:m_pNewPhoneTF.text password:m_pPasswordTF.text response:^(HttpResponse *response_object) {
        
        [self HideProgressHUD];
        
        if (response_object.StatusCode == 200) {
            
            [self login_successfully];
            
        } else if (response_object.StatusCode == 401) {
            
            [self login_failure];
            
        }
        
    }];
}

- (void)login_successfully
{
    [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                  message:NSLocalizedString(@"登录成功", @"")
                     mode:ProgressHUDModeTypeText
    userInteractionEnable:YES];
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    }
}

- (void)login_failure
{
    [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                  message:NSLocalizedString(@"登录失败，请稍后重试…", @"")
                     mode:ProgressHUDModeTypeText
    userInteractionEnable:YES];
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == m_pPasswordTF) {
        if (textField.text.length < 6 || textField.text.length > 20) {
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"您输入的用户密码无效，请重新输入…", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
        }
        [m_pOldPhoneTF becomeFirstResponder];
    } else if (textField == m_pOldPhoneTF) {
        [m_pNewPhoneTF becomeFirstResponder];
    } else if (textField == m_pNewPhoneTF) {
        [m_pVerifyCodeTF becomeFirstResponder];
    } else if (textField == m_pVerifyCodeTF) {
        [self HideKeyboard];
    }
    
    return NO;
}

@end
