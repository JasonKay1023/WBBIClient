//
//  UserAddressTVC.h
//  WBBIClient
//
//  Created by 黃韜 on 5/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserAddressTVC : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *BuyerName;
@property (strong, nonatomic) IBOutlet UILabel *Phone;
@property (strong, nonatomic) IBOutlet UITextView *AddressDetail;

@end
