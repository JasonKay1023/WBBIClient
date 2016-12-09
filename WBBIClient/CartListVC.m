//
//  CartListVC.m
//  WBBIClient
//
//  Created by 黃韜 on 6/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "CartListVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJExtension.h>
#import "UIViewController+ProgressHUD.h"
#import "CartItemModel.h"
#import "CartSellerItemModel.h"
#import "UserModel.h"
#import "CartItemTVC.h"
#import "CartNetworking.h"
#import "OrderNetworking.h"
#import "OrderConfirmVC.h"
#import "CartBottomConfirmV.h"
#import "NSString+URL.h"
#import "ActionSheetHandler.h"

#define BottomBarHeight 50.0

@interface CartListVC () <UITableViewDelegate, UITableViewDataSource, CartItemDelegate>
{
    ActionSheetHandler *as_handler;
    UITableView *_tableView;
    CartBottomConfirmV *_bottomView;
    NSMutableDictionary *_dict_changed;
}

@property (strong, nonatomic) CartModel *cart;
@property (strong, nonatomic) NSMutableArray *cartItemList;
@property (strong, nonatomic) NSMutableArray *choicesCartItem;
@property (strong, nonatomic) NSMutableArray *choicesSellerItem;

- (IBAction)BackBBPressed:(id)sender;

@end

@implementation CartListVC

@synthesize cart = m_cart_instance;
@synthesize cartItemList = m_arr_cartitem;
@synthesize choicesCartItem = m_arr_cartitemchoices;
@synthesize choicesSellerItem = m_arr_selleritemchoices;

