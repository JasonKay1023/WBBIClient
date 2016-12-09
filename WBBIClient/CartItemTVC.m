//
//  CartItemTVC.m
//  WBBIClient
//
//  Created by 林穎怡 on 2016/1/7.
//  Copyright © 2016年 WBB. All rights reserved.
//

#import "CartItemTVC.h"

@interface CartItemTVC ()

@property (assign, nonatomic) NSInteger cartItemID;
@property (weak, nonatomic) id<CartItemDelegate> delegate;

@end

@implementation CartItemTVC

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)CartItemID:(NSInteger)cart_id
          quantity:(NSInteger)quantity
      max_quantity:(NSInteger)max_quantity
          delegate:(id<CartItemDelegate>)delegate
{
    _cartItemID = cart_id;
    _QuantityL.text = [[NSNumber numberWithInteger:quantity] stringValue];
    _CurQuantity = quantity;
    _MaxQuantity = max_quantity;
    _delegate = delegate;
}

- (void)Quantity:(NSInteger)quantity
{
    _QuantityL.text = [[NSNumber numberWithInteger:quantity] stringValue];
    _CurQuantity = quantity;
    if (quantity != 0) {
        _Decrease.enabled = YES;
    }
}

- (IBAction)DecreaseBPressed:(UIButton *)sender
{
    NSInteger tmp = _CurQuantity - 1;
    if (tmp == 0) {
        _Decrease.enabled = NO;
    }
    if (tmp != _MaxQuantity) {
        _Increase.enabled = YES;
    }
    _CurQuantity = tmp;
    _QuantityL.text = [[NSNumber numberWithInteger:_CurQuantity] stringValue];
    [_delegate CartItemID:_cartItemID Count:_CurQuantity Cell:self];
}

- (IBAction)IncreaseBPressed:(UIButton *)sender
{
    NSInteger tmp = _CurQuantity + 1;
    if (tmp == _MaxQuantity) {
        _Increase.enabled = NO;
    }
    if (tmp != 0) {
        _Decrease.enabled = YES;
    }
    _CurQuantity = tmp;
    _QuantityL.text = [[NSNumber numberWithInteger:_CurQuantity] stringValue];
    [_delegate CartItemID:_cartItemID Count:_CurQuantity Cell:self];
}

@end
