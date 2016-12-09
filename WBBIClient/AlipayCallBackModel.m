//
//  AlipayCallBackModel.m
//  WBBIClient
//
//  Created by 黃韜 on 6/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "AlipayCallBackModel.h"

@implementation AlipayCallBackModel

- (NSDictionary *)Result
{
    if ([_resultStatus integerValue] != 9000) {
        return nil;
    } else {
        NSCharacterSet *delimiter_set = [NSCharacterSet characterSetWithCharactersInString:@"&"];
        NSMutableDictionary *pairs = [NSMutableDictionary dictionary];
        NSScanner *scanner = [[NSScanner alloc] initWithString:_result];
        while (![scanner isAtEnd]) {
            NSString *pair_string = nil;
            [scanner scanUpToCharactersFromSet:delimiter_set intoString:&pair_string];
            [scanner scanCharactersFromSet:delimiter_set intoString:NULL];
            NSArray *kv_pair = [pair_string componentsSeparatedByString:@"="];
            if (kv_pair.count == 2) {
                NSString *key = [[kv_pair objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSStringEncodingConversionAllowLossy];
                NSString *value = [[kv_pair objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSStringEncodingConversionAllowLossy];
                [pairs setObject:value forKey:key];
            }
        }
        return [NSDictionary dictionaryWithDictionary:pairs];
    }
}

@end
