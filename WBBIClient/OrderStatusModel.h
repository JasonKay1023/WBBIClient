//
//  OrderStatusModel.h
//  WBBIClient
//
//  Created by 黃韜 on 7/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderStatusModel : NSObject

@property (assign, nonatomic) NSInteger id;
@property (copy, nonatomic) NSString *Status;
@property (copy, nonatomic) NSString *Message;
@property (copy, nonatomic) NSString *Created;

@end