- (void)viewDidLoad {
    m_arr_cartitem = [NSMutableArray arrayWithCapacity:3];
    m_arr_cartitemchoices = [NSMutableArray arrayWithCapacity:3];
    m_arr_selleritemchoices = [NSMutableArray arrayWithCapacity:3];
    _dict_changed = [NSMutableDictionary dictionary];
    
    [super viewDidLoad];
    
    self.navigationController.navigationBar.clipsToBounds = NO;
    
    self.title = NSLocalizedString(@"购物车", @"");
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"CartItemCell" bundle:nil]
     forCellReuseIdentifier:@"CartItemCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"CartItemTitleCell" bundle:nil]
     forCellReuseIdentifier:@"TitleCell"];
    
    //BottomBarView *view = [[[NSBundle mainBundle] loadNibNamed:@"BottomBarView" owner:self options:nil] lastObject];
    _bottomView = [[[NSBundle mainBundle] loadNibNamed:@"CartBottomConfirmV" owner:self options:nil] lastObject];
    _bottomView.frame = CGRectMake(0,
                                   self.view.bounds.size.height - BottomBarHeight,
                                   self.view.bounds.size.width,
                                   BottomBarHeight);
    _bottomView.ConfirmB.enabled = NO;
    [_bottomView.ConfirmB addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bottomView];
    [self.view bringSubviewToFront:_bottomView];
    
    [self ShowProgressHUD:ProgressHUDDurationTypeStay
                  message:NSLocalizedString(@"加载ing", @"")
                     mode:ProgressHUDModeTypeIndeterminate
    userInteractionEnable:YES];
    [[CartNetworking new] Get:^(CartModel *cart) {
        [self HideProgressHUD];
        if (cart.CartItems == nil) {
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"购物车无内容", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
        } else {
            m_cart_instance = [CartModel mj_objectWithKeyValues:cart];
            [m_arr_cartitem addObjectsFromArray: [CartSellerItemModel mj_objectArrayWithKeyValuesArray:cart.CartItems]];
            [self load_bottom_view];
            [_tableView reloadData];
        }
        //[self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
        //              message:NSLocalizedString(@"", @"")
        //                 mode:ProgressHUDModeTypeText
        //userInteractionEnable:YES];
    } fail:^(HttpResponseJson *response) {
        [self HideProgressHUD];
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:NSLocalizedString(@"加载失败", @"")
                         mode:ProgressHUDModeTypeText
        userInteractionEnable:YES];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    _tableView.frame = CGRectMake(0,
                                  0,
                                  self.view.bounds.size.width,
                                  self.view.bounds.size.height - BottomBarHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return m_arr_cartitem.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    CartSellerItemModel *obj = [m_arr_cartitem objectAtIndex:section];
    return obj.CartItems.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    CartSellerItemModel *seller_item = [m_arr_cartitem objectAtIndex:indexPath.section];
    UserModel *seller = seller_item.Seller;
    if (indexPath.row == 0) { // header
        // Title cell
        cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
        cell.textLabel.text = seller.NickName;
        
    } else { // content
        // Cart item cell
        cell = [tableView dequeueReusableCellWithIdentifier:@"CartItemCell"];
        CartItemModel *cart_item = [[CartItemModel mj_objectArrayWithKeyValuesArray:seller_item.CartItems] objectAtIndex:indexPath.row - 1];
        GoodsModel *goods = cart_item.Goods;
        NSURL *url = [[goods.PhotoFront AppendServerURL] ToURL];
        [((CartItemTVC *)cell).AvatarIV sd_setImageWithURL:url];
        ((CartItemTVC *)cell).AvatarIV.backgroundColor = [UIColor lightGrayColor];
        [((CartItemTVC *)cell) CartItemID:cart_item.id
                                 quantity:[cart_item.Quantity integerValue]
                             max_quantity:goods.StockCount
                                 delegate:self];
        ((CartItemTVC *)cell).BrandL.text = goods.Brand;
        ((CartItemTVC *)cell).TitleL.text = goods.Title;
        ((CartItemTVC *)cell).PriceL.text = [goods.Price stringValue];
        ((CartItemTVC *)cell).QuantityL.text = [cart_item.Quantity stringValue];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartSellerItemModel *seller_item = [m_arr_cartitem objectAtIndex:indexPath.section];
    NSArray *cart_items = seller_item.CartItems;
    if (indexPath.row == 0) {
        if ([m_arr_selleritemchoices containsObject:seller_item]) {
            [m_arr_selleritemchoices removeObject:seller_item];
            for (CartItemModel *cart_item in cart_items) {
                [m_arr_cartitemchoices removeObject:cart_item];
            }
            for (NSInteger item_id = 0; item_id != cart_items.count + 1; ++item_id) {
                [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:item_id inSection:indexPath.section]]
                .accessoryType = UITableViewCellAccessoryNone;
            }
        } else {
            [m_arr_selleritemchoices addObject:seller_item];
            for (CartItemModel *cart_item in cart_items) {
                [m_arr_cartitemchoices addObject:cart_item];
            }
            for (NSInteger item_id = 0; item_id != cart_items.count + 1; ++item_id) {
                [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:item_id inSection:indexPath.section]]
                .accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    } else {
        CartItemModel *cart_item = [cart_items objectAtIndex:indexPath.row - 1];
        if ([m_arr_cartitemchoices containsObject:cart_item]) {
            [m_arr_cartitemchoices removeObject:cart_item];
            [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section]]
            .accessoryType = UITableViewCellAccessoryNone;
            [_tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        } else {
            [m_arr_cartitemchoices addObject:cart_item];
            [_tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            NSInteger cell_num = [_tableView numberOfRowsInSection:indexPath.section];
            if (cell_num == cart_items.count + 1) {
                [[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section]]
                setAccessoryType: UITableViewCellAccessoryCheckmark];
            } else {
                [[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section]]
                setAccessoryType: UITableViewCellAccessoryNone];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40.0;
    } else {
        return 140.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20.0;
    } else {
        return 5.0;
    }
}

- (void)CartItemID:(NSInteger)cart_id Count:(NSInteger)count Cell:(UITableViewCell *)cell
{
    CartItemModel *cart_item = nil;
    for (CartSellerItemModel *seller_item in m_arr_cartitem) {
        NSArray *cart_items = seller_item.CartItems;
        for (CartItemModel *obj in [CartItemModel mj_objectArrayWithKeyValuesArray:cart_items]) {
            if (obj.id == cart_id) {
                cart_item = obj;
            }
        }
    }
    if (!cart_item) {
        return;
    }
    [_dict_changed setObject:[NSNumber numberWithInteger:count]
                      forKey:[NSNumber numberWithInteger:cart_id]];
    if (count == 0) {
        NSString *title = NSLocalizedString(@"删除购物车项", @"");
        NSString *message = NSLocalizedString(@"确认要删除购物车项？", @"");
        NSString *confirmTitle = NSLocalizedString(@"是", @"");
        NSString *cancelTitle = NSLocalizedString(@"否", @"");
        as_handler = [ActionSheetHandler new];
        [as_handler ShowActionSheet:self title:title message:message confirmTitle:confirmTitle confirmAction:^{
            
            [self ShowProgressHUD:ProgressHUDDurationTypeStay
                          message:NSLocalizedString(@"正在删除", @"")
                             mode:ProgressHUDModeTypeIndeterminate
            userInteractionEnable:YES];
            [[CartNetworking new] Delete:[NSNumber numberWithInteger:cart_item.id] success:^(HttpResponseJson *response) {
                
                [self HideProgressHUD];
                
                NSIndexPath *index_path = [_tableView indexPathForCell:cell];
                CartSellerItemModel *seller_item = [m_arr_cartitem objectAtIndex:index_path.section];
                if (seller_item.CartItems.count == 1) {
                    [m_arr_cartitem removeObjectAtIndex:index_path.section];
                } else {
                    [[[m_arr_cartitem objectAtIndex:index_path.section] CartItems] removeObjectAtIndex:index_path.row];
                }
                
                //[m_arr_cartitem removeObject:cart_item];
                [m_arr_cartitemchoices removeObject:cart_item];
                [_tableView reloadData];
                
                [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                              message:NSLocalizedString(@"删除成功", @"")
                                 mode:ProgressHUDModeTypeText
                userInteractionEnable:YES];
                
            } fail:^(HttpResponseJson *response) {
                
                [self HideProgressHUD];
                
                [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                              message:NSLocalizedString(@"删除失败", @"")
                                 mode:ProgressHUDModeTypeText
                userInteractionEnable:YES];
                
            }];
            
        } cancelTitle:cancelTitle cancelAction:^{
            
            [((CartItemTVC *)cell) Quantity:1];
            
        }];
    }
}

#pragma mark - Changes

- (void)changes:(void(^)())when_success
{
    /*
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:_dict_changed.count];
    for (NSNumber *key in [_dict_changed allKeys]) {
        [params setObject:key forKey:@"cart_item_id"];
        [params setObject:[_dict_changed objectForKey:key] forKey:@"quantity"];
    }*/
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:_dict_changed.count];
    for (NSNumber *key in [_dict_changed allKeys]) {
        [params addObject:@{
                           @"cart_item_id": key,
                           @"quantity": [_dict_changed objectForKey:key]
                           }];
    }
    NSDictionary *sub_params = @{
                                 @"cart_items": params,
                                 };
    [[CartNetworking new] Update:sub_params success:^(HttpResponseJson *response) {
        
        when_success();
        
    } fail:^(HttpResponseJson *response) {
        
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:NSLocalizedString(@"更改失败", @"")
                         mode:ProgressHUDModeTypeText
        userInteractionEnable:YES];
        
    }];
}

#pragma mark - Bottom view

- (void)load_bottom_view
{
    _bottomView.PriceL.text = [m_cart_instance.Subtotal stringValue];
    _bottomView.ConfirmB.enabled = YES;
}

- (void)confirm
{
    if (m_arr_cartitemchoices.count == 0) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:NSLocalizedString(@"未选定任何的购物车项", @"")
                         mode:ProgressHUDModeTypeText
        userInteractionEnable:YES];
    } else {
        
        if (_dict_changed.count != 0) {
            
            [self changes:^{
                
                NSMutableArray *arr_items = [NSMutableArray array];
                for (NSDictionary *cart_item in m_arr_cartitemchoices) {
                    [arr_items addObject:[cart_item objectForKey:@"id"]];
                }
                [[OrderNetworking new] CreateFromCart:arr_items success:^(CartModel *response) {
                    
                    OrderConfirmVC *vc = [[UIStoryboard storyboardWithName:@"Shop" bundle:nil]
                                          instantiateViewControllerWithIdentifier:@"OrderConfirmVC"];
                    vc.CartObject = response;
                    [self.navigationController pushViewController:vc
                                                         animated:YES];
                    
                } fail:^(HttpResponseJson *response) {
                    
                    [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                                  message:NSLocalizedString(@"订单生成失败", @"")
                                     mode:ProgressHUDModeTypeText
                    userInteractionEnable:YES];
                    
                }];
                
            }];
            
        } else {
            
            NSMutableArray *arr_items = [NSMutableArray array];
            for (NSDictionary *cart_item in m_arr_cartitemchoices) {
                [arr_items addObject:[cart_item objectForKey:@"id"]];
            }
            [[OrderNetworking new] CreateFromCart:arr_items success:^(CartModel *response) {
                
                OrderConfirmVC *vc = [[UIStoryboard storyboardWithName:@"Shop" bundle:nil]
                                      instantiateViewControllerWithIdentifier:@"OrderConfirmVC"];
                vc.CartObject = response;
                [self.navigationController pushViewController:vc
                                                     animated:YES];
                
            } fail:^(HttpResponseJson *response) {
                
                [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                              message:NSLocalizedString(@"订单生成失败", @"")
                                 mode:ProgressHUDModeTypeText
                userInteractionEnable:YES];
                
            }];
            
        }
    }
}

- (void)disable_button
{
    _bottomView.ConfirmB.enabled = NO;
}

- (void)enable_button
{
    _bottomView.ConfirmB.enabled = YES;
}

- (void)set_price_to_bottom:(NSNumber *)price
{
    _bottomView.PriceL.text = [price stringValue];
}

- (IBAction)BackBBPressed:(id)sender
{
    [_delegate showFront];
}

@end
