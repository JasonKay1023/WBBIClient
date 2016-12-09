//
//  AlipayPayAction.h
//  WBBIClient
//
//  Created by 黃韜 on 6/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlipayPayAction : NSObject

- (void)paymentWithTradeID:(NSString *)trade_id
                   inPrice:(float)price
                  forGoods:(NSString *)title
                withDetail:(NSString *)description;

@end
