//
//  OrderDetailVC.m
//  WBBIClient
//
//  Created by 黃韜 on 26/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "OrderDetailVC.h"
#import "GoodsDetailVC.h"
#import "GoodsItemTVC.h"
#import "OrderStatusDetailTVC.h"
#import "NSString+URL.h"
#import "OrderNetworking.h"

@interface OrderDetailVC () <UITableViewDataSource, UITableViewDelegate>
{
    BOOL m_b_seller;
}

@property (strong, nonatomic) IBOutlet UITableView *m_table;
@property (strong, nonatomic) OrderListModel *m_arr_orders;

@end

@implementation OrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _m_table.dataSource = self;
    _m_table.delegate = self;
    
    self.title = NSLocalizedString(@"订单详情", @"");
    self.navigationController.navigationBar.translucent = NO;
    
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else {
        return 12;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    OrderInfoModel *order_info = [_m_arr_orders.Orders objectAtIndex:indexPath.section];
    NSString *order_status = order_info.Status.Status;
    GoodsModel *order_goods = [order_info.OrderItem objectAtIndex:0].Goods;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [_m_table dequeueReusableCellWithIdentifier:@"Cell"];
            [((GoodsItemTVC *)cell).GoodsAvatarIV sd_setImageWithURL:[[order_goods.PhotoFront AppendServerPhotoURL] ToURL]];
            ((GoodsItemTVC *)cell).SellerNameL.text = order_goods.Seller.NickName;
            ((GoodsItemTVC *)cell).GoodsNameL.text = order_goods.Title;
            ((GoodsItemTVC *)cell).GoodsDetailTV.text = order_goods.Introduction;
            ((GoodsItemTVC *)cell).PriceL.text = [order_info.Order.Subtotal stringValue];
        } else {
            cell = [_m_table dequeueReusableCellWithIdentifier:@"CellGoods"];
            [((GoodsItemTVC *)cell).GoodsAvatarIV sd_setImageWithURL:[[order_goods.PhotoFront AppendServerPhotoURL]ToURL]];
            ((GoodsItemTVC *)cell).GoodsNameL.text = order_goods.Title;
            ((GoodsItemTVC *)cell).GoodsDetailTV.text = order_goods.Introduction;
            ((GoodsItemTVC *)cell).PriceL.text = [order_info.Order.Subtotal stringValue];
        }
    } else if (indexPath.section == 1) {
        if ([order_status isEqualToString:@"BuyerPaidGoods"]) {
            if (indexPath.row == 0){
                cell = [_m_table dequeueReusableCellWithIdentifier:@"BuyerPaidGoods"];
                ((OrderStatusDetailTVC *)cell).Status = @"BuyerPaidGoods";
                [((OrderStatusDetailTVC *)cell).FirstB addTarget:self
                                                          action:@selector(cell_button_pressed:)
                                                forControlEvents:UIControlEventTouchUpInside];
                ((OrderStatusDetailTVC *)cell).FirstB.tag = indexPath.row;
            }
        }
        else if ([order_status isEqualToString:@"BuyerSellerSentGoods"]) {
            if (indexPath.row == 0) {
                cell = [_m_table dequeueReusableCellWithIdentifier:@"BuyerPaidGoods"];
                   ((OrderStatusDetailTVC *)cell).Status = @"BuyerPaidGoods";
                [((OrderStatusDetailTVC *)cell).FirstB setHidden:YES];
            }
            else if (indexPath.row == 1) {
                cell = [_m_table dequeueReusableCellWithIdentifier:@"BuyerSellerSentGoods"];
                ((OrderStatusDetailTVC *)cell).Status = @"BuyerSellerSentGoods";
                [((OrderStatusDetailTVC *)cell).FirstB addTarget:self
                                                          action:@selector(cell_button_pressed:)
                                                forControlEvents:UIControlEventTouchUpInside];
                ((OrderStatusDetailTVC *)cell).FirstB.tag = indexPath.row;
                [((OrderStatusDetailTVC *)cell).SecondB addTarget:self
                                                           action:@selector(cell_button_pressed:)
                                                 forControlEvents:UIControlEventTouchUpInside];
                ((OrderStatusDetailTVC *)cell).SecondB.tag = indexPath.row;
            }
        }
        else if ([order_status isEqualToString:@"BuyerTradeSucceed"]) {
            if (indexPath.row == 0) {
                cell = [_m_table dequeueReusableCellWithIdentifier:@"BuyerPaidGoods"];
                ((OrderStatusDetailTVC *)cell).Status = @"BuyerPaidGoods";
                [((OrderStatusDetailTVC *)cell).FirstB setHidden:YES];
            }
            else if (indexPath.row == 1) {
                cell = [_m_table dequeueReusableCellWithIdentifier:@"BuyerSellerSentGoods"];
                ((OrderStatusDetailTVC *)cell).Status = @"BuyerSellerSentGoods";
                [((OrderStatusDetailTVC *)cell).FirstB setHidden:YES];
                [((OrderStatusDetailTVC *)cell).SecondB setHidden:YES];
            }
            else if (indexPath.row == 2) {
                cell = [_m_table dequeueReusableCellWithIdentifier:@"BuyerTradeSucceed"];
                ((OrderStatusDetailTVC *)cell).Status = @"BuyerTradeSucceed";
                [((OrderStatusDetailTVC *)cell).FirstB addTarget:self
                                                          action:@selector(cell_button_pressed:)
                                                forControlEvents:UIControlEventTouchUpInside];
                ((OrderStatusDetailTVC *)cell).FirstB.tag = indexPath.row;
                [((OrderStatusDetailTVC *)cell).SecondB addTarget:self
                                                           action:@selector(cell_button_pressed:)
                                                 forControlEvents:UIControlEventTouchUpInside];
                ((OrderStatusDetailTVC *)cell).SecondB.tag = indexPath.row;
            }
        }
        else  if ([order_status isEqualToString:@"BuyerRefunding"]) {
            if (indexPath.row == 0) {
                cell = [_m_table dequeueReusableCellWithIdentifier:@"BuyerPaidGoods"];
                ((OrderStatusDetailTVC *)cell).Status = @"BuyerPaidGoods";
                [((OrderStatusDetailTVC *)cell).FirstB setHidden:YES];
            }
            else if (indexPath.row == 1) {
                cell = [_m_table dequeueReusableCellWithIdentifier:@"BuyerSellerSentGoods"];
                ((OrderStatusDetailTVC *)cell).Status = @"BuyerSellerSentGoods";
                [((OrderStatusDetailTVC *)cell).FirstB setHidden:YES];
                [((OrderStatusDetailTVC *)cell).SecondB setHidden:YES];
            }
            else if (indexPath.row == 2) {
                cell = [_m_table dequeueReusableCellWithIdentifier:@"BuyerTradeSucceed"];
                ((OrderStatusDetailTVC *)cell).Status = @"BuyerTradeSucceed";
                [((OrderStatusDetailTVC *)cell).FirstB setHidden:YES];
                [((OrderStatusDetailTVC *)cell).SecondB setHidden:YES];
            }
            else if (indexPath.row == 3) {
                cell = [_m_table dequeueReusableCellWithIdentifier:@"BuyerRefunding"];
                ((OrderStatusDetailTVC *)cell).Status = @"BuyerRefunding";
                [((OrderStatusDetailTVC *)cell).FirstB addTarget:self
                                                          action:@selector(cell_button_pressed:)
                                                forControlEvents:UIControlEventTouchUpInside];
                ((OrderStatusDetailTVC *)cell).FirstB.tag = indexPath.row;
                [((OrderStatusDetailTVC *)cell).SecondB addTarget:self
                                                           action:@selector(cell_button_pressed:)
                                                 forControlEvents:UIControlEventTouchUpInside];
                ((OrderStatusDetailTVC *)cell).SecondB.tag = indexPath.row;
            }
        }
        else if ([order_status isEqualToString:@"BuyerRefundRefused"]) {
            if (indexPath.row == 0) {
                cell = [_m_table dequeueReusableCellWithIdentifier:@"BuyerPaidGoods"];
                ((OrderStatusDetailTVC *)cell).Status = @"BuyerPaidGoods";
                [((OrderStatusDetailTVC *)cell).FirstB setHidden:YES];
            }
            else if (indexPath.row == 1) {
                cell = [_m_table dequeueReusableCellWithIdentifier:@"BuyerSellerSentGoods"];
                ((OrderStatusDetailTVC *)cell).Status = @"BuyerSellerSentGoods";
                [((OrderStatusDetailTVC *)cell).FirstB setHidden:YES];
                [((OrderStatusDetailTVC *)cell).SecondB setHidden:YES];
            }
            else if (indexPath.row == 2) {
                cell = [_m_table dequeueReusableCellWithIdentifier:@"BuyerTradeSucceed"];
                ((OrderStatusDetailTVC *)cell).Status = @"BuyerTradeSucceed";
                [((OrderStatusDetailTVC *)cell).FirstB setHidden:YES];
                [((OrderStatusDetailTVC *)cell).SecondB addTarget:self
                                                           action:@selector(cell_button_pressed:)
                                                 forControlEvents:UIControlEventTouchUpInside];
                ((OrderStatusDetailTVC *)cell).SecondB.tag = indexPath.row;
            }
            else if (indexPath.row == 3) {
                cell = [_m_table dequeueReusableCellWithIdentifier:@"BuyerRefundRefused"];
                ((OrderStatusDetailTVC *)cell).Status = @"BuyerRefundRefused";
                [((OrderStatusDetailTVC *)cell).FirstB addTarget:self action:@selector(cell_button_pressed:) forControlEvents:UIControlEventTouchUpInside];
                ((OrderStatusDetailTVC *)cell).FirstB.tag = indexPath.row;
                [((OrderStatusDetailTVC *)cell).SecondB addTarget:self action:@selector(cell_button_pressed:) forControlEvents:UIControlEventTouchUpInside];
                ((OrderStatusDetailTVC *)cell).SecondB.tag = indexPath.row;
            }
        }
        else if ([order_status isEqualToString:@"BuyerCommentted"]) {
            if (indexPath.row == 0) {
                cell = [_m_table dequeueReusableCellWithIdentifier:@"BuyerPaidGoods"];
                ((OrderStatusDetailTVC *)cell).Status = @"BuyerPaidGoods";
                [((OrderStatusDetailTVC *)cell).FirstB setHidden:YES];
            }
            else if (indexPath.row == 1) {
                cell = [_m_table dequeueReusableCellWithIdentifier:@"BuyerSellerSentGoods"];
                ((OrderStatusDetailTVC *)cell).Status = @"BuyerSellerSentGoods";
                [((OrderStatusDetailTVC *)cell).FirstB setHidden:YES];
                [((OrderStatusDetailTVC *)cell).SecondB setHidden:YES];
            }
            else if (indexPath.row == 2) {
                cell = [_m_table dequeueReusableCellWithIdentifier:@"BuyerTradeSucceed"];
                ((OrderStatusDetailTVC *)cell).Status = @"BuyerTradeSucceed";
                [((OrderStatusDetailTVC *)cell).FirstB setHidden:YES];
                [((OrderStatusDetailTVC *)cell).SecondB setHidden:YES];
            }
            else if (indexPath.row == 3) {
                cell = [_m_table dequeueReusableCellWithIdentifier:@"BuyerCommentted"];
                ((OrderStatusDetailTVC *)cell).Status = @"BuyerCommentted";
                [((OrderStatusDetailTVC *)cell).FirstB addTarget:self action:@selector(cell_button_pressed:) forControlEvents:UIControlEventTouchUpInside];
                ((OrderStatusDetailTVC *)cell).FirstB.tag = indexPath.row;
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"Shop" bundle:nil]
                                instantiateViewControllerWithIdentifier:@"GoodsDetailVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 135.0;
        } else {
            return 105.0;
        }
    } else {
        if (indexPath.row == 2) {
            return 175.0;
        }
        return 50.0;
    }
}

- (void)cell_button_pressed:(UIButton *)button{
    NSInteger row = button.tag;
    OrderStatusDetailTVC *cell = [_m_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:1]];
    if ([cell.Status isEqualToString: @"BuyerPaidGoods"]) {
        if (button == cell.FirstB) {
            
        }
    }
    else if ([cell.Status isEqualToString: @"BuyerSellerSentGoods"]){
        if (button == cell.FirstB) {
            
        }
        else if (button == cell.SecondB){
            
        }
    }
    else if ([cell.Status isEqualToString: @"BuyerTradeSucceed"]){
        if (button == cell.FirstB) {
            
        }
        else if (button == cell.SecondB){
            
        }
    }
    else if ([cell.Status isEqualToString: @"BuyerRefunding"]){
        if (button == cell.FirstB) {
            
        }
        else if (button == cell.SecondB){
            
        }
    }
    else if ([cell.Status isEqualToString: @"BuyerRefundRefused"]){
        if (button == cell.FirstB) {
            
        }
        else if (button == cell.SecondB){
            
        }
    }
    else if ([cell.Status isEqualToString: @"BuyerCommentted"]){
        if (button == cell.FirstB) {
            
        }
    }
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
