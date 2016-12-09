//
//  OrderStatusDetailTVC.h
//  WBBIClient
//
//  Created by 黃韜 on 28/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderStatusDetailTVC : UITableViewCell

@property (copy, nonatomic) NSString *Status;

@property (strong, nonatomic) IBOutlet UIButton *FirstB;
@property (strong, nonatomic) IBOutlet UIButton *SecondB;
@property (strong, nonatomic) IBOutlet UITextView *MessageTV;

@end
