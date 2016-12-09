//
//  PlaceModel.h
//  WBBIClient
//
//  Created by 黃韜 on 5/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceModel : NSObject

@property (assign, nonatomic) NSInteger id;
@property (assign, nonatomic) NSInteger Identify;
@property (copy, nonatomic) NSString *Name;
@property (copy, nonatomic) NSString *Shortcut;

@end
