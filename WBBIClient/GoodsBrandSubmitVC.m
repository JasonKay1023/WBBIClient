//
//  GoodsBrandSubmitVC.m
//  WBBIClient
//
//  Created by 黃韜 on 8/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "GoodsBrandSubmitVC.h"
#import "UIViewController+ProgressHUD.h"
#import "UIView+Style.h"
#import "BrandNetworking.h"
#import "KVModel.h"

@interface GoodsBrandSubmitVC ()

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) NSArray *arrayBrand;

@property (strong, nonatomic) IBOutlet UITextField *BrandTF;
@property (strong, nonatomic) IBOutlet UIButton *SubmitB;

- (IBAction)SubmitBPressed:(UIButton *)sender;

@end

@implementation GoodsBrandSubmitVC

@synthesize BrandTF = m_pBrandTF;
@synthesize SubmitB = m_pSubmitB;

@synthesize selectedIndexPath = m_pSelectedIndexPath;
@synthesize arrayBrand = m_pArrayBrand;

#pragma mark - Object life cycle

- (void)viewDidLoad
{
    
    self.IsEditMode = YES;
    
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"商品品牌选择", @"");
    
    [self ShowProgressHUD:ProgressHUDDurationTypeStay
                  message:NSLocalizedString(@"品牌加载ing", @"")
                     mode:ProgressHUDModeTypeIndeterminate
    userInteractionEnable:YES];
    [[BrandNetworking new] GetList:^(NSArray *response) {
        [self HideProgressHUD];
        m_pArrayBrand = response;
        [self.tableView reloadData];
    } fail:^(HttpResponseJson *response) {
        [self HideProgressHUD];
        [self ShowProgressHUD:ProgressHUDDurationTypeStay
                      message:NSLocalizedString(@"品牌加载失败", @"")
                         mode:ProgressHUDModeTypeIndeterminate
        userInteractionEnable:YES];
    }];
    
    // User interface styling
    [m_pSubmitB SetCornerRadius:5.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - User interface

- (IBAction)SubmitBPressed:(UIButton *)sender
{
    if (m_pBrandTF.text.length != 0 || m_pSelectedIndexPath) {
        if (m_pBrandTF.text.length != 0) {
            [self call_back:m_pBrandTF.text];
        } else {
            UITableViewCell *cell = [self tableView:self.tableView
                              cellForRowAtIndexPath:m_pSelectedIndexPath];
            [self call_back:cell.textLabel.text];
        }
    }
}

- (void)call_back:(NSString *)brand
{
    [_Delegate CallBackGoodsBrand:brand];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (m_pArrayBrand) {
        return m_pArrayBrand.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (m_pArrayBrand) {
        cell.textLabel.text = ((KVModel *)[m_pArrayBrand objectAtIndex:indexPath.row]).Name;
    }
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

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    return @"品牌选择";
}

@end
