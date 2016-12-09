//
//  UserAddressModel.h
//  WBBIClient
//
//  Created by 黃韜 on 5/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceModel.h"

@interface UserAddressModel : NSObject

@property (assign, nonatomic) NSInteger id;
@property (copy, nonatomic) NSString *BuyerName;
@property (copy, nonatomic) NSString *Address;
@property (copy, nonatomic) NSString *ZipCode;
@property (copy, nonatomic) NSString *Phone;
@property (strong, nonatomic) PlaceModel *Place;

@end
