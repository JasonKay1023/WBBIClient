//
//  OrderListVC.m
//  WBBIClient
//
//  Created by 黃韜 on 21/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "OrderListVC.h"
#import <UIImageView+HeadImage.h>
#import "NSString+URL.h"
#import "GoodsItemTVC.h"
//#import "UIView+Style.h"
#import "OrderStatusShortcutTVC.h"
#import "OrderDetailVC.h"
#import "OrderNetworking.h"

@interface OrderListVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *m_table;
@property (strong, nonatomic) OrderListModel *m_arr_orders;

@property (strong, nonatomic) IBOutlet UIButton *AllOrderB;
@property (strong, nonatomic) IBOutlet UIButton *OnSaleGoodsB;
@property (strong, nonatomic) IBOutlet UIButton *WaitSendGoodsB;
@property (strong, nonatomic) IBOutlet UIButton *WaitCommentB;
@property (strong, nonatomic) IBOutlet UIButton *AnotherOrderB;

- (IBAction)BackBBPressed:(UIBarButtonItem *)sender;

@end

@implementation OrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.clipsToBounds = NO;
    self.title = NSLocalizedString(@"订单列表", @"");
    _m_table.delegate = self;
    _m_table.dataSource = self;
    _m_table.tableHeaderView.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    
    [_AllOrderB addTarget:self action:@selector(header_button_pressed:) forControlEvents:(UIControlEventTouchUpInside)];
    [_OnSaleGoodsB addTarget:self action:@selector(header_button_pressed:) forControlEvents:(UIControlEventTouchUpInside)];
    [_WaitSendGoodsB addTarget:self action:@selector(header_button_pressed:) forControlEvents:(UIControlEventTouchUpInside)];
    [_WaitCommentB addTarget:self action:@selector(header_button_pressed:) forControlEvents:(UIControlEventTouchUpInside)];
    [_AnotherOrderB addTarget:self action:@selector(header_button_pressed:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [[[OrderNetworking alloc] init] GetOrderList:(OrderStatusAll) success:^(OrderListModel *response) {
        
        _m_arr_orders = response;
        [_m_table reloadData];
        
    } fail:^(HttpResponseJson *response) {
        
        
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *index_path = [_m_table indexPathForSelectedRow];
    if (index_path) {
        [_m_table deselectRowAtIndexPath:index_path animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _m_arr_orders.Orders.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    OrderInfoModel *order_info = [_m_arr_orders.Orders objectAtIndex:indexPath.section];
    NSString *order_status = order_info.Status.Status;
    GoodsModel *order_goods = [order_info.OrderItem objectAtIndex:0].Goods;
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        [((GoodsItemTVC *)cell).GoodsAvatarIV sd_setImageWithURL:[[order_goods.PhotoFront AppendServerPhotoURL] ToURL]];
        ((GoodsItemTVC *)cell).SellerNameL.text = order_goods.Seller.NickName;
        ((GoodsItemTVC *)cell).GoodsNameL.text = order_goods.Title;
        ((GoodsItemTVC *)cell).GoodsDetailTV.text = order_goods.Introduction;
        ((GoodsItemTVC *)cell).PriceL.text = [order_info.Order.Subtotal stringValue];
        //[((GoodsItemTVC *)cell).GoodsAvatarIV SetCornerRadius:((GoodsItemTVC *)cell).GoodsAvatarIV.frame.size.width / 2.0];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else if (indexPath.row == 1) {
        if ([order_status isEqualToString:@"WaitBuyerPay"]) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"WaitBuyerPay"];
            ((OrderStatusShortcutTVC *)cell).Status = @"WaitBuyerPay";
            [((OrderStatusShortcutTVC *)cell).FirstB addTarget:self
                                                        action:@selector(cell_button_pressed:)
                                              forControlEvents:(UIControlEventTouchUpInside)];
            ((OrderStatusShortcutTVC *)cell).FirstB.tag = indexPath.section;
            
        } else if ([order_status isEqualToString:@"WaitSellerSendGoods"]) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"WaitSellerSendGoods"];
            ((OrderStatusShortcutTVC *)cell).Status = @"WaitSellerSendGoods";
            [((OrderStatusShortcutTVC *)cell).FirstB addTarget:self
                                                        action:@selector(cell_button_pressed:)
                                              forControlEvents:(UIControlEventTouchUpInside)];
            ((OrderStatusShortcutTVC *)cell).FirstB.tag = indexPath.section;
            [((OrderStatusShortcutTVC *)cell).SecondB addTarget:self
                                                         action:@selector(cell_button_pressed:)
                                               forControlEvents:(UIControlEventTouchUpInside)];
            ((OrderStatusShortcutTVC *)cell).SecondB.tag = indexPath.section;
            
        } else if ([order_status isEqualToString:@"WaitBuyerSignFor"]) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"WaitBuyerSignFor"];
            ((OrderStatusShortcutTVC *)cell).Status = @"WaitBuyerSignFor";
            [((OrderStatusShortcutTVC *)cell).FirstB addTarget:self
                                                        action:@selector(cell_button_pressed:)
                                              forControlEvents:(UIControlEventTouchUpInside)];
            ((OrderStatusShortcutTVC *)cell).FirstB.tag = indexPath.section;
            [((OrderStatusShortcutTVC *)cell).SecondB addTarget:self
                                                         action:@selector(cell_button_pressed:)
                                               forControlEvents:(UIControlEventTouchUpInside)];
            ((OrderStatusShortcutTVC *)cell).SecondB.tag = indexPath.section;
            
        } else if ([order_status isEqualToString:@"TradeBuyerSigned"]) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"TradeBuyerSigned"];
            ((OrderStatusShortcutTVC *)cell).Status = @"TradeBuyerSigned";
            [((OrderStatusShortcutTVC *)cell).FirstB addTarget:self
                                                        action:@selector(cell_button_pressed:)
                                              forControlEvents:(UIControlEventTouchUpInside)];
            ((OrderStatusShortcutTVC *)cell).FirstB.tag = indexPath.section;
            [((OrderStatusShortcutTVC *)cell).SecondB addTarget:self
                                                         action:@selector(cell_button_pressed:)
                                               forControlEvents:(UIControlEventTouchUpInside)];
            ((OrderStatusShortcutTVC *)cell).SecondB.tag = indexPath.section;
            [((OrderStatusShortcutTVC *)cell).ThirdB addTarget:self
                                                        action:@selector(cell_button_pressed:)
                                              forControlEvents:(UIControlEventTouchUpInside)];
            ((OrderStatusShortcutTVC *)cell).ThirdB.tag = indexPath.section;
            
        } else if ([order_status isEqualToString:@"TradeOrderRefundFailed"]) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"TradeOrderRefundFailed"];
            ((OrderStatusShortcutTVC *)cell).Status = @"TradeOrderRefundFailed";
            [((OrderStatusShortcutTVC *)cell).FirstB addTarget:self
                                                        action:@selector(cell_button_pressed:)
                                              forControlEvents:(UIControlEventTouchUpInside)];
            ((OrderStatusShortcutTVC *)cell).FirstB.tag = indexPath.section;
            [((OrderStatusShortcutTVC *)cell).SecondB addTarget:self
                                                         action:@selector(cell_button_pressed:)
                                               forControlEvents:(UIControlEventTouchUpInside)];
            ((OrderStatusShortcutTVC *)cell).SecondB.tag = indexPath.section;
            [((OrderStatusShortcutTVC *)cell).ThirdB addTarget:self
                                                        action:@selector(cell_button_pressed:)
                                              forControlEvents:(UIControlEventTouchUpInside)];
            ((OrderStatusShortcutTVC *)cell).ThirdB.tag = indexPath.section;
            
        } else if ([order_status isEqualToString:@"TradeOrderRefundCanceled"]) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"TradeOrderRefundCanceled"];
            ((OrderStatusShortcutTVC *)cell).Status = @"TradeOrderRefundCanceled";
            [((OrderStatusShortcutTVC *)cell).FirstB addTarget:self
                                                        action:@selector(cell_button_pressed:)
                                              forControlEvents:(UIControlEventTouchUpInside)];
            ((OrderStatusShortcutTVC *)cell).FirstB.tag = indexPath.section;
            [((OrderStatusShortcutTVC *)cell).SecondB addTarget:self
                                                         action:@selector(cell_button_pressed:)
                                               forControlEvents:(UIControlEventTouchUpInside)];
            ((OrderStatusShortcutTVC *)cell).SecondB.tag = indexPath.section;
            [((OrderStatusShortcutTVC *)cell).ThirdB addTarget:self
                                                        action:@selector(cell_button_pressed:)
                                              forControlEvents:(UIControlEventTouchUpInside)];
            ((OrderStatusShortcutTVC *)cell).ThirdB.tag = indexPath.section;
            
        } else if ([order_status isEqualToString:@"TradeOrderRefund"]) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"TradeOrderRefund"];
            ((OrderStatusShortcutTVC *)cell).Status = @"TradeOrderRefund";
            [((OrderStatusShortcutTVC *)cell).FirstB addTarget:self
                                                        action:@selector(cell_button_pressed:)
                                              forControlEvents:(UIControlEventTouchUpInside)];
            ((OrderStatusShortcutTVC *)cell).FirstB.tag = indexPath.section;
            [((OrderStatusShortcutTVC *)cell).SecondB addTarget:self
                                                         action:@selector(cell_button_pressed:)
                                               forControlEvents:(UIControlEventTouchUpInside)];
            ((OrderStatusShortcutTVC *)cell).SecondB.tag = indexPath.section;
            
        } else if ([order_status isEqualToString:@"TradeFinished"]) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"TradeFinished"];
            ((OrderStatusShortcutTVC *)cell).Status = @"TradeFinished";
            [((OrderStatusShortcutTVC *)cell).FirstB addTarget:self
                                                        action:@selector(cell_button_pressed:)
                                              forControlEvents:(UIControlEventTouchUpInside)];
            ((OrderStatusShortcutTVC *)cell).FirstB.tag = indexPath.section;
            
        } else if ([order_status isEqualToString:@"TradeClosedByPlatform"]) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"TradeClosedByPlatform"];
            ((OrderStatusShortcutTVC *)cell).Status = @"TradeClosedByPlatform";
            [((OrderStatusShortcutTVC *)cell).FirstB addTarget:self
                                                        action:@selector(cell_button_pressed:)
                                              forControlEvents:(UIControlEventTouchUpInside)];
            ((OrderStatusShortcutTVC *)cell).FirstB.tag = indexPath.section;
            
        } else if ([order_status isEqualToString:@"TradeNotCreatePay"]) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"TradeNotCreatePay"];
            ((OrderStatusShortcutTVC *)cell).Status = @"TradeNotCreatePay";
            [((OrderStatusShortcutTVC *)cell).FirstB addTarget:self
                                                        action:@selector(cell_button_pressed:)
                                              forControlEvents:(UIControlEventTouchUpInside)];
            ((OrderStatusShortcutTVC *)cell).FirstB.tag = indexPath.section;
            
        } else if ([order_status isEqualToString:@"TradeClosed"]) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"TradeClosed"];
            ((OrderStatusShortcutTVC *)cell).Status = @"TradeClosed";
            [((OrderStatusShortcutTVC *)cell).FirstB addTarget:self
                                                        action:@selector(cell_button_pressed:)
                                              forControlEvents:(UIControlEventTouchUpInside)];
            ((OrderStatusShortcutTVC *)cell).FirstB.tag = indexPath.section;
            
        }
        cell.tag = indexPath.section;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        OrderDetailVC *vc = [[UIStoryboard storyboardWithName:@"Order" bundle:nil]
                             instantiateViewControllerWithIdentifier:@"OrderDetailVC"];
        vc.OrderInstance = [_m_arr_orders.Orders objectAtIndex:indexPath.section];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 135.0;
    } else if (indexPath.row == 1) {
        return 50.0;
    }
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section
{
    if (section == [tableView numberOfSections] - 1) {
        return 10.0;
    } else {
        return 0.01;
    }
}

