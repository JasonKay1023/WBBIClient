//
//  UserPersonalInfoModifyVC.m
//  WBBIClient
//
//  Created by 黃韜 on 12/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "UserPersonalInfoModifyVC.h"
#import "UIView+Style.h"
#import "UIViewController+ProgressHUD.h"
#import "PopoverHandler.h"
#import "LocationPickerVC.h"
#import "UserJobModifyVC.h"
#import "UserNetworking.h"

@interface UserPersonalInfoModifyVC () <UITextViewDelegate>
{
    NSNumber *m_pJobIndustryID;
    NSString *m_pJobName;
}

@property (strong, nonatomic) PopoverHandler *locationPopover;

@property (strong, nonatomic) IBOutlet UILabel *JobL;
@property (strong, nonatomic) IBOutlet UIButton *JobB;
@property (strong, nonatomic) IBOutlet UILabel *LocationL;
@property (strong, nonatomic) IBOutlet UIButton *LocationB;
@property (strong, nonatomic) IBOutlet UITextView *SignatureTV;
@property (strong, nonatomic) IBOutlet UITextField *SignatureTF;
@property (strong, nonatomic) IBOutlet UIButton *SubmitB;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *SkipBB;

- (IBAction)JobBPressed:(UIButton *)sender;
- (IBAction)LocationBPressed:(UIButton *)sender;
- (IBAction)SubmitBPressed:(UIButton *)sender;
- (IBAction)SkipBBPressed:(UIBarButtonItem *)sender;

@end

@implementation UserPersonalInfoModifyVC

@synthesize JobL = m_pJobL;
@synthesize JobB = m_pJobB;
@synthesize LocationL = m_pLocationL;
@synthesize LocationB = m_pLocationB;
@synthesize SignatureTV = m_pSignatureTV;
@synthesize SignatureTF = m_pSignatureTF;
@synthesize SubmitB = m_pSubmitB;
@synthesize SkipBB = m_pSkipBB;

@synthesize locationPopover = m_pLocationPH;

#pragma mark - Object life cycle

- (void)viewDidLoad {
    
    self.IsEditMode = YES;
    
    [super viewDidLoad];
    
    if ([m_pSignatureTV.text isEqualToString:@""]){
        [m_pSignatureTF setHidden:NO];
    }
    else{
        [m_pSignatureTF setHidden:YES];
    }
    
    // User interface styling
    [m_pJobB SetCornerRadius:5.0];
    [m_pLocationB SetCornerRadius:5.0];
    [m_pSubmitB SetCornerRadius:5.0];
    
    // Text view delegate
    m_pSignatureTV.delegate = self;
    
    // Inits
    m_pLocationPH = [[PopoverHandler alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyByLocationPicker:)
                                                 name:kLocationPickerKey
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyByJobModifyVC:)
                                                 name:kUserJobModifyKey
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - User interface


- (IBAction)JobBPressed:(UIButton *)sender
{
    UserJobModifyVC *user_job_vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]
                                    instantiateViewControllerWithIdentifier:@"UserJobModifyVC"];
    if (self.navigationController) {
        [self.navigationController pushViewController:user_job_vc animated:YES];
    } else {
        UINavigationController *nav_vc = [[UINavigationController alloc] initWithRootViewController:user_job_vc];
        [self presentViewController:nav_vc animated:YES completion:nil];
    }
}

- (IBAction)LocationBPressed:(UIButton *)sender
{
    LocationPickerVC *picker_vc = [[UIStoryboard storyboardWithName:@"AssistantTools"
                                                             bundle:nil]
                                   instantiateViewControllerWithIdentifier:@"LocationPickerVC"];
#warning Can be better
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    picker_vc.preferredContentSize = CGSizeMake(width, 230.0);
    [m_pLocationPH Show:picker_vc
               fromRect:m_pLocationB.bounds
                 inView:m_pLocationB
           andDirection:WYPopoverArrowDirectionAny
               animated:YES
                options:WYPopoverAnimationOptionFade
             completion:nil];
}

- (IBAction)SubmitBPressed:(UIButton *)sender
{
    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
    format.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *number = m_pJobIndustryID;
    if ([self validate]) {
        [self ShowProgressHUD:ProgressHUDDurationTypeStay message:NSLocalizedString(@"", @"") mode:ProgressHUDModeTypeDeterminate userInteractionEnable:YES];
        [[UserNetworking new] UserInfoNickname:nil sexual:nil birthday:nil jobIndustryID:number jobPosition:m_pJobName signature:m_pSignatureTV.text place:nil GPSX:nil GPSY:nil response:^(HttpResponseJson *response_data) {
            [self HideProgressHUD];
            if (response_data.StatusCode == 200) {
                [self ShowProgressHUD:ProgressHUDDurationTypeStay
                              message:NSLocalizedString(@"", @"")
                                 mode:ProgressHUDModeTypeDeterminate
                userInteractionEnable:YES];
                [self next];
            } else {
                [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                              message:NSLocalizedString(@"", @"")
                                 mode:ProgressHUDModeTypeText
                userInteractionEnable:YES];
            }
        }];
    } else {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:NSLocalizedString(@"提交失败，请完善个人信息…", @"")
                         mode:ProgressHUDModeTypeText
        userInteractionEnable:YES];
    }
}

- (IBAction)SkipBBPressed:(UIBarButtonItem *)sender
{
    
}

#pragma mark - Internal methods

- (BOOL)validate
{
    if (m_pJobIndustryID && m_pJobName && m_pLocationL.text) {
        return YES;
    } else {
        return NO;
    }
}

- (void)next
{
    // go next
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Text view delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

#pragma mark - Picker view

- (void)notifyByLocationPicker:(NSNotification *)event
{
    m_pLocationL.text = (NSString *)event.object;
    m_pLocationL.textColor = [UIColor blackColor];
}

#pragma mark - Job modify view controller

- (void)notifyByJobModifyVC:(NSNotification *)event
{
    NSNumber *industry_id = [(NSDictionary *)event.object objectForKey:@"industry_id"];
    NSString *industry_name = [(NSDictionary *)event.object objectForKey:@"industry_name"];
    NSString *job_name = [(NSDictionary *)event.object objectForKey:@"job_name"];
    m_pJobL.text = [[industry_name stringByAppendingString:@" - "] stringByAppendingString:job_name];
    m_pJobL.textColor = [UIColor blackColor];
    m_pJobIndustryID = industry_id;
    m_pJobName = job_name;
}

@end
