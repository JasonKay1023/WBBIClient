//
//  HttpResponseJson.h
//  WBBIClient
//
//  Created by 黃韜 on 24/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "HttpResponse.h"

@interface HttpResponseJson : HttpResponse

@property (strong, nonatomic) id Result;
@property (assign, nonatomic) NSInteger ErrorCode;
@property (strong, nonatomic) NSString *Reason;
/*
- (instancetype)initWithStatusCode:(NSInteger)code
                              body:(id)body;
- (instancetype)initWithStatusCode:(NSInteger)code
                             error:(NSError *)error;*/
- (instancetype)initWithHttpResponse:(HttpResponse *)response;
- (BOOL)IsResultDictionary;
- (BOOL)IsResultArray;

@end
