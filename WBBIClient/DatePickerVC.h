//
//  DatePickerVC.h
//  WBBIClient
//
//  Created by 黃韜 on 11/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "BaseViewController.h"

#define kDatePickerKey @"DatePickerKey"

@interface DatePickerVC : BaseViewController

@property (strong, nonatomic) IBOutlet UIDatePicker *DateP;

- (void)SetDate:(NSDate *)date;
- (void)SetDateString:(NSString *)dateString;

@end
