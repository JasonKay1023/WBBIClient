//
//  UserIdentityValidateVC.m
//  WBBIClient
//
//  Created by 黃韜 on 10/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "UserIdentityValidateVC.h"
#import <SDWebImageManager.h>
#import "AppConstants.h"
#import "UIView+Style.h"
#import "DialogHandler.h"
#import "ImagePickerHandler.h"
#import "UIViewController+ProgressHUD.h"
#import "UserNetworking.h"

@interface UserIdentityValidateVC () <UITextFieldDelegate, ImagePickerDelegate>
{
    BOOL m_bValidationCreated;
}

@property (strong, nonatomic) DialogHandler *idCardDH;
@property (strong, nonatomic) DialogHandler *idCardWithPersonDH;
@property (strong, nonatomic) ImagePickerHandler *idCardPH;
@property (strong, nonatomic) ImagePickerHandler *idCardWithPersonPH;
@property (strong, nonatomic) UIImage *idCardImage;
@property (strong, nonatomic) UIImage *idCardHolderImage;

#pragma mark - User interface

@property (strong, nonatomic) IBOutlet UITextField *RealNameTF;
@property (strong, nonatomic) IBOutlet UITextField *IDNumberTF;
@property (strong, nonatomic) IBOutlet UIButton *IDCardB;
@property (strong, nonatomic) IBOutlet UIButton *IDCardWithPersonB;
@property (strong, nonatomic) IBOutlet UIButton *SubmitB;
@property (strong, nonatomic) IBOutlet UIButton *SkipBB;

- (IBAction)IDCardBPressed:(UIButton *)sender;
- (IBAction)IDCardWithPersonBPressed:(UIButton *)sender;
- (IBAction)SubmitBPressed:(UIButton *)sender;
- (IBAction)SkipBBPressed:(id)sender;

@end

@implementation UserIdentityValidateVC

@synthesize RealNameTF = m_pRealNameTF;
@synthesize IDNumberTF = m_pIDNumberTF;
@synthesize IDCardB = m_pIDCardB;
@synthesize IDCardWithPersonB = m_pIDCardWithPersonB;
@synthesize SubmitB = m_pSubmitB;
@synthesize SkipBB = m_pSkipBB;

@synthesize idCardDH = m_pIDCardDH;
@synthesize idCardWithPersonDH = m_pIDCardWithPersonDH;
@synthesize idCardPH = m_pIDCardPH;
@synthesize idCardWithPersonPH = m_pIDCardWithPersonPH;
@synthesize idCardImage = m_pIDCardImage;
@synthesize idCardHolderImage = m_pIDCardHolderImage;

#pragma mark - Object life cycle

