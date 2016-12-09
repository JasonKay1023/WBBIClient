//
//  LocationCityModel.m
//  WBBIClient
//
//  Created by 黃韜 on 13/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "LocationCityModel.h"

@implementation LocationCityModel

@synthesize Name = m_pName;
@synthesize ZipCode = m_pZip;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        m_pName = dictionary[@"name"];
        m_pZip = dictionary[@"zip"];
    }
    return self;
}

@end
