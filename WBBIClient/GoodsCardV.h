//
//  GoodsCardV.h
//  WBBIClient
//
//  Created by 黃韜 on 2016/1/18.
//  Copyright © 2016年 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DraggableCardView.h"

@interface GoodsCardV : DraggableCardView <UIGestureRecognizerDelegate>

@property (assign, nonatomic) NSInteger id;
@property (weak, nonatomic) IBOutlet UIImageView *PhotoIV;
@property (weak, nonatomic) IBOutlet UILabel *TitileL;
@property (weak, nonatomic) IBOutlet UILabel *BrandL;
@property (weak, nonatomic) IBOutlet UILabel *PriceL;

//@property (weak, nonatomic) IBOutlet UIImageView *rejectImageView;
//@property (weak, nonatomic) IBOutlet UIImageView *approveImageView;

@end
