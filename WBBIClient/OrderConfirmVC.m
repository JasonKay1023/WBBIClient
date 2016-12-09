//
//  OrderConfirmVC.m
//  WBBIClient
//
//  Created by 黃韜 on 6/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "OrderConfirmVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJExtension.h>
#import "UIViewController+ProgressHUD.h"
#import "UserModel.h"
#import "UserAddressTVC.h"
#import "UserAddressModel.h"
#import "UserAddressListVC.h"
#import "OrderNetworking.h"
#import "CartNetworking.h"
#import "CartItemTVC.h"
#import "CartItemMessageTVC.h"
#import "CartSellerItemModel.h"
#import "CartItemModel.h"
#import "NSString+URL.h"
#import "CartBottomConfirmV.h"
#import "NSString+URL.h"
#import "ActionSheetHandler.h"
#import "AlipayPayAction.h"
#import "NSDate+String.h"

#define BottomBarHeight 50.0

@interface OrderConfirmVC () <UITableViewDelegate, UITableViewDataSource, UserAddressDelegate, UITextViewDelegate>
{
    ActionSheetHandler *as_handler;
    UITableView *_tableView;
    CartBottomConfirmV *_bottomView;
    NSMutableDictionary *_dict_changed;
    NSIndexPath *selected_indexpath;
}

@property (strong, nonatomic) NSMutableArray *cartItemList;
@property (strong, nonatomic) NSMutableArray *choicesCartItem;
@property (strong, nonatomic) NSMutableArray *choicesSellerItem;
@property (strong, nonatomic) UserAddressModel *addressObject;

//TitleCell
//CartItemCell
//CartMessageItem

@end

@implementation OrderConfirmVC

@synthesize CartObject = m_cart_instance;
@synthesize cartItemList = m_arr_cartitem;
@synthesize choicesCartItem = m_arr_cartitemchoices;
@synthesize choicesSellerItem = m_arr_selleritemchoices;

- (void)viewDidLoad {
    
    self.IsEditMode = YES;
    
    [super viewDidLoad];
    self.navigationController.navigationBar.clipsToBounds = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboard_will_show:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboard_will_hide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.title = NSLocalizedString(@"订单确认", @"");
    
    //_cartItemsArray = [NSMutableArray arrayWithCapacity:3];
    m_arr_cartitem = [NSMutableArray arrayWithCapacity:3];
    m_arr_cartitemchoices = [NSMutableArray arrayWithCapacity:3];
    m_arr_selleritemchoices = [NSMutableArray arrayWithCapacity:3];
    _dict_changed = [NSMutableDictionary dictionary];
    
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    
    [_tableView registerNib:[UINib nibWithNibName:@"UserAddressCell" bundle:nil]
     forCellReuseIdentifier:@"AddressCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"CartItemCell" bundle:nil]
     forCellReuseIdentifier:@"CartItemCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"CartItemTitleCell" bundle:nil]
     forCellReuseIdentifier:@"TitleCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"CartItemDetailCell" bundle:nil]
     forCellReuseIdentifier:@"CartItemMessageCell"];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
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
    if (!m_cart_instance) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:NSLocalizedString(@"订单初始化失败了！", @"")
                         mode:ProgressHUDModeTypeText
        userInteractionEnable:YES];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [m_arr_cartitem addObjectsFromArray: [CartSellerItemModel mj_objectArrayWithKeyValuesArray:m_cart_instance.CartItems]];
    _addressObject = m_cart_instance.DefaultAddress;
    [self load_bottom_view];
    [_tableView reloadData];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 + m_arr_cartitem.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return [[m_arr_cartitem objectAtIndex:section - 1] CartItems].count + 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell"];
        ((UserAddressTVC *)cell).AddressDetail.text = [_addressObject.Place.Shortcut stringByAppendingString:_addressObject.Address];
        ((UserAddressTVC *)cell).BuyerName.text = _addressObject.BuyerName;
        ((UserAddressTVC *)cell).Phone.text = _addressObject.Phone;
        
    } else {
        /*
        NSArray *index = [self dataContentForIndex:indexPath.row - 1];
        if ([index[1] isEqual:@(-1)]) { // header
            // Title cell
            cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
            CartSellerItemModel *seller_item = [_cartItemsArray objectAtIndex:[index[0] integerValue]];
            cell.textLabel.text = seller_item.Seller.NickName;
            
        } else if ([index[1] isEqual:@(-2)]) { // footer
            // Cart item message cell
            cell = [tableView dequeueReusableCellWithIdentifier:@"CartItemMessageCell"];
            ((CartItemMessageTVC *)cell).DiscountL.text = @"Discount Price";
            
        } else { // content
            // Cart item cell
            cell = [tableView dequeueReusableCellWithIdentifier:@"CartItemCell"];
            CartSellerItemModel *seller_item = [_cartItemsArray objectAtIndex:[index[0] integerValue]];
            CartItemModel *cart_item = [seller_item.CartItems objectAtIndex:[index[1] integerValue]];
            NSURL *url = [[cart_item.Goods.PhotoFront AppendServerURL] ToURL];
            [((CartItemTVC *)cell).AvatarIV sd_setImageWithURL:url];
            ((CartItemTVC *)cell).BrandL.text = cart_item.Goods.Brand;
            ((CartItemTVC *)cell).TitleL.text = cart_item.Goods.Title;
            ((CartItemTVC *)cell).PriceL.text = [cart_item.Goods.Price stringValue];
            ((CartItemTVC *)cell).QuantityL.text = [cart_item.Quantity stringValue];
            //((CartItemTVC *)cell).;
            //NSURL *url = [[m_pGoodsDetailObject.Seller.Avatar AppendServerURL] ToURL];
            //[((CartItemTVC *)cell).AvatarIV sd_setImageWithURL:url];
            
        }*/
        
        CartSellerItemModel *seller_item = [m_arr_cartitem objectAtIndex:indexPath.section - 1];
        if (indexPath.row == 0) { // header
            // Title cell
            cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
            cell.textLabel.text = seller_item.Seller.NickName;
            
        } else if (indexPath.row == seller_item.CartItems.count + 1) { // footer
            // Cart item message cell
            cell = [tableView dequeueReusableCellWithIdentifier:@"CartItemMessageCell"];
            ((CartItemMessageTVC *)cell).DiscountL.text = @"包包券折扣";
            ((CartItemMessageTVC *)cell).MessageTV.delegate = self;
            ((CartItemMessageTVC *)cell).MessageTV.tag = indexPath.section;
            
        } else { // content
            // Cart item cell
            cell = [tableView dequeueReusableCellWithIdentifier:@"CartItemCell"];
            CartItemModel *cart_item = [CartItemModel mj_objectWithKeyValues:[seller_item.CartItems objectAtIndex:indexPath.row - 1]];
            NSURL *url = [[cart_item.Goods.PhotoFront AppendServerURL] ToURL];
            [((CartItemTVC *)cell).AvatarIV sd_setImageWithURL:url];
            ((CartItemTVC *)cell).BrandL.text = cart_item.Goods.Brand;
            ((CartItemTVC *)cell).TitleL.text = cart_item.Goods.Title;
            ((CartItemTVC *)cell).PriceL.text = [cart_item.Goods.Price stringValue];
            ((CartItemTVC *)cell).QuantityL.text = [cart_item.Quantity stringValue];
            ((CartItemTVC *)cell).Increase.enabled = NO;
            ((CartItemTVC *)cell).Decrease.enabled = NO;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        UserAddressListVC *vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]
                                 instantiateViewControllerWithIdentifier:@"UserAddressListVC"];
        vc.Delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    selected_indexpath = indexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 45.0;
    if (indexPath.section == 0) {
        height = 100.0;
    } else if (indexPath.section != 0) {
        if (indexPath.row == 0) {
            return 40.0;
        } else {
            return 140.0;
        }
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    } else {
        return 5.0;
    }
}

