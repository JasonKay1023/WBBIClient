//
//  NSDate+String.m
//  WBBIClient
//
//  Created by 黃韜 on 14/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "NSDate+String.h"

@implementation NSDate (String)

+ (NSDate *)DateFromString:(NSString *)YYYYMMdd
{
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"YYYY-MM-dd"];
    return [date_formatter dateFromString:YYYYMMdd];
}

- (NSString *)StringFromDate
{
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"YYYY-MM-dd"];
    return [date_formatter stringFromDate:self];
}

- (NSString *)StringFromDateTime
{
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"YYYYMMddHHmmss"];
    return [date_formatter stringFromDate:self];
}

@end