- (IBAction)BackBBPressed:(UIBarButtonItem *)sender
{
    [_delegate showFront];
}

- (void)header_button_pressed:(UIButton *)button
{
    if (button == _AllOrderB) {
        
        
        
    } else if (button == _OnSaleGoodsB) {
        
        
        
    } else if (button == _WaitSendGoodsB) {
        
        
        
    } else if (button == _WaitCommentB) {
        
        
        
    } else if (button == _AnotherOrderB) {
        
        
        
    }
}

- (void)cell_button_pressed:(UIButton *)button
{
    NSInteger section_num = button.tag;
    OrderStatusShortcutTVC *cell = [_m_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:section_num]];
    if ([cell.Status isEqualToString:@"WaitSellerSendGoods"]) {
        
        if (button == cell.FirstB) {
            
        } else if (button == cell.SecondB) {
            
        }
        
    } else if ([cell.Status isEqualToString:@"WaitBuyerSignFor"]) {
        
        if (button == cell.FirstB) {
            
        } else if (button == cell.SecondB) {
            
        }
        
    } else if ([cell.Status isEqualToString:@"TradeBuyerSigned"]) {
        
        if (button == cell.FirstB) {
            
        } else if (button == cell.SecondB) {
            
        } else if (button == cell.ThirdB) {
            
        }
        
    } else if ([cell.Status isEqualToString:@"TradeFinished"]) {
        
        if (button == cell.FirstB) {
            
        }
        
    } else if ([cell.Status isEqualToString:@"TradeOrderRefund"]) {
        
        if (button == cell.FirstB) {
            
        } else if (button == cell.SecondB) {
            
        }
        
    } else if ([cell.Status isEqualToString:@"TradeClosed"]) {
        
        if (button == cell.FirstB) {
            
        }
        
    } else if ([cell.Status isEqualToString:@"WaitBuyerPay"]) {
        
        if (button == cell.FirstB) {
            
        }
        
    }
}

@end
