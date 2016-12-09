//
//  LocationModels.m
//  WBBIClient
//
//  Created by 黃韜 on 13/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "LocationModels.h"
#import "LocationProvinceModel.h"

#define kLocationFileName @"locations"

@interface LocationModels ()

@property (strong, nonatomic) NSArray *array;

@end

@implementation LocationModels

@synthesize array = m_pArray;

- (instancetype)init
{
    self = [super init];
    if (self) {
        m_pArray = nil;
    }
    return self;
}

- (NSArray *)Locations
{
    if (m_pArray == nil) {
        NSDictionary *dictionary = [self dictionaryWithContentsOfJSONString:kLocationFileName];
        NSMutableArray *result_array = [NSMutableArray array];
        NSArray *array = dictionary[@"province"];
        for (NSDictionary *object in array) {
            LocationProvinceModel *province = [[LocationProvinceModel alloc] initWithDictionary:object];
            if (province != nil) {
                [result_array addObject:province];
            }
        }
        m_pArray = result_array;
    }
    return m_pArray;
}

- (NSDictionary *)dictionaryWithContentsOfJSONString:(NSString *)fileName
{
    NSString *json_string = [[NSBundle mainBundle] pathForResource:kLocationFileName
                                                            ofType:@"json"];
    NSData *json_data = [NSData dataWithContentsOfFile:json_string];
    __autoreleasing NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:json_data
                                                options:kNilOptions
                                                  error:&error];
    if (error != nil) {
        return nil;
    }
    return result;
}

@end
