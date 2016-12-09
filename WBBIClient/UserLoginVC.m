//
//  UserLoginVC.m
//  WBBIClient
//
//  Created by 黃韜 on 9/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "UserLoginVC.h"
#import "UIView+Style.h"
#import "RESTNetworking.h"
#import "UIViewController+ProgressHUD.h"

@interface UserLoginVC () <UITextFieldDelegate>

#pragma mark - User interface

@property (strong, nonatomic) IBOutlet UITextField *PhoneTF;
@property (strong, nonatomic) IBOutlet UITextField *PasswordTF;
@property (strong, nonatomic) IBOutlet UIButton *ForgotPasswordB;
@property (strong, nonatomic) IBOutlet UIButton *LoginB;
@property (strong, nonatomic) IBOutlet UIButton *RegisterB;

- (IBAction)LoginBPressed:(UIButton *)sender;

@end

@implementation UserLoginVC

@synthesize PhoneTF = m_pPhoneTF;
@synthesize PasswordTF = m_pPasswordTF;
@synthesize ForgotPasswordB = m_pForgotPasswordB;
@synthesize LoginB = m_pLoginB;
@synthesize RegisterB = m_pRegisterB;

#pragma mark - Object life cycle

- (void)viewDidLoad
{
    
    self.IsEditMode = YES;
    
    [super viewDidLoad];
    //navigation_bar color
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"2x2"] forBarMetrics:UIBarMetricsDefault];
    // User interface styling
    [m_pLoginB SetCornerRadius:5.0];
    
    // Text field delegate
    m_pPhoneTF.delegate = self;
    m_pPasswordTF.delegate = self;
    m_pPhoneTF.attributedPlaceholder = [[NSAttributedString alloc]
                                        initWithString:NSLocalizedString(@"请输入手机号", @"")
                                        attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    m_pPasswordTF.attributedPlaceholder = [[NSAttributedString alloc]
                                           initWithString:NSLocalizedString(@"请输入密码", @"")
                                           attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    /*
    [m_pPhoneTF addTarget:self
                   action:@selector(textFieldValueChanged:)
         forControlEvents:UIControlEventEditingChanged];*/

}
- (void)viewWillAppear:(BOOL)animated
{
    //navigation_bar isHidden
    [self.navigationController.navigationBar setHidden:NO];
    
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

- (IBAction)LoginBPressed:(UIButton *)sender
{
    [self try_login];
}

#pragma mark - Internal methods

- (void)try_login
{
    if ([self validate_input]) {
        [self auth_user:m_pPhoneTF.text
                 passwd:m_pPasswordTF.text];
    }
}

- (BOOL)validate_input
{
    if (m_pPhoneTF.text.length != 11) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:NSLocalizedString(@"您输入的手机号码无效，请重新输入...", @"")
                         mode:ProgressHUDModeTypeText
        userInteractionEnable:YES];
        return NO;
    }
    if (m_pPasswordTF.text.length < 6 || m_pPasswordTF.text.length > 20) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:NSLocalizedString(@"您输入的用户密码无效,请重新输入...", @"")
                         mode:ProgressHUDModeTypeText
        userInteractionEnable:YES];
        return NO;
    }
    return YES;
}

- (void)auth_user:(NSString *)phone passwd:(NSString *)passwd
{
    [self ShowProgressHUD:ProgressHUDDurationTypeStay
                  message:NSLocalizedString(@"正在登录...", @"")
                     mode:ProgressHUDModeTypeIndeterminate
    userInteractionEnable:NO];
    
    [[RESTNetworking new] Authorization:phone password:passwd response:^(HttpResponse *response_object) {
        
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
                  message:NSLocalizedString(@"登陆成功", @"")
                     mode:ProgressHUDModeTypeText
    userInteractionEnable:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)login_failure
{
    [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                  message:NSLocalizedString(@"您输入的手机或密码有误，请重新检查…", @"")
                     mode:ProgressHUDModeTypeText
    userInteractionEnable:YES];
}

#pragma mark - Text field delegate & methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == m_pPhoneTF) {
        [m_pPasswordTF becomeFirstResponder];
    } else if (textField == m_pPasswordTF) {
        [self try_login];
    }
    
    return NO;
}
/*
- (void)textFieldValueChanged:(id)sender
{
    UITextField *text_field = (UITextField *)sender;
    if (text_field == m_pPhoneTF) {
        if (text_field.text.length == 11) {
            [m_pPasswordTF becomeFirstResponder];
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
        passwdTFCount = text_field.text.length;*//*
    }
}*/

@end
