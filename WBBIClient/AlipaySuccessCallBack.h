//
//  AlipaySuccessCallBack.h
//  WBBIClient
//
//  Created by 黃韜 on 6/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlipaySuccessCallBack : NSObject

@property (strong, nonatomic) NSString *partner;
@property (strong, nonatomic) NSString *seller_id;
@property (strong, nonatomic) NSString *out_trade_no;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) NSString *total_fee;
@property (strong, nonatomic) NSString *notify_url;
@property (strong, nonatomic) NSString *service;
@property (strong, nonatomic) NSString *payment_type;
@property (strong, nonatomic) NSString *input_charset;
@property (strong, nonatomic) NSString *pay;
@property (strong, nonatomic) NSString *show_url;
@property (strong, nonatomic) NSString *success;
@property (strong, nonatomic) NSString *sign_type;
@property (strong, nonatomic) NSString *sign;

@end
