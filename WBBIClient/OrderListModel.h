//
//  OrderListModel.h
//  WBBIClient
//
//  Created by 黃韜 on 16/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderInfoModel.h"

@interface OrderListModel : NSObject

@property (assign, nonatomic) NSInteger Count;
@property (copy, nonatomic) NSString *FirstCreated;
@property (copy, nonatomic) NSString *LastCreated;
@property (copy, nonatomic) NSString *Type;
@property (strong, nonatomic) NSArray<OrderInfoModel *> *Orders;

@end
