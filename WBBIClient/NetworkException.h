//
//  NetworkException.h
//  WBBIClient
//
//  Created by Kevin on 16/1/3.
//  Copyright © 2016年 WBB. All rights reserved.
//

#ifndef NetworkException_h
#define NetworkException_h
//
typedef enum : NSUInteger {
    UnknownError = 10000,
    InvalidParametersBadRequest = 10001,
    DuplicatedSubmittedForbidden = 10002,
    MethodNotAllow = 10003,
    IntegerityServerError = 10004,
    TransactionServerError = 10005,
    UserNotFound = 11001,
    UserExistedForbidden = 11002,
    NoneRegisterForbidden = 11003,
    InvalidRegisterForbiden = 11004,
    RealNameValidateNotFound = 11005,
    ThirdPartError = 11006,
    VerifyCodeTooManyRequests = 11007,
    UserPasswordForbidden = 11008,
    JobIndustryNotFound = 11009,
    UnauthOrderSellerForbidden = 13001,
    UnauthOrderBuyerForbidden = 13002,
    IllegalOrderStautsForbidden = 13003,
    NotEnoughGoodStockForbidden = 13004,
    InvalidOrderingGoodsForbidden = 13005,
    InvalidCartItemForbidden = 13006,
    InvalidOrderForbidden = 13007,
    InvalidOrderItemForbidden = 13008,
    NoneBuyerFeedbackForbidden = 13009,
    AddressIdentifyNotFound = 13010,
    GoodsIdentifyNotFound = 13011,
    OrderSessionIndentifyNotFound = 13012,
    OrderIdentifyNotFound = 13013,
    ExpressProviderIdentifyNotFound = 13014,
    ExpressIdentifyNotFound = 13015,
    OrderrefundIdentifyNotFound = 13016,
    SellerFeedbackNotFound = 13017,
    BuyerFeedbackNotFound = 13018,
    ProvinceIdentifyNotFound = 13019,
    CityIdentifyNotFound = 13020,
    DiscrictIdentifyNotFound = 13021,
    CartItemIdentifyNotFound = 13022,
    CartIdentifyNotFound = 13023,
    AttributeBotFound = 13024,
    TypeNotFound = 13025,
} NetworkException;
#endif /* NetworkException_h */
