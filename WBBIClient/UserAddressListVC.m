//
//  UserAddressListVC.m
//  WBBIClient
//
//  Created by 黃韜 on 4/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "UserAddressListVC.h"
#import <MJExtension.h>
#import "UIViewController+ProgressHUD.h"
#import "UserAddressTVC.h"
#import "UserAddressModel.h"
#import "UserAddressModifyVC.h"
#import "UserAddressNetworking.h"

@interface UserAddressListVC ()

@property (strong, nonatomic) NSMutableArray<UserAddressModel *> *addressList;

@end

@implementation UserAddressListVC 

@synthesize addressList = m_pAddressList;

- (void)viewDidLoad {
    //add address
        UIBarButtonItem *add_item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                 target:self
                                                                                 action:@selector(add)];
      self.navigationItem.rightBarButtonItem = add_item;
}

- (void)viewWillAppear:(BOOL)animated
{
    m_pAddressList = [NSMutableArray arrayWithCapacity:5];
    [super viewDidLoad];
    [self ShowProgressHUD:ProgressHUDDurationTypeStay
                  message:NSLocalizedString(@"正在加载地址", @"")
                     mode:ProgressHUDModeTypeIndeterminate
    userInteractionEnable:YES];
    [[UserAddressNetworking new] GetList:^(NSArray *response) {
        [self HideProgressHUD];
        m_pAddressList = [NSMutableArray arrayWithArray:[UserAddressModel mj_objectArrayWithKeyValuesArray:response]];
        [self.tableView reloadData];
    } fail:^(HttpResponseJson *response) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:NSLocalizedString(@"", @"")
                         mode:ProgressHUDModeTypeText
        userInteractionEnable:YES];
    }];
}

- (void)add
{
    UserAddressModifyVC *address_modifyvc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]instantiateViewControllerWithIdentifier:@"UserAddressModifyVC"];
    [self.navigationController pushViewController:address_modifyvc
                                         animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [m_pAddressList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserAddressTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UserAddressModel *object = [m_pAddressList objectAtIndex:indexPath.row];
    cell.BuyerName.text = object.BuyerName;
    cell.Phone.text = object.Phone;
    cell.AddressDetail.text = [object.Place.Shortcut stringByAppendingString:object.Address];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserAddressModel *object = [m_pAddressList objectAtIndex:indexPath.row];
    if (_Delegate) {
        [_Delegate Address:object];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    UserAddressModifyVC *detail_vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]
                                      instantiateViewControllerWithIdentifier:@"UserAddressModifyVC"];
    detail_vc.InitObject = object;
    [self.navigationController pushViewController:detail_vc
                                         animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
