//
//  HttpResponseJson.m
//  WBBIClient
//
//  Created by 黃韜 on 24/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "HttpResponseJson.h"

@implementation HttpResponseJson

@synthesize Result = m_pResult;
@synthesize ErrorCode = m_pErrorCode;
@synthesize Reason = m_pReason;
/*
- (instancetype)initWithStatusCode:(NSInteger)code
                    responseObject:(id)json
{
    self = [super initWithStatusCode:code];
    if (self) {
        m_pResult = [(NSDictionary *)json objectForKey:@"result"];
        m_pErrorCode = [[(NSDictionary *)json valueForKey:@"error_code"] integerValue];
        m_pReason = [(NSDictionary *)json objectForKey:@"reason"];
    }
    return self;
}
*/
/*
- (instancetype)initWithStatusCode:(NSInteger)code
                              body:(id)body
{
    self = [super initWithStatusCode:code body:body];
    if (self) {
        m_pResult = [(NSDictionary *)body objectForKey:@"result"];
        m_pErrorCode = [[(NSDictionary *)body valueForKey:@"error_code"] integerValue];
        m_pReason = [(NSDictionary *)body objectForKey:@"reason"];
    }
    return self;
}

- (instancetype)initWithStatusCode:(NSInteger)code
                             error:(NSError *)error
{
    self = [super initWithStatusCode:code error:error];
    if (self) {
        m_pResult = nil;
        m_pErrorCode = -1;
        m_pReason = @"";
    }
    return self;
}*/

- (instancetype)initWithHttpResponse:(HttpResponse *)response
{
    if (response.Error != nil) {
        self = [super initWithStatusCode:response.StatusCode
                                   error:response.Error];
        if (self) {
            m_pResult = nil;
            m_pErrorCode = -1;
            m_pReason = @"";
        }
    } else {
        self = [super initWithStatusCode:response.StatusCode
                                    body:response.Body];
        if (self) {
            m_pResult = [response.Body objectForKey:@"result"];
            m_pErrorCode = [[response.Body valueForKey:@"error_code"] integerValue];
            m_pReason = [response.Body objectForKey:@"reason"];
        }
    }
    return self;
}

- (BOOL)IsResultDictionary
{
    if ([m_pResult isKindOfClass:[NSDictionary class]]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)IsResultArray
{
    if ([m_pResult isKindOfClass:[NSArray class]]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"status_code: %ld\nerror_code: %ld\nreason: %@\nresult: %@", (long)self.StatusCode, (long)m_pErrorCode, m_pReason, m_pResult];
}

@end
