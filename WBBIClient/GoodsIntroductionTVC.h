//
//  GoodsIntroductionTVC.h
//  WBBIClient
//
//  Created by 黃韜 on 7/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@interface GoodsIntroductionTVC : UITableViewCell

- (void)LoadData:(GoodsModel *)goods_instance;

@end
