//
//  NSString+URL.h
//  WBBIClient
//
//  Created by 黃韜 on 6/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

- (NSString *)AppendServerURL;
- (NSString *)AppendServerPhotoURL;
- (NSURL *)ToURL;
- (NSString *)AppendSuffix:(NSString *)suffix;

@end