- (void)viewDidLoad
{
    
    self.IsEditMode = YES;
    
    [super viewDidLoad];
    
    // User interface styling
    [m_pIDCardB SetCornerRadius:5.0];
    [m_pIDCardWithPersonB SetCornerRadius:5.0];
    [m_pSubmitB SetCornerRadius:5.0];
    
    // Text field delegate
    m_pRealNameTF.delegate = self;
    m_pIDNumberTF.delegate = self;
    m_pRealNameTF.attributedPlaceholder = [[NSAttributedString alloc]
                                           initWithString:NSLocalizedString(@"请输入您的真实姓名", @"")
                                           attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    m_pIDNumberTF.attributedPlaceholder = [[NSAttributedString alloc]
                                           initWithString:NSLocalizedString(@"请输入您的身份证号", @"")
                                           attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    // Data initialization
    m_bValidationCreated = NO;
    
    [[UserNetworking new] RealNameInfo:^(HttpResponseJson *response_data) {
        if (response_data.StatusCode == 200) {  // 已有認證信息
            m_pRealNameTF.text = [response_data.Result objectForKey:@"RealName"];
            m_pIDNumberTF.text = [response_data.Result objectForKey:@"IDNumber"];
            NSString *id_card_photo = [response_data.Result objectForKey:@"IDCardPhoto"];
            NSString *id_card_holder_photo = [response_data.Result objectForKey:@"IDCardHolderPhoto"];
            //NSString *approval_status = [response_data.Result objectForKey:@"ApprovalStatus"];
            id_card_photo = [BaseURL stringByAppendingString:id_card_photo];
            id_card_holder_photo = [BaseURL stringByAppendingString:id_card_holder_photo];
            NSURL *card_photo = [NSURL URLWithString:id_card_photo];
            NSURL *card_holder_photo = [NSURL URLWithString:id_card_holder_photo];
            if (card_photo && card_holder_photo) {
                [[SDWebImageManager sharedManager] downloadImageWithURL:card_photo options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    m_pIDCardImage = image;
                    [m_pIDCardB setBackgroundImage:image
                                          forState:UIControlStateNormal];
                }];
                [[SDWebImageManager sharedManager] downloadImageWithURL:card_holder_photo options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    m_pIDCardHolderImage = image;
                    [m_pIDCardWithPersonB setBackgroundImage:image
                                                    forState:UIControlStateNormal];
                }];
            }
            m_bValidationCreated = YES;
        } else if (response_data.ErrorCode == 11005) {  // 未有認證信息
            
        } else {    // 其它錯誤
            
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    if (m_pIDCardPH != nil) {
        [m_pIDCardPH RemoveImageObserver:self];
    }
}

#pragma mark - User interface

- (IBAction)IDCardBPressed:(UIButton *)sender
{
    [self HideKeyboard];
    m_pIDCardDH = [[DialogHandler alloc] init];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300.0, 200.0)];
    [m_pIDCardDH Dialog:self view:view cancelTitle:NSLocalizedString(@"取消", @"") cancelAction:nil firstTitle:NSLocalizedString(@"从手机相册选择", @"") firstAction:^{
        
        m_pIDCardPH = [[ImagePickerHandler alloc] init];
        [m_pIDCardPH AddImageObserver:self];
        [m_pIDCardPH ShowImagePicker:self
                          fromSource:UIImagePickerControllerSourceTypePhotoLibrary
                              toSize:CGSizeMake(856.0, 540.0)
                            andScale:(856.0 / 540.0)];
        
    } secondTitle:NSLocalizedString(@"拍照", @"") secondAction:^{
        
        m_pIDCardPH = [[ImagePickerHandler alloc] init];
        [m_pIDCardPH AddImageObserver:self];
        [m_pIDCardPH ShowImagePicker:self
                          fromSource:UIImagePickerControllerSourceTypeCamera
                              toSize:CGSizeMake(900.0, 600.0)
                            andScale:0.0];
        
    }];
}

- (IBAction)IDCardWithPersonBPressed:(UIButton *)sender
{
    [self HideKeyboard];
    m_pIDCardWithPersonDH = [[DialogHandler alloc] init];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300.0, 200.0)];
    [m_pIDCardWithPersonDH Dialog:self view:view cancelTitle:NSLocalizedString(@"取消", @"") cancelAction:nil firstTitle:NSLocalizedString(@"从手机相册选择", @"") firstAction:^{
        
        m_pIDCardWithPersonPH = [[ImagePickerHandler alloc] init];
        [m_pIDCardWithPersonPH AddImageObserver:self];
        [m_pIDCardWithPersonPH ShowImagePicker:self
                                    fromSource:UIImagePickerControllerSourceTypePhotoLibrary
                                        toSize:CGSizeMake(856.0, 540.0)
                                      andScale:(856.0 / 540.0)];
        
    } secondTitle:NSLocalizedString(@"拍照", @"") secondAction:^{
        
        m_pIDCardWithPersonPH = [[ImagePickerHandler alloc] init];
        [m_pIDCardWithPersonPH AddImageObserver:self];
        [m_pIDCardWithPersonPH ShowImagePicker:self
                                    fromSource:UIImagePickerControllerSourceTypeCamera
                                        toSize:CGSizeMake(900.0, 600.0)
                                      andScale:0.0];
        
    }];
}

- (IBAction)SubmitBPressed:(UIButton *)sender
{
    if ([self validate_input]) {
        [self send_request];
    }
}

