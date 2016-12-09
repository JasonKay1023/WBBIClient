//
//  OrderModel.h
//  WBBIClient
//
//  Created by 黃韜 on 7/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "PlaceModel.h"

@interface OrderModel : NSObject

@property (assign, nonatomic) NSInteger id;
@property (strong, nonatomic) UserModel *Buyer;
@property (strong, nonatomic) PlaceModel *Place;
@property (copy, nonatomic) NSString *Address;
@property (copy, nonatomic) NSString *ZipCode;
@property (copy, nonatomic) NSString *Phone;
@property (strong, nonatomic) UserModel *Seller;
@property (copy, nonatomic) NSString *Message;
@property (copy, nonatomic) NSNumber *Discount;
@property (copy, nonatomic) NSNumber *ExpressFee;
@property (copy, nonatomic) NSNumber *Subtotal;
@property (copy, nonatomic) NSString *Created;
@property (copy, nonatomic) NSString *Terminated;

@end
