//
//  AlipayCallBackModel.h
//  WBBIClient
//
//  Created by 黃韜 on 6/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlipayCallBackModel : NSObject

@property (strong, nonatomic) NSString *memo;
@property (strong, nonatomic) NSNumber *resultStatus;
@property (strong, nonatomic) NSString *result;

- (NSDictionary *)Result;

@end
