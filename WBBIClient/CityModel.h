//
//  CityModel.h
//  WBBIClient
//
//  Created by 林穎怡 on 2016/1/6.
//  Copyright © 2016年 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *zip;
@property (strong, nonatomic) NSMutableArray *county;

@end
