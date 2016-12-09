//
//  UserAddressModifyVC.m
//  WBBIClient
//
//  Created by 黃韜 on 4/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "UserAddressModifyVC.h"
#import "AddressPickerVC.h"
#import "UserAddressNetworking.h"
#import "UIViewController+ProgressHUD.h"

@interface UserAddressModifyVC () <AddressPickerDelegate>
{
    NSString *m_strPlaceZip;
}

@property (strong, nonatomic) IBOutlet UITextField *BuyerNameTF;
@property (strong, nonatomic) IBOutlet UITextField *PhoneTF;
@property (strong, nonatomic) IBOutlet UITextField *ZipCodeTF;
@property (strong, nonatomic) IBOutlet UITextField *PlaceTF;
@property (strong, nonatomic) IBOutlet UITextView *AddressTV;

- (IBAction)PlaceBPressed:(UIButton *)sender;

@end

@implementation UserAddressModifyVC

@synthesize InitObject = m_pInitObject;

@synthesize BuyerNameTF = m_pBuyerNameTF;
@synthesize PhoneTF = m_pPhoneTF;
@synthesize ZipCodeTF = m_pZipCodeTF;
@synthesize PlaceTF = m_pPlaceTF;
@synthesize AddressTV = m_pAddressTV;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //save address
    UIBarButtonItem *save_item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = save_item;
    //
    if (m_pInitObject) {
        m_pBuyerNameTF.text = m_pInitObject.BuyerName;
        m_pPhoneTF.text = m_pInitObject.Phone;
        m_pZipCodeTF.text = m_pInitObject.ZipCode;
        m_pPlaceTF.text = m_pInitObject.Place.Shortcut;
        m_pAddressTV.text = m_pInitObject.Address;
        m_strPlaceZip = [NSString stringWithFormat:@"%ld", (long)m_pInitObject.Place.Identify];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)PlaceBPressed:(UIButton *)sender
{
    AddressPickerVC *vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]
                           instantiateViewControllerWithIdentifier:@"AddressPickerVC"];
    vc.Delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (BOOL)validate
{
    if (m_pBuyerNameTF.text.length == 0 || m_pPhoneTF.text.length != 11 || m_pZipCodeTF.text.length != 6 || !m_strPlaceZip || m_pAddressTV.text.length == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)save
{
    if (![self validate]) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:NSLocalizedString(@"UserAddressModify.invalid", @"")
                         mode:ProgressHUDModeTypeText
        userInteractionEnable:YES];
    }
    if (m_pInitObject) { 
        // update
        [[[UserAddressNetworking alloc] initWithAddressID:[NSNumber numberWithInteger:m_pInitObject.id]] BuyerName:m_pBuyerNameTF.text districtID:m_strPlaceZip zipCode:m_pZipCodeTF.text address:m_pAddressTV.text phone:m_pPhoneTF.text success:^(UserAddressModel *response) {
            [self ShowProgressHUD:ProgressHUDDurationTypeStay
                          message:NSLocalizedString(@"UserAddressUpdating.Successfully", @"")
                             mode:ProgressHUDModeTypeIndeterminate
            userInteractionEnable:YES];
            [self HideProgressHUD];
            [self call_back];
        } fail:^(HttpResponseJson *response) {
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"UserAddressUpdate.failed", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
        }];
    } else {
        // create
        [[UserAddressNetworking new] BuyerName:m_pBuyerNameTF.text districtID:m_strPlaceZip zipCode:m_pZipCodeTF.text address:m_pAddressTV.text phone:m_pPhoneTF.text success:^(UserAddressModel *response) {
            [self ShowProgressHUD:ProgressHUDDurationTypeStay
                          message:NSLocalizedString(@"UserAddressCreating.Successfully", @"")
                             mode:ProgressHUDModeTypeIndeterminate
            userInteractionEnable:YES];
            [self HideProgressHUD];
            [self call_back];
        } fail:^(HttpResponseJson *response) {
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"UserAddressCreat.falied", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
        }];
    }
}

- (void)call_back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)ReturnResult:(NSString *)ZipCode withShortcut:(NSString *)shortcut
{
    NSLog(@"%@, %@", ZipCode, shortcut);
    m_pPlaceTF.text = shortcut;
    m_strPlaceZip = ZipCode;
}

@end
