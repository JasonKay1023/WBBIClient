//
//  GoodsCommentModel.h
//  WBBIClient
//
//  Created by 黃韜 on 7/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "GoodsModel.h"

@interface GoodsCommentModel : NSObject

@property (copy, nonatomic) NSString *Content;
@property (assign, nonatomic) BOOL HasBought;
@property (copy, nonatomic) NSNumber *Rate;
@property (strong, nonatomic) GoodsModel *Goods;
@property (strong, nonatomic) UserModel *User;
@property (copy, nonatomic) NSString *Created;

@end
