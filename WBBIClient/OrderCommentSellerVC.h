//
//  OrderCommentSellerVC.h
//  WBBIClient
//
//  Created by 黃韜 on 16/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "BaseTableViewController.h"

@interface OrderCommentSellerVC : BaseTableViewController

@property (strong, nonatomic) IBOutlet UIImageView *AvatarIV;
@property (strong, nonatomic) IBOutlet UILabel *BrandL;
@property (strong, nonatomic) IBOutlet UILabel *TitleL;
@property (strong, nonatomic) IBOutlet UILabel *PriceL;
@property (strong, nonatomic) IBOutlet UILabel *Quantity;
@property (strong, nonatomic) IBOutlet UITextView *CommentTV;
@property (strong, nonatomic) IBOutlet UIView *GoodsScoreV;

@end
