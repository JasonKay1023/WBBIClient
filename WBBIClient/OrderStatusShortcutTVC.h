//
//  OrderStatusShortcutTVC.h
//  WBBIClient
//
//  Created by 黃韜 on 26/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderStatusShortcutTVC : UITableViewCell

@property (copy, nonatomic) NSString *Status;
@property (strong, nonatomic) IBOutlet UIButton *FirstB;
@property (strong, nonatomic) IBOutlet UIButton *SecondB;
@property (strong, nonatomic) IBOutlet UIButton *ThirdB;

@end
