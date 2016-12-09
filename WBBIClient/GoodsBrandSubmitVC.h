//
//  GoodsBrandSubmitVC.h
//  WBBIClient
//
//  Created by 黃韜 on 8/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "BaseTableViewController.h"

@protocol GoodsBrandSelectDelegate <NSObject>

- (void)CallBackGoodsBrand:(NSString *)brand;

@end

@interface GoodsBrandSubmitVC : BaseTableViewController

@property (weak, nonatomic) id<GoodsBrandSelectDelegate> Delegate;

@end
