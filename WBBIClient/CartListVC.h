//
//  CartListVC.h
//  WBBIClient
//
//  Created by 黃韜 on 6/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "BaseViewController.h"
#import "FlipContainerView.h"

@interface CartListVC : BaseViewController

@property (weak, nonatomic) id<FlipContainerDelegate> delegate;

@end
