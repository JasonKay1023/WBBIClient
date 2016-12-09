//
//  GoodsModel.h
//  WBBIClient
//
//  Created by 黃韜 on 6/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface GoodsModel : NSObject

@property (assign, nonatomic) NSInteger id;
@property (strong, nonatomic) UserModel *Seller;
@property (copy, nonatomic) NSString *Title;
@property (copy, nonatomic) NSNumber *Price;
@property (copy, nonatomic) NSString *PhotoFront;
@property (copy, nonatomic) NSString *Introduction;
@property (copy, nonatomic) NSString *Brand;
@property (copy, nonatomic) NSString *MadeIn;
@property (copy, nonatomic) NSString *MadeFrom;
@property (copy, nonatomic) NSString *Accessory;
@property (assign, nonatomic) NSInteger Length;
@property (assign, nonatomic) NSInteger Width;
@property (assign, nonatomic) NSInteger Height;
@property (assign, nonatomic) NSInteger SellerLatitude;
@property (assign, nonatomic) NSInteger SellerLongitude;
@property (assign, nonatomic) NSInteger SellerLocation;
@property (copy, nonatomic) NSString *PhotoOverlook;
@property (copy, nonatomic) NSString *PhotoLeft;
@property (copy, nonatomic) NSString *PhotoRight;
@property (copy, nonatomic) NSString *PhotoBack;
@property (copy, nonatomic) NSString *PhotoLookup;
@property (copy, nonatomic) NSString *PhotoDetailA;
@property (copy, nonatomic) NSString *PhotoDetailB;
@property (copy, nonatomic) NSString *PhotoDetailC;
@property (strong, nonatomic) NSArray *Types;
@property (assign, nonatomic) BOOL IsFavor;
@property (assign, nonatomic) BOOL IsLike;
@property (assign, nonatomic) BOOL Avaliable;

@property (assign, nonatomic) NSInteger StockCount;

@end
