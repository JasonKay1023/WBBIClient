//
//  GoodsSceneSelectVC.m
//  WBBIClient
//
//  Created by 黃韜 on 8/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "GoodsSceneSelectVC.h"
#import "SceneNetworking.h"
#import "KVModel.h"
#import "UIViewController+ProgressHUD.h"

@interface GoodsSceneSelectVC ()

@property (strong, nonatomic) NSArray *array;
@property (strong, nonatomic) NSMutableArray *result;

- (IBAction)SaveBPressed:(UIBarButtonItem *)sender;

@end

@implementation GoodsSceneSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"商品适用场景选择", @"");
    [self ShowProgressHUD:ProgressHUDDurationTypeStay
                  message:NSLocalizedString(@"加载ing", @"")
                     mode:ProgressHUDModeTypeIndeterminate
    userInteractionEnable:YES];
    [[SceneNetworking new] GetList:^(NSArray *response) {
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
    UITableViewCell *selecting_cell = [tableView cellForRowAtIndexPath:indexPath];
    if (selecting_cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        selecting_cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        selecting_cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
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
    _result = [NSMutableArray array];
    for (NSInteger num = 0; num != _array.count; ++num) {
        NSIndexPath *index_path = [NSIndexPath indexPathForItem:num inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index_path];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            [_result addObject:[_array objectAtIndex:num]];
        }
    }
    if (_result.count == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)do_save
{
    if (_Delegate) {
        [_Delegate CallBackGoodsScene:_result];
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
