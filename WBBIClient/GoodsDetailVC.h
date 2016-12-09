//
//  GoodsDetailVC.h
//  WBBIClient
//
//  Created by 黃韜 on 6/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "BaseViewController.h"
#import "GoodsModel.h"

@interface GoodsDetailVC : BaseViewController

@property (assign, nonatomic) NSInteger GoodsDetailID;
@property (strong, nonatomic) GoodsModel *GoodsDetailObject;

@end
