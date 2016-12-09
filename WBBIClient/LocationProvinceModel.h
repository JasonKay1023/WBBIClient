//
//  LocationProvinceModel.h
//  WBBIClient
//
//  Created by 黃韜 on 13/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationCityModel.h"

@interface LocationProvinceModel : NSObject

@property (copy, nonatomic) NSString *Name;
@property (copy, nonatomic) NSString *ZipCode;
@property (strong, nonatomic) NSArray *CityArray;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
