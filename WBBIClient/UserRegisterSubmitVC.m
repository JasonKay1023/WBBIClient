//
//  UserRegisterSubmitVC.m
//  WBBIClient
//
//  Created by 黃韜 on 9/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "UserRegisterSubmitVC.h"
#import "UIView+Style.h"
#import "UserNetworking.h"
#import "UIViewController+ProgressHUD.h"

@interface UserRegisterSubmitVC () <UITextFieldDelegate>
{
    //NSInteger passwdTFCount;
    NSInteger getVerifyCodeTimeOut;
}

#pragma mark - User interface

@property (strong, nonatomic) IBOutlet UITextField *PhoneTF;
@property (strong, nonatomic) IBOutlet UITextField *PasswordTF;
@property (strong, nonatomic) IBOutlet UITextField *ConfirmTF;
@property (strong, nonatomic) IBOutlet UITextField *VerifyCodeTF;
@property (strong, nonatomic) IBOutlet UIButton *GetVerifyCodeB;
@property (strong, nonatomic) IBOutlet UILabel *GetVerifyCodeL;
@property (strong, nonatomic) IBOutlet UIButton *RegisterB;
@property (strong, nonatomic) IBOutlet UIButton *BackB;

- (IBAction)GetVerifyCodeBPressed:(UIButton *)sender;
- (IBAction)RegisterBPressed:(UIButton *)sender;
- (IBAction)BackBPressed:(UIButton *)sender;

@end

@implementation UserRegisterSubmitVC

@synthesize PhoneTF = m_pPhoneTF;
@synthesize PasswordTF = m_pPasswordTF;
@synthesize ConfirmTF = m_pConfirmTF;
@synthesize VerifyCodeTF = m_pVerifyCodeTF;
@synthesize GetVerifyCodeB = m_pGetVerifyCodeB;
@synthesize GetVerifyCodeL = m_pGetVerifyCodeL;
@synthesize RegisterB = m_pRegisterB;
@synthesize BackB = m_pBackB;

#pragma mark - Object life cycle

