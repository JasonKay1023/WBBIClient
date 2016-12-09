//
//  ExpressInfoVC.h
//  WBBIClient
//
//  Created by 黃韜 on 16/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "BaseTableViewController.h"

@interface ExpressInfoVC : BaseTableViewController

@property (strong, nonatomic) IBOutlet UILabel *NameL;
@property (strong, nonatomic) IBOutlet UILabel *PhoneL;
@property (strong, nonatomic) IBOutlet UITextView *AddressTV;
@property (strong, nonatomic) IBOutlet UILabel *CompanyL;
@property (strong, nonatomic) IBOutlet UILabel *NumberL;
@property (strong, nonatomic) IBOutlet UIButton *CopyB;
@property (strong, nonatomic) IBOutlet UIImageView *PhotoIV;

@end
