//
//  ProvinceModel.h
//  WBBIClient
//
//  Created by 林穎怡 on 2016/1/6.
//  Copyright © 2016年 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProvinceModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *zip;
@property (strong, nonatomic) NSMutableArray *city;

@end
