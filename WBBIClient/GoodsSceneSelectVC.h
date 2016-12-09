//
//  GoodsSceneSelectVC.h
//  WBBIClient
//
//  Created by 黃韜 on 8/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "BaseTableViewController.h"
#import "KVModel.h"

@protocol GoodsSceneSelectDelegate <NSObject>

- (void)CallBackGoodsScene:(NSArray *)object;

@end

@interface GoodsSceneSelectVC : BaseTableViewController

@property (weak, nonatomic) id<GoodsSceneSelectDelegate> Delegate;

@end
