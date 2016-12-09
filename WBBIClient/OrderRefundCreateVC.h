//
//  OrderRefundCreateVC.h
//  WBBIClient
//
//  Created by 黃韜 on 16/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "BaseTableViewController.h"

@interface OrderRefundCreateVC : BaseTableViewController

@property (strong, nonatomic) IBOutlet UITextField *ReasonTF;
@property (strong, nonatomic) IBOutlet UITextField *PriceTF;
@property (strong, nonatomic) IBOutlet UITextView *DescriptionTV;
@property (strong, nonatomic) IBOutlet UIButton *UploadButtonA;
@property (strong, nonatomic) IBOutlet UIButton *UploadButtonB;
@property (strong, nonatomic) IBOutlet UIButton *UploadButtonC;

@end
