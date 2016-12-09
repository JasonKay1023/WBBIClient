//
//  ExpressCreateVC.h
//  WBBIClient
//
//  Created by 黃韜 on 28/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "BaseTableViewController.h"

@interface ExpressCreateVC : BaseTableViewController

@property (strong, nonatomic) IBOutlet UILabel *NameL;
@property (strong, nonatomic) IBOutlet UILabel *PhoneL;
@property (strong, nonatomic) IBOutlet UITextView *AddressTV;
@property (strong, nonatomic) IBOutlet UILabel *CompanyL;
@property (strong, nonatomic) IBOutlet UITextField *NumberTF;
@property (strong, nonatomic) IBOutlet UIButton *PhotoUpload;
@property (strong, nonatomic) IBOutlet UIImageView *PhotoIV;

@end
