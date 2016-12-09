//
//  CartItemModel.h
//  WBBIClient
//
//  Created by 黃韜 on 7/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsModel.h"

@interface CartItemModel : NSObject

@property (assign, nonatomic) NSInteger id;
@property (copy, nonatomic) NSNumber *Quantity;
@property (strong, nonatomic) GoodsModel *Goods;
@property (copy, nonatomic) NSString *Created;

@end
