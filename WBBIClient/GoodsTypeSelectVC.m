//
//  GoodsTypeSelectVC.m
//  WBBIClient
//
//  Created by 黃韜 on 8/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "GoodsTypeSelectVC.h"
#import "TypeNetworking.h"
#import "KVModel.h"
#import "UIViewController+ProgressHUD.h"

@interface GoodsTypeSelectVC ()

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) NSArray *array;

- (IBAction)SaveBPressed:(UIBarButtonItem *)sender;

@end

@implementation GoodsTypeSelectVC

@synthesize selectedIndexPath = m_pSelectedIndexPath;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"商品类型选择", @"");
    
    [self ShowProgressHUD:ProgressHUDDurationTypeStay
                  message:NSLocalizedString(@"加载ing", @"")
                     mode:ProgressHUDModeTypeIndeterminate
    userInteractionEnable:YES];
    [[TypeNetworking new] GetList:^(NSArray *response) {
        [self HideProgressHUD];
        _array = response;
        [self.tableView reloadData];
    } fail:^(HttpResponseJson *response) {
        [self HideProgressHUD];
        [self ShowProgressHUD:ProgressHUDDurationTypeStay
                      message:NSLocalizedString(@"加载失败", @"")
                         mode:ProgressHUDModeTypeIndeterminate
        userInteractionEnable:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = ((KVModel *)[_array objectAtIndex:indexPath.row]).Name;
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (m_pSelectedIndexPath != nil) {
        UITableViewCell *selected_cell = [tableView cellForRowAtIndexPath:m_pSelectedIndexPath];
        selected_cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITableViewCell *selecting_cell = [tableView cellForRowAtIndexPath:indexPath];
    selecting_cell.accessoryType = UITableViewCellAccessoryCheckmark;
    m_pSelectedIndexPath = indexPath;
}

- (void)save
{
    if ([self validate]) {
        [self do_save];
        [self jump_back];
    } else {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:NSLocalizedString(@"保存失败", @"")
                         mode:ProgressHUDModeTypeText
        userInteractionEnable:YES];
    }
}

- (BOOL)validate
{
    if (m_pSelectedIndexPath) {
        return YES;
    } else {
        return NO;
    }
}

- (void)do_save
{
    if (_Delegate) {
        [_Delegate CallBackGoodsType:[_array objectAtIndex:m_pSelectedIndexPath.row]];
    }
}

- (void)jump_back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)SaveBPressed:(UIBarButtonItem *)sender
{
    [self save];
}

@end
