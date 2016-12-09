//
//  OrderRefundInfoVC.h
//  WBBIClient
//
//  Created by 黃韜 on 28/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "BaseTableViewController.h"

@interface OrderRefundInfoVC : BaseTableViewController

@property (strong, nonatomic) IBOutlet UILabel *ReasonL;
@property (strong, nonatomic) IBOutlet UILabel *PriceL;
@property (strong, nonatomic) IBOutlet UITextView *DescriptionTV;
@property (strong, nonatomic) IBOutlet UIImageView *UploadImageA;
@property (strong, nonatomic) IBOutlet UIImageView *UploadImageB;
@property (strong, nonatomic) IBOutlet UIImageView *UploadImageC;

@end
