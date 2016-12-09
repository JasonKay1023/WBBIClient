//
//  UserModel.h
//  WBBIClient
//
//  Created by 黃韜 on 5/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (assign, nonatomic) NSInteger id;
@property (copy, nonatomic) NSString *Avatar;
@property (copy, nonatomic) NSString *NickName;
@property (copy, nonatomic) NSString *Sexual;
@property (copy, nonatomic) NSString *Birthday;
@property (copy, nonatomic) NSString *Signature;
@property (copy, nonatomic) NSString *Phone;
@property (copy, nonatomic) NSString *Place;
@property (copy, nonatomic) NSString *PlaceGPSX;
@property (copy, nonatomic) NSString *PlaceGPSY;
@property (assign, nonatomic) NSInteger Score;
@property (copy, nonatomic) NSString *JobPosition;
@property (copy, nonatomic) NSString *JobIndustry;

@end
