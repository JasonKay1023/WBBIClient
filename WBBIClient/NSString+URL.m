//
//  NSString+URL.m
//  WBBIClient
//
//  Created by 黃韜 on 6/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "NSString+URL.h"
#import "AppConstants.h"

@implementation NSString (URL)

- (NSString *)AppendServerURL
{
    return [BaseURL stringByAppendingString:self];
}

- (NSString *)AppendServerPhotoURL
{
    return [PhotoURL stringByAppendingString:self];
}

- (NSURL *)ToURL
{
    return [NSURL URLWithString:self];
}

- (NSString *)AppendSuffix:(NSString *)suffix
{
    return [[self stringByAppendingString:suffix] stringByAppendingString:@"/"];
}

@end
