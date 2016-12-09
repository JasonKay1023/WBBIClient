//
//  HttpResponse.h
//  WBBIClient
//
//  Created by 黃韜 on 24/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpResponse : NSObject

@property (strong, nonatomic) id Body;
@property (assign, nonatomic) NSInteger StatusCode;
@property (strong, nonatomic) NSError *Error;

- (instancetype)initWithStatusCode:(NSInteger)code
                              body:(id)body;
- (instancetype)initWithStatusCode:(NSInteger)code
                             error:(NSError *)error;

@end
