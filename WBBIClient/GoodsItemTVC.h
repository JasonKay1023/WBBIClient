//
//  GoodsItemTVC.h
//  WBBIClient
//
//  Created by 黃韜 on 6/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsItemTVC : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *GoodsAvatarIV;
@property (strong, nonatomic) IBOutlet UILabel *SellerNameL;
@property (strong, nonatomic) IBOutlet UILabel *SellerTypeL;
@property (strong, nonatomic) IBOutlet UILabel *PriceL;
@property (strong, nonatomic) IBOutlet UILabel *GoodsNameL;
@property (strong, nonatomic) IBOutlet UITextView *GoodsDetailTV;

@end
