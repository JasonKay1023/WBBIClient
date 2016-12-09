//
//  UserForgotPasswdVC.m
//  WBBIClient
//
//  Created by 黃韜 on 9/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "UserForgotPasswdVC.h"
#import "UIView+Style.h"
#import "UIViewController+ProgressHUD.h"
#import "UserNetworking.h"

@interface UserForgotPasswdVC () <UITextFieldDelegate>
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
@property (strong, nonatomic) IBOutlet UIButton *FindBackB;

- (IBAction)GetVerifyCodeBPressed:(UIButton *)sender;
- (IBAction)FindBackBPressed:(UIButton *)sender;

@end

@implementation UserForgotPasswdVC

@synthesize PhoneTF = m_pPhoneTF;
@synthesize PasswordTF = m_pPasswdTF;
@synthesize ConfirmTF = m_pConfirmTF;
@synthesize VerifyCodeTF = m_pVerifyCodeTF;
@synthesize GetVerifyCodeB = m_pGetCodeB;
@synthesize GetVerifyCodeL = m_pGetCodeL;
@synthesize FindBackB = m_pFindBackB;

#pragma mark - Object life cycle

- (void)viewDidLoad
{
    self.IsEditMode = YES;
    
    [super viewDidLoad];
    
    //
    [m_pGetCodeB setBackgroundImage:[UIImage imageNamed:@"PBUI-PASSWORD_captcha_botton_01.png"] forState:UIControlStateNormal];
    [m_pGetCodeB setImage:[UIImage imageNamed:@"PBUI-PASSWORD_captcha_botton_01.png"] forState:UIControlStateNormal];
    
    // User interface styling
    [m_pGetCodeB SetCornerRadius:5.0];
    [m_pFindBackB SetCornerRadius:5.0];
    
    // Text field delegate
    m_pPhoneTF.delegate = self;
    m_pPasswdTF.delegate = self;
    m_pConfirmTF.delegate = self;
    m_pVerifyCodeTF.delegate = self;
    
    m_pPhoneTF.attributedPlaceholder = [[NSAttributedString alloc]
                                           initWithString:NSLocalizedString(@"请输入手机号", @"")
                                           attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    m_pPasswdTF.attributedPlaceholder = [[NSAttributedString alloc]
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
                   action:@selector(phone_value_changed:)
         forControlEvents:UIControlEventAllEditingEvents];
    [m_pVerifyCodeTF addTarget:self
                        action:@selector(verify_value_changed:)
              forControlEvents:UIControlEventAllEditingEvents];*/
    //passwdTFCount = 0;
    
    // Data load
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

- (IBAction)FindBackBPressed:(UIButton *)sender
{
    [self send_request];
}

#pragma mark - Internal methods

- (void)get_verify_code_lable_update:(NSTimer *)timer
{
    if (getVerifyCodeTimeOut == 0) {
        m_pGetCodeB.enabled = YES;
        m_pGetCodeL.text = NSLocalizedString(@"", @"");
        [m_pGetCodeB setBackgroundImage:[UIImage imageNamed:@"PBUI-PASSWORD_captcha_botton_01.png"] forState:UIControlStateNormal];
        [m_pGetCodeB setImage:[UIImage imageNamed:@"PBUI-PASSWORD_captcha_botton_01.png"] forState:UIControlStateNormal];
        [timer invalidate];
    } else {
        m_pGetCodeB.enabled = NO;
        getVerifyCodeTimeOut -= 1;
        m_pGetCodeL.text = [NSString stringWithFormat:@"%ld", (long)getVerifyCodeTimeOut];
         [m_pGetCodeB setBackgroundImage:[UIImage imageNamed:@"PBUI-PASSWORD_captcha_botton_02.png"] forState:UIControlStateNormal];
        [m_pGetCodeB setImage:[UIImage imageNamed:@"PBUI-PASSWORD_captcha_botton_02.png"] forState:UIControlStateNormal];
    }
}

- (BOOL)validate_input
{
    return m_pPhoneTF.text.length == 11
    && [m_pPasswdTF.text isEqualToString:m_pConfirmTF.text]
    && m_pPasswdTF.text.length >= 6
    && m_pPasswdTF.text.length <= 20
    && m_pVerifyCodeTF.text.length == 4;
}

- (void)send_verify_code
{
    if (m_pPhoneTF.text.length != 11) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:NSLocalizedString(@"您输入的手机号码无效，请重新输入…", @"")
                         mode:ProgressHUDModeTypeText
        userInteractionEnable:YES];
    }
    if (!m_pGetCodeB.enabled) {
        return;
    }
    getVerifyCodeTimeOut = 60;
    m_pGetCodeB.enabled = NO;
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(get_verify_code_lable_update:)
                                   userInfo:nil
                                    repeats:YES];
    [m_pVerifyCodeTF becomeFirstResponder];
    [self ShowProgressHUD:ProgressHUDDurationTypeStay
                  message:NSLocalizedString(@"正在发送验证码…", @"")
                     mode:ProgressHUDModeTypeText
    userInteractionEnable:YES];
    [[UserNetworking new] GetVerifyCode:m_pPhoneTF.text type:GetVerifyCodeTypeChangePasswd response:^(HttpResponseJson *response_json) {
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

- (void)send_request
{
    //solved
    //#warning NETWORK_INTERFACE_ERROR
    [self ShowProgressHUD:ProgressHUDDurationTypeStay
                  message:NSLocalizedString(@"正在找回密码，请稍后…", @"")
                     mode:ProgressHUDModeTypeText
    userInteractionEnable:YES];
    [[UserNetworking new] UserPasswordReset:m_pPhoneTF.text vercode:m_pVerifyCodeTF.text password:m_pPasswdTF.text response:^(HttpResponseJson *response_json) {
        
        [self HideProgressHUD];
        if (response_json.StatusCode == 200) {
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"找回成功", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
            if (self.navigationController) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self dismissViewControllerAnimated:YES
                                         completion:nil];
            }
        }
        
    }];
}

#pragma mark - Text field delegate & methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == m_pPhoneTF) {
        [m_pPasswdTF becomeFirstResponder];
    } else if (textField == m_pPasswdTF) {
        if (textField.text.length >= 6 && textField.text.length <= 20) {
            [m_pConfirmTF becomeFirstResponder];
        } else {
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"您输入的用户密码无效，请重新输入…", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
        }
    } else if (textField == m_pConfirmTF) {
        if ([textField.text isEqualToString:m_pPasswdTF.text]) {
            [m_pVerifyCodeTF becomeFirstResponder];
            [self send_verify_code];
        } else {
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"您输入的密码不一致，请重新检查…", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
        }
    } else if (textField == m_pVerifyCodeTF) {
        
    }
    
    return NO;
}
/*
- (void)phone_value_changed:(UITextField *)sender
{
    if (sender.text.length == 11) {
        [m_pPasswdTF becomeFirstResponder];
        return;
    }*/
    /*
    UITextField *text_field = (UITextField *)sender;
    if (text_field == m_pPhoneTF) {
        if (text_field.text.length == 11) {
            [m_pPasswdTF becomeFirstResponder];
            return;
        }
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
    }*//* else if (text_field == m_pVerifyCodeTF) {
        if (text_field.text.length == 4 || [self validate_input]) {
            [self send_request];
        }
    }*//*
}

- (void)verify_value_changed:(UITextField *)sender
{
    if (sender.text.length == 4 || [self validate_input]) {
        [self send_request];
    }
}
*/
@end
