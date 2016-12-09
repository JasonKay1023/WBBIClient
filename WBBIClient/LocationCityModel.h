//
//  LocationCityModel.h
//  WBBIClient
//
//  Created by 黃韜 on 13/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationCityModel : NSObject

@property (copy, nonatomic) NSString *Name;
@property (copy, nonatomic) NSString *ZipCode;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
