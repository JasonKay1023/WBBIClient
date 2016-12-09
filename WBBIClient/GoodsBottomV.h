//
//  GoodsBottomV.h
//  WBBIClient
//
//  Created by 黃韜 on 14/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsBottomV : UIView

@property (strong, nonatomic) IBOutlet UIButton *ChatB;
@property (strong, nonatomic) IBOutlet UIButton *FavourB;
@property (strong, nonatomic) IBOutlet UIButton *AddToCartB;
@property (strong, nonatomic) IBOutlet UIButton *BuyNowB;

- (void)IsFavour:(BOOL)yes;

@end
