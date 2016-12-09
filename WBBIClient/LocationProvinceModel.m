//
//  LocationProvinceModel.m
//  WBBIClient
//
//  Created by 黃韜 on 13/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "LocationProvinceModel.h"

@implementation LocationProvinceModel

@synthesize Name = m_pName;
@synthesize ZipCode = m_pZip;
@synthesize CityArray = m_aCity;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        m_pName = dictionary[@"name"];
        m_pZip = dictionary[@"zip"];
        m_aCity = [[NSArray alloc] init];
        NSMutableArray *temp_arr = [[NSMutableArray alloc] init];
        NSArray *array = dictionary[@"city"];
        for (NSDictionary *sub_dictionary in array) {
            LocationCityModel *city_object = [[LocationCityModel alloc]
                                              initWithDictionary:sub_dictionary];
            if (city_object != nil) {
                [temp_arr addObject:city_object];
            }
        }
        m_aCity = temp_arr;
    }
    return self;
}

@end