- (void)viewDidLoad
{
    self.IsEditMode = YES;
    
    [super viewDidLoad];
    
    //navigation_bar sHidden
    [self.navigationController.navigationBar setHidden:YES];
    
    //
    [m_pGetVerifyCodeB setBackgroundImage:[UIImage imageNamed:@"PBUI-REGISTER_Captcha_Button_01"] forState:UIControlStateNormal];
    [m_pGetVerifyCodeB setImage:[UIImage imageNamed:@"PBUI-REGISTER_Captcha_Button_01"] forState:UIControlStateNormal];
    
    // User interface styling
    [m_pGetVerifyCodeB SetCornerRadius:5.0];
    [m_pRegisterB SetCornerRadius:5.0];
    [m_pBackB SetCornerRadius:5.0];
    
    // Text field delegate
    m_pPhoneTF.delegate = self;
    m_pPasswordTF.delegate = self;
    m_pConfirmTF.delegate = self;
    m_pVerifyCodeTF.delegate = self;
    m_pPhoneTF.attributedPlaceholder = [[NSAttributedString alloc]
                                        initWithString:NSLocalizedString(@"请输入手机号", @"")
                                        attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    m_pPasswordTF.attributedPlaceholder = [[NSAttributedString alloc]
                                           initWithString:NSLocalizedString(@"请输入密码", @"")
                                           attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    m_pConfirmTF.attributedPlaceholder = [[NSAttributedString alloc]
                                          initWithString:NSLocalizedString(@"请重复密码", @"")
                                          attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    m_pVerifyCodeTF.attributedPlaceholder = [[NSAttributedString alloc]
                                             initWithString:NSLocalizedString(@"请输入验证码", @"")
                                             attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    /*
    [m_pPhoneTF addTarget:self
                   action:@selector(textFieldValueChanged:)
         forControlEvents:UIControlEventAllEditingEvents];
    passwdTFCount = 0;
    */
}

- (void)viewDidAppear:(BOOL)animated
{
    [m_pPhoneTF becomeFirstResponder];
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
    [self send_verify_code];
}

- (IBAction)RegisterBPressed:(UIButton *)sender
{
    if ([self validate_input]) {
        [self send_request];
    }
}

- (IBAction)BackBPressed:(UIButton *)sender
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Internal methods

- (void)send_verify_code
{
    if (m_pPhoneTF.text.length != 11) {
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
                  message:NSLocalizedString(@"正在发送验证码 请稍后…", @"")
                     mode:ProgressHUDModeTypeText
    userInteractionEnable:YES];
    [[UserNetworking new] GetVerifyCode:m_pPhoneTF.text type:GetVerifyCodeTypeRegister response:^(HttpResponseJson *response_json) {
        [self HideProgressHUD];
        if (response_json.StatusCode == 201) {
            
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"获取验证码成功", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
            
        } else if (response_json.StatusCode == 429) {
            
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"获取得太频繁", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
            
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
        [m_pGetVerifyCodeB setBackgroundImage:[UIImage imageNamed:@"PBUI-REGISTER_Captcha_Button_01"] forState:UIControlStateNormal];
        [m_pGetVerifyCodeB setImage:[UIImage imageNamed:@"PBUI-REGISTER_Captcha_Button_01"] forState:UIControlStateNormal];
        [timer invalidate];
    } else {
        m_pGetVerifyCodeB.enabled = NO;
        getVerifyCodeTimeOut -= 1;
        m_pGetVerifyCodeL.text = [NSString stringWithFormat:@"%ld", (long)getVerifyCodeTimeOut];
        [m_pGetVerifyCodeB setBackgroundImage:[UIImage imageNamed:@"PBUI-REGISTER_Captcha_Button_02"] forState:UIControlStateNormal];
         [m_pGetVerifyCodeB setImage:[UIImage imageNamed:@"PBUI-REGISTER_Captcha_Button_02"] forState:UIControlStateNormal];}
}

- (BOOL)validate_input
{
    if (m_pPhoneTF.text.length != 11) {
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
    if (![m_pPasswordTF.text isEqualToString:m_pConfirmTF.text]) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:NSLocalizedString(@"您输入的用户密码不一致，请重新检查…", @"")
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
                  message:NSLocalizedString(@"正在注册，请稍后…", @"")
                     mode:ProgressHUDModeTypeIndeterminate
    userInteractionEnable:YES];
    [[UserNetworking new] UserRegister:m_pPhoneTF.text password:m_pPasswordTF.text verifyCode:m_pVerifyCodeTF.text response:^(HttpResponseJson *response_json) {
        
        [self HideProgressHUD];
        
        if (response_json.StatusCode == 201) {
            [self register_successfully];
        } else {
            [self HideProgressHUD];
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"注册失败", @"")
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
    [[RESTNetworking new] Authorization:m_pPhoneTF.text password:m_pPasswordTF.text response:^(HttpResponse *response_object) {
        
        [self HideProgressHUD];
        
        if (response_object.StatusCode == 200) {
            
            [self login_successfully];
            
        } else {
            
            [self login_failure];
            
        }
        
    }];
}

- (void)login_successfully
{
    [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                  message:NSLocalizedString(@"登陆成功…", @"")
                     mode:ProgressHUDModeTypeText
    userInteractionEnable:YES];
    UIViewController *user_info_vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]
                                      instantiateViewControllerWithIdentifier:@"UserIdentityValidateVC"];
    [self.navigationController pushViewController:user_info_vc
                                         animated:YES];
}

- (void)login_failure
{
    [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                  message:NSLocalizedString(@"登陆失败，请稍后重试…", @"")
                     mode:ProgressHUDModeTypeText
    userInteractionEnable:YES];
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == m_pPhoneTF) {
        [m_pPasswordTF becomeFirstResponder];
    } else if (textField == m_pPasswordTF) {
        if (textField.text.length >= 6 && textField.text.length <= 20) {
            [m_pConfirmTF becomeFirstResponder];
        } else {
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"您输入的用户密码无效，请重新输入…", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
        }
    } else if (textField == m_pConfirmTF) {
        if ([textField.text isEqualToString:m_pPasswordTF.text]) {
            [m_pVerifyCodeTF becomeFirstResponder];
            [self send_verify_code];
        } else {
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"您输入的用户密码不一致，请重新检查…", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
        }
    } else if (textField == m_pVerifyCodeTF) {
        
    }
    
    return NO;
}

/*
- (void)textFieldValueChanged:(id)sender
{
    UITextField *text_field = (UITextField *)sender;
    if (text_field == m_pPhoneTF) {*//*
                                    if (text_field.text.length == 13) {
                                    [m_pPasswdTF becomeFirstResponder];
                                    return;
                                    }*//*
        if (passwdTFCount > (text_field.text.length)) {
            // Delete character
            if (passwdTFCount == 5 || passwdTFCount == 10) {
                NSMutableString *tmp_string = [NSMutableString stringWithFormat:@"%@", text_field.text];
                text_field.text = [tmp_string substringToIndex:passwdTFCount - 2];
            }
        } else if (passwdTFCount < ((UITextField *)sender).text.length) {
            // Add character
            if (passwdTFCount == 3 || passwdTFCount == 8) {
                NSMutableString *tmp_string = [NSMutableString stringWithFormat:@"%@", text_field.text];
                [tmp_string insertString:@"-" atIndex:passwdTFCount];
                text_field.text = tmp_string;
            }
        }
        passwdTFCount = text_field.text.length;
    }
}
*/
@end
