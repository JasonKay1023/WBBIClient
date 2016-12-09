//
//  HttpResponse.m
//  WBBIClient
//
//  Created by 黃韜 on 24/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "HttpResponse.h"

@implementation HttpResponse

@synthesize Body = m_pBody;
@synthesize StatusCode = m_pStatusCode;
@synthesize Error = m_pError;

- (instancetype)initWithStatusCode:(NSInteger)code
                              body:(id)body
{
    self = [super init];
    if (self) {
        m_pBody = body;
        m_pStatusCode = code;
        m_pError = nil;
    }
    return self;
}

- (instancetype)initWithStatusCode:(NSInteger)code
                             error:(NSError *)error
{
    self = [super init];
    if (self) {
        m_pBody = nil;
        m_pStatusCode = code;
        m_pError = error;
    }
    return self;
}

@end
