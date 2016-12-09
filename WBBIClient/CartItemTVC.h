//
//  CartItemTVC.h
//  WBBIClient
//
//  Created by 林穎怡 on 2016/1/7.
//  Copyright © 2016年 WBB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CartItemDelegate <NSObject>

- (void)CartItemID:(NSInteger)cart_id Count:(NSInteger)count Cell:(UITableViewCell *)cell;

@end

@interface CartItemTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *AvatarIV;
@property (weak, nonatomic) IBOutlet UILabel *BrandL;
@property (weak, nonatomic) IBOutlet UILabel *TitleL;
@property (weak, nonatomic) IBOutlet UILabel *PriceL;
@property (weak, nonatomic) IBOutlet UIButton *Decrease;
@property (weak, nonatomic) IBOutlet UIButton *Increase;
@property (weak, nonatomic) IBOutlet UILabel *QuantityL;

@property (assign, nonatomic) NSInteger CurQuantity;
@property (assign, nonatomic) NSInteger MaxQuantity;

- (IBAction)DecreaseBPressed:(UIButton *)sender;
- (IBAction)IncreaseBPressed:(UIButton *)sender;

- (void)CartItemID:(NSInteger)cart_id
          quantity:(NSInteger)quantity
      max_quantity:(NSInteger)max_quantity
          delegate:(id<CartItemDelegate>)delegate;

- (void)Quantity:(NSInteger)quantity;

@end
