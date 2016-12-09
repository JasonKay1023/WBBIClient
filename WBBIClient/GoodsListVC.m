//
//  GoodsListVC.m
//  WBBIClient
//
//  Created by 黃韜 on 6/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "GoodsListVC.h"
#import <MJExtension.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+URL.h"
#import "UIViewController+ProgressHUD.h"
#import "GoodsItemTVC.h"
#import "GoodsModel.h"
#import "GoodsDetailVC.h"
#import "GoodsLikeNetworking.h"
#import "GoodsFavourNetworking.h"

@interface GoodsListVC ()

@property (strong, nonatomic) NSArray<GoodsModel *> *goodsArray;

- (IBAction)BackBBPressed:(id)sender;

@end

@implementation GoodsListVC

@synthesize Type = m_eType;

@synthesize goodsArray = m_pGoodsArray;

- (void)viewDidLoad
{
    self.navigationController.navigationBar.clipsToBounds = NO;
    m_pGoodsArray = [NSArray array];
    [super viewDidLoad];
    if (m_eType == GoodsListTypeLike) {
        self.title = NSLocalizedString(@"我赞过的", @"");
        [[GoodsLikeNetworking new] GetList:^(NSArray *response) {
            m_pGoodsArray = response;
            if (m_pGoodsArray.count == 0) {
                [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                              message:NSLocalizedString(@"木有赞过任何东西", @"")
                                 mode:ProgressHUDModeTypeText
                userInteractionEnable:YES];
            }
            [self.tableView reloadData];
        } fail:^(HttpResponseJson *response) {
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"网络出错咯", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
        }];
    } else if (m_eType == GoodsListTypeFavour) {
        self.title = NSLocalizedString(@"我藏过的", @"");
        [[GoodsFavourNetworking new] GetList:^(NSArray *response) {
            m_pGoodsArray = response;
            if (m_pGoodsArray.count == 0) {
                [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                              message:NSLocalizedString(@"木有藏过任何东西", @"")
                                 mode:ProgressHUDModeTypeText
                userInteractionEnable:YES];
            }
            [self.tableView reloadData];
        } fail:^(HttpResponseJson *response) {
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"网络出错咯", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_pGoodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsListItem" forIndexPath:indexPath];
    
    GoodsModel *obj = [m_pGoodsArray objectAtIndex:indexPath.row];
    
    [cell.GoodsAvatarIV sd_setImageWithURL:[[obj.PhotoFront AppendServerURL]
                                            ToURL]];
    cell.SellerNameL.text = obj.Seller.NickName;
    cell.SellerTypeL.text = @"商家";
    cell.PriceL.text = [obj.Price stringValue];
    cell.GoodsNameL.text = obj.Title;
    cell.GoodsDetailTV.text = obj.Introduction;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailVC *vc = [[UIStoryboard storyboardWithName:@"Shop" bundle:nil]
                         instantiateViewControllerWithIdentifier:@"GoodsDetailVC"];
    vc.GoodsDetailID = [m_pGoodsArray
                        objectAtIndex:indexPath.row].id;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)BackBBPressed:(id)sender
{
    [_delegate showFront];
}

@end
