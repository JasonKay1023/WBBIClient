//
//  GoodsTypeSelectVC.h
//  WBBIClient
//
//  Created by 黃韜 on 8/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "BaseTableViewController.h"
#import "KVModel.h"

@protocol GoodsTypeSelectDelegate <NSObject>

- (void)CallBackGoodsType:(KVModel *)object;

@end

@interface GoodsTypeSelectVC : BaseTableViewController

@property (weak, nonatomic) id<GoodsTypeSelectDelegate> Delegate;

@end
