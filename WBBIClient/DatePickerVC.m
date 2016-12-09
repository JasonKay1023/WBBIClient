//
//  DatePickerVC.m
//  WBBIClient
//
//  Created by 黃韜 on 11/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "DatePickerVC.h"

@interface DatePickerVC ()

@end

@implementation DatePickerVC

@synthesize DateP = m_pDateP;

#pragma mark - Object life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [m_pDateP addTarget:self
                 action:@selector(valueChanged:)
       forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Public interface

- (void)SetDate:(NSDate *)date
{
    [m_pDateP setDate:date];
}

- (void)SetDateString:(NSString *)dateString
{
    NSDateFormatter *date_format = [[NSDateFormatter alloc] init];
    [date_format setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [date_format dateFromString:dateString];
    [m_pDateP setDate:date];
}

#pragma mark - Date picker

- (void)valueChanged:(UIDatePicker *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDatePickerKey object:sender.date];
}

@end
