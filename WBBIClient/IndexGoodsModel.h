//
//  IndexGoodsModel.h
//  WBBIClient
//
//  Created by 黃韜 on 2016/1/18.
//  Copyright © 2016年 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsModel.h"

@interface IndexGoodsModel : NSObject

@property (copy, nonatomic) NSString *FirstCreated;
@property (copy, nonatomic) NSString *LastCreated;
@property (strong, nonatomic) NSArray<GoodsModel *> *Goods;

@end