- (IBAction)SkipBBPressed:(id)sender
{
    [self all_done];
}

#pragma mark - Internal methods

- (BOOL)validate_input
{
    if (m_pRealNameTF.text.length == 0) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:NSLocalizedString(@"您输入的姓名无效，请重新输入…", @"")
                         mode:ProgressHUDModeTypeText
        userInteractionEnable:YES];
        return NO;
    }
    if (m_pIDNumberTF.text.length != 18) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:NSLocalizedString(@"您输入的身份证号码有误，请重新输入…", @"")
                         mode:ProgressHUDModeTypeText
        userInteractionEnable:YES];
        return NO;
    }
    if (!m_pIDCardImage || !m_pIDCardHolderImage) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:NSLocalizedString(@"您的身份证件照未上传，请重新上传…", @"")
                         mode:ProgressHUDModeTypeText
        userInteractionEnable:YES];
        return NO;
    }
    return YES;
}

- (void)send_request
{
    /*
    [[UserNetworking new] RealNameValidate:m_pRealNameTF.text identifyNumber:m_pIDNumberTF.text response:^(HttpResponseJson *response_json) {
        NSLog(@"%@", response_json.description);
    }];
     */
    [self ShowProgressHUD:ProgressHUDDurationTypeStay
                  message:NSLocalizedString(@"正在提交认证，请稍后…", @"")
                     mode:ProgressHUDModeTypeIndeterminate
    userInteractionEnable:YES];
    [[UserNetworking new] RealNameValidate:m_pRealNameTF.text identifyNumber:m_pIDNumberTF.text response:^(HttpResponseJson *response_json) {
        [self HideProgressHUD];
        NSLog(@"%@", response_json.description);
        if (response_json.StatusCode == 201) {
            
            [self upload_photo];
            
        } else {
            //solved
            //#warning backend should not return 500 when duplicated
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"认证失败，请稍后重试…", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
        }
    }];
}

- (void)upload_photo
{
    [self ShowProgressHUD:ProgressHUDDurationTypeStay
                  message:NSLocalizedString(@"正在上传证件照，请稍后…", @"")
                     mode:ProgressHUDModeTypeIndeterminate
    userInteractionEnable:YES];
    if (m_pIDCardImage && m_pIDCardHolderImage) {
        [[UserNetworking new] RealNamePhotos:m_pIDCardImage idCardHolderPhoto:m_pIDCardHolderImage response:^(HttpResponseJson *response_json) {
            [self HideProgressHUD];
            if (response_json.StatusCode == 200) {
                [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                              message:NSLocalizedString(@"证件照上传成功…", @"")
                                 mode:ProgressHUDModeTypeText
                userInteractionEnable:YES];
                [self all_done];
            } else {
                [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                              message:NSLocalizedString(@"证件照上传失败…", @"")
                                 mode:ProgressHUDModeTypeText
                userInteractionEnable:YES];
            }
        }];
    } else {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:NSLocalizedString(@"认证失败，请稍后重试…", @"")
                         mode:ProgressHUDModeTypeText
        userInteractionEnable:YES];
    }
    
}

- (void)all_done
{
    UIViewController *user_info_vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]
                                      instantiateViewControllerWithIdentifier:@"UserInfoModifyVC"];
    [self.navigationController pushViewController:user_info_vc
                                         animated:YES];
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == m_pRealNameTF) {
        [m_pIDNumberTF becomeFirstResponder];
    } else if (textField == m_pIDNumberTF) {
        [m_pIDNumberTF resignFirstResponder];
    }
    
    return NO;
}

#pragma mark - Image picker delegate

- (void)ImagePicker:(ImagePickerHandler *)picker image:(UIImage *)image
{
    if (picker == m_pIDCardPH) {
        [m_pIDCardB setBackgroundImage:image forState:UIControlStateNormal];
        m_pIDCardImage = image;
    } else if (picker == m_pIDCardWithPersonPH) {
        [m_pIDCardWithPersonB setBackgroundImage:image forState:UIControlStateNormal];
        m_pIDCardHolderImage = image;
    }
}

@end
