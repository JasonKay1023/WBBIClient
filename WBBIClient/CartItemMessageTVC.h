//
//  CartItemMessageTVC.h
//  WBBIClient
//
//  Created by 黃韜 on 7/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartItemMessageTVC : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextView *MessageTV;
@property (strong, nonatomic) IBOutlet UILabel *DiscountL;
@property (strong, nonatomic) IBOutlet UISwitch *UseDiscountS;

@end
