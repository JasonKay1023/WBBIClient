//
//  EMError+Log.m
//  EaseMob-IM
//
//  Created by 黃韜 on 3/12/2015.
//  Copyright © 2015 NextApps. All rights reserved.
//

#import "EMError+Log.h"
#import "IMConstants.h"

@implementation EMError (Log)

- (void)ToConsole
{
    NSLog(@"EaseMob Error: %ld", (long)self.errorCode);
    NSLog(@"Description: %@", self.description);
}

- (NSError *)ToError
{
    return [NSError errorWithDomain:IMDomain
                               code:self.errorCode
                           userInfo:@{@"description": self.description}];
}

@end
