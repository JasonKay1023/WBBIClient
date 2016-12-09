//
//  CartModel.h
//  WBBIClient
//
//  Created by 黃韜 on 7/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAddressModel.h"

@interface CartModel : NSObject

@property (strong, nonatomic) NSMutableArray *CartItems;
@property (strong, nonatomic) UserAddressModel *DefaultAddress;
@property (copy, nonatomic) NSString *From;
@property (copy, nonatomic) NSNumber *Discount;
@property (copy, nonatomic) NSNumber *SessionID;
@property (copy, nonatomic) NSNumber *Subtotal;
@property (copy, nonatomic) NSNumber *PlaybagCoin;

@end
