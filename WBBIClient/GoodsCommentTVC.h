//
//  GoodsCommentTVC.h
//  WBBIClient
//
//  Created by 黃韜 on 7/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsCommentTVC : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *AvatarIV;
@property (strong, nonatomic) IBOutlet UILabel *NameL;
@property (strong, nonatomic) IBOutlet UIButton *ReportB;
@property (strong, nonatomic) IBOutlet UITextView *ContentL;

- (IBAction)ReportBPressed:(UIButton *)sender;

@end
