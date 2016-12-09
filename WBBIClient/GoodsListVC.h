//
//  GoodsListVC.h
//  WBBIClient
//
//  Created by 黃韜 on 6/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "BaseTableViewController.h"
#import "FlipContainerView.h"

typedef enum : NSUInteger {
    GoodsListTypeLike,
    GoodsListTypeFavour,
} GoodsListType;

@interface GoodsListVC : BaseTableViewController

@property (assign, nonatomic) GoodsListType Type;
@property (weak, nonatomic) id<FlipContainerDelegate> delegate;

@end
