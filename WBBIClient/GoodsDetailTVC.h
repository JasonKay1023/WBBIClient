//
//  GoodsDetailTVC.h
//  WBBIClient
//
//  Created by 黃韜 on 14/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@interface GoodsDetailTVC : UITableViewCell

- (void)LoadGoods:(GoodsModel *)goods_instance;

@end
