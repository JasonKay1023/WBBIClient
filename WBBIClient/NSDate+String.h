//
//  NSDate+String.h
//  WBBIClient
//
//  Created by 黃韜 on 14/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (String)

+ (NSDate *)DateFromString:(NSString *)YYYYMMdd;
- (NSString *)StringFromDate;
- (NSString *)StringFromDateTime;

@end
