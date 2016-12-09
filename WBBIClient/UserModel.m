//
//  UserModel.m
//  WBBIClient
//
//  Created by 黃韜 on 5/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (BOOL)isEqual:(id)object
{
    if (self.id == ((UserModel *)object).id) {
        return YES;
    }
    return NO;
}

@end
