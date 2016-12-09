//
//  GoodsDetailVC.m
//  WBBIClient
//
//  Created by 黃韜 on 6/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "GoodsDetailVC.h"
#import <MJExtension.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIViewController+ProgressHUD.h"
#import "NSString+URL.h"
#import "GoodsNetworking.h"
#import "GoodsFavourNetworking.h"
#import "GoodsBottomV.h"
#import "GoodsDetailTVC.h"
#import "GoodsIntroductionTVC.h"
#import "GoodsCommentTVC.h"
#import "GoodsCommentModel.h"
#import "OrderNetworking.h"
#import "OrderConfirmVC.h"
#import "CartNetworking.h"
#import "CartListVC.h"
#import "CartBottomConfirmV.h"
#import "ChatViewController.h"

#define BottomBarHeight 50.0

@interface GoodsDetailVC () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *m_tableview;
    GoodsBottomV *m_view_bottom;
    CartBottomConfirmV *m_cart_bottomView;
}

@property (strong, nonatomic) NSMutableArray *commentsArray;

@end

@implementation GoodsDetailVC

@synthesize GoodsDetailID = m_pGoodsDetailID;
@synthesize GoodsDetailObject = m_pGoodsDetailObject;
@synthesize commentsArray = m_arr_comments;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.clipsToBounds = NO;
    self.title = @"商品详情";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"PBUI_Home_ShoppingCar"] style:UIBarButtonItemStyleBordered target:self action:@selector(pushToCart)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    m_tableview = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
    [m_tableview registerNib:[UINib nibWithNibName:@"GoodsDetailCell" bundle:nil]
         forCellReuseIdentifier:@"GoodsDetailItem"];
    [m_tableview registerNib:[UINib nibWithNibName:@"GoodsCommentCell" bundle:nil]
         forCellReuseIdentifier:@"GoodsCommentItem"];
    [m_tableview registerNib:[UINib nibWithNibName:@"GoodsIntroductionCell" bundle:nil]
         forCellReuseIdentifier:@"GoodsDetailIntroItem"];
    m_tableview.delegate = self;
    m_tableview.dataSource = self;
    [self.view addSubview:m_tableview];
    
    m_view_bottom = [[[NSBundle mainBundle] loadNibNamed:@"GoodsBottomV" owner:self options:nil] lastObject];
    m_view_bottom.frame = CGRectMake(0,
                                     self.view.bounds.size.height - BottomBarHeight,
                                     self.view.bounds.size.width,
                                     BottomBarHeight);
    [m_view_bottom.ChatB addTarget:self
                            action:@selector(chat)
                  forControlEvents:(UIControlEventTouchUpInside)];
    [m_view_bottom.FavourB addTarget:self
                              action:@selector(favour)
                    forControlEvents:(UIControlEventTouchUpInside)];
    [m_view_bottom.AddToCartB addTarget:self
                                 action:@selector(add_to_cart)
                       forControlEvents:(UIControlEventTouchUpInside)];
    [m_view_bottom.BuyNowB addTarget:self
                              action:@selector(buy_now)
                    forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:m_view_bottom];
    [self.view bringSubviewToFront:m_view_bottom];
    
    if (m_pGoodsDetailObject) {
        m_pGoodsDetailID = m_pGoodsDetailObject.id;
        [m_tableview reloadData];
        [self refresh];
    } else if (!m_pGoodsDetailObject && m_pGoodsDetailID != 0) {
        [self ShowProgressHUD:ProgressHUDDurationTypeStay message:NSLocalizedString(@"加载ing", @"") mode:ProgressHUDModeTypeIndeterminate userInteractionEnable:YES];
        [[GoodsNetworking new] Get:[NSNumber numberWithInteger:m_pGoodsDetailID] success:^(GoodsModel *response) {
            [self HideProgressHUD];
            m_pGoodsDetailObject = response;
            [m_tableview reloadData];
            [self refresh];
        } fail:^(HttpResponseJson *response) {
            [self HideProgressHUD];
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s message:NSLocalizedString(@"网络错误哦", @"") mode:ProgressHUDModeTypeText userInteractionEnable:YES];
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    //[m_tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pushToCart
{
    CartListVC *cart_listVC = [[CartListVC alloc]initWithNibName:(NSString *)m_cart_bottomView bundle:nil];
    
    [self.navigationController pushViewController:cart_listVC animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2 + m_arr_comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [m_tableview dequeueReusableCellWithIdentifier:@"GoodsDetailItem"];
        [((GoodsDetailTVC *)cell) LoadGoods:m_pGoodsDetailObject];
    } else if (indexPath.row == 1) {
        cell = [m_tableview dequeueReusableCellWithIdentifier:@"GoodsDetailIntroItem"];
        [((GoodsIntroductionTVC *)cell) LoadData:m_pGoodsDetailObject];
    } else {
        cell = [m_tableview dequeueReusableCellWithIdentifier:@"GoodsCommentItem"];
        GoodsCommentModel *comment_obj = [m_arr_comments objectAtIndex:indexPath.row - 1];
        NSURL *url = [[comment_obj.User.Avatar AppendServerURL] ToURL];
        [((GoodsCommentTVC *)cell).AvatarIV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"PBUI-BG"]];;
        [((GoodsCommentTVC *)cell).AvatarIV.layer setCornerRadius:((GoodsCommentTVC *)cell).AvatarIV.bounds.size.width / 2.0];
        ((GoodsCommentTVC *)cell).NameL.text = comment_obj.User.NickName;
        ((GoodsCommentTVC *)cell).ContentL.text = comment_obj.Content;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return self.view.frame.size.width + 220.0;
    } else if (indexPath.row == 1) {
        return 235.0;
    } else {
        return 200.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50.0;
}

- (void)refresh
{
    [m_view_bottom IsFavour:m_pGoodsDetailObject.IsFavor];
}

- (void)chat
{
    NSString *username = [[NSNumber numberWithInteger:m_pGoodsDetailObject.Seller.id] stringValue];
    ChatViewController *chat_vc = [[ChatViewController alloc]
                                   initWithConversationChatter:username
                                   conversationType:eConversationTypeChat];
    chat_vc.title = m_pGoodsDetailObject.Seller.NickName;
    [self.navigationController pushViewController:chat_vc animated:YES];
}

- (void)favour
{
    GoodsFavourNetworking *networking = [[GoodsFavourNetworking alloc]
                                         initWithGoodsID:[NSNumber numberWithInteger:m_pGoodsDetailObject.id]];
    if (m_pGoodsDetailObject.IsFavor) {
        [networking Delete:^(HttpResponseJson *response) {
            [m_view_bottom IsFavour:NO];
            [self ShowProgressHUD:(ProgressHUDDurationTypeSoon1_5s)
                          message:NSLocalizedString(@"喜欢！", @"")
                             mode:(ProgressHUDModeTypeText)
            userInteractionEnable:YES];
        } fail:^(HttpResponseJson *response) {
            [self ShowProgressHUD:(ProgressHUDDurationTypeSoon1_5s)
                          message:NSLocalizedString(@"已喜欢", @"")
                             mode:(ProgressHUDModeTypeText)
            userInteractionEnable:YES];
        }];
    } else {
        [networking Create:^(HttpResponseJson *response) {
            [m_view_bottom IsFavour:YES];
            [self ShowProgressHUD:(ProgressHUDDurationTypeSoon1_5s)
                          message:NSLocalizedString(@"收藏！", @"")
                             mode:(ProgressHUDModeTypeText)
            userInteractionEnable:YES];
        } duplicated:^(HttpResponseJson *response) {
            [self ShowProgressHUD:(ProgressHUDDurationTypeSoon1_5s)
                          message:NSLocalizedString(@"已收藏过", @"")
                             mode:(ProgressHUDModeTypeText)
            userInteractionEnable:YES];
        } fail:^(HttpResponseJson *response) {
            [self ShowProgressHUD:(ProgressHUDDurationTypeSoon1_5s)
                          message:NSLocalizedString(@"收藏失败…", @"")
                             mode:(ProgressHUDModeTypeText)
            userInteractionEnable:YES];
        }];
    }
}

- (void)add_to_cart
{
    [self ShowProgressHUD:(ProgressHUDDurationTypeStay)
                  message:NSLocalizedString(@"正在加入购物车", @"")
                     mode:(ProgressHUDModeTypeText)
    userInteractionEnable:YES];
    [[CartNetworking new] Create:[NSNumber numberWithInteger:m_pGoodsDetailObject.id] success:^(CartItemModel *cart) {
        
        [self HideProgressHUD];
        [self ShowProgressHUD:(ProgressHUDDurationTypeSoon1_5s)
                      message:NSLocalizedString(@"加入成功", @"")
                         mode:(ProgressHUDModeTypeText)
        userInteractionEnable:YES];
        
    } fail:^(HttpResponseJson *response) {
        
        [self HideProgressHUD];
        if (response.StatusCode == 403) {
            [self ShowProgressHUD:(ProgressHUDDurationTypeSoon1_5s)
                          message:NSLocalizedString(@"加入失败，库存不足", @"")
                             mode:(ProgressHUDModeTypeText)
            userInteractionEnable:YES];
        } else {
            [self ShowProgressHUD:(ProgressHUDDurationTypeSoon1_5s)
                          message:NSLocalizedString(@"加入失败", @"")
                             mode:(ProgressHUDModeTypeText)
            userInteractionEnable:YES];
        }
        
    }];
}

- (void)buy_now
{
    [self ShowProgressHUD:(ProgressHUDDurationTypeStay)
                  message:NSLocalizedString(@"正在生成订单", @"")
                     mode:(ProgressHUDModeTypeIndeterminate)
    userInteractionEnable:YES];
    [[OrderNetworking new] CreateFromGoods:[NSNumber numberWithInteger:m_pGoodsDetailObject.id] success:^(CartModel *response) {
        
        [self HideProgressHUD];
        OrderConfirmVC *vc = [[UIStoryboard storyboardWithName:@"Shop" bundle:nil]
                              instantiateViewControllerWithIdentifier:@"OrderConfirmVC"];
        vc.CartObject = response;
        [self.navigationController pushViewController:vc
                                             animated:YES];
        
    } fail:^(HttpResponseJson *response) {
        
        [self HideProgressHUD];
        [self ShowProgressHUD:(ProgressHUDDurationTypeSoon1_5s)
                      message:NSLocalizedString(@"生成订单失败", @"")
                         mode:(ProgressHUDModeTypeText)
        userInteractionEnable:YES];
        
    }];
}

@end
