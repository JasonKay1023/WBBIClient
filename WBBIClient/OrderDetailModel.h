//
//  OrderDetailModel.h
//  WBBIClient
//
//  Created by 黃韜 on 16/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "PlaceModel.h"

@interface OrderDetailModel : NSObject

@property (assign, nonatomic) NSInteger id;
@property (strong, nonatomic) UserModel *Buyer;
@property (copy, nonatomic) NSString *BuyerName;
@property (strong, nonatomic) PlaceModel *Place;
@property (copy, nonatomic) NSString *Address;
@property (copy, nonatomic) NSString *ZipCode;
@property (copy, nonatomic) NSString *Phone;

@end