- (void)Address:(UserAddressModel *)address
{
    _addressObject = address;
    [_tableView reloadData];
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
                
                [m_arr_cartitem removeObject:cart_item];
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

#pragma mark - Bottom view

- (void)load_bottom_view
{
    _bottomView.PriceL.text = [m_cart_instance.Subtotal stringValue];
    _bottomView.ConfirmB.enabled = YES;
}

- (void)confirm
{
//    if (m_arr_cartitemchoices.count == 0) {
//        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
//                      message:NSLocalizedString(@"更改失败", @"")
//                         mode:ProgressHUDModeTypeText
//        userInteractionEnable:YES];
//    } else {
//        NSMutableArray *arr_items = [NSMutableArray array];
//        for (CartItemModel *cart_item in m_arr_cartitemchoices) {
//            [arr_items addObject:[NSNumber numberWithInteger:cart_item.id]];
//        }
//        [[OrderNetworking new] CreateFromCart:arr_items success:^(CartModel *response) {
//            
//            OrderConfirmVC *vc = [[UIStoryboard storyboardWithName:@"Shop" bundle:nil]
//                                  instantiateViewControllerWithIdentifier:@"OrderConfirmVC"];
//            vc.CartObject = response;
//            [self.navigationController pushViewController:vc
//                                                 animated:YES];
//            
//        } fail:^(HttpResponseJson *response) {
//            
//            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
//                          message:NSLocalizedString(@"未选定任何的购物车项", @"")
//                             mode:ProgressHUDModeTypeText
//            userInteractionEnable:YES];
//            
//                }];
//    }
    NSDateFormatter *date_format = [[NSDateFormatter alloc] init];
    date_format.dateFormat = @"yyyy-MM-dd_HH:mm:ss";
    [[AlipayPayAction new] paymentWithTradeID:[NSString stringWithFormat:@"testing_%@", [[NSDate date] StringFromDateTime]]
                                      inPrice:[m_cart_instance.Subtotal floatValue]
                                     forGoods:[NSString stringWithFormat:@"testing_%@", [[NSDate date] StringFromDateTime]]
                                   withDetail:[NSString stringWithFormat:@"testing-detail_%@", [[NSDate date] StringFromDateTime]]];
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self HideKeyboard];
}

- (void)keyboard_will_show:(NSNotification *)notification
{
    CGSize keyboard_size = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets content_insets;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        content_insets = UIEdgeInsetsMake(0.0, 0.0, (keyboard_size.height), 0.0);
    } else {
        content_insets = UIEdgeInsetsMake(0.0, 0.0, (keyboard_size.width), 0.0);
    }
    _tableView.contentInset = content_insets;
    _tableView.scrollIndicatorInsets = content_insets;
    [_tableView scrollToRowAtIndexPath:selected_indexpath
                      atScrollPosition:UITableViewScrollPositionBottom
                              animated:YES];
}

- (void)keyboard_will_hide:(NSNotification *)notification
{
    _tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0);
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64.0, 0, 0, 0);
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSInteger section = textView.tag;
    NSInteger row = [_tableView numberOfRowsInSection:section] - 1;
    selected_indexpath = [NSIndexPath indexPathForRow:row inSection:section];
    return YES;
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
