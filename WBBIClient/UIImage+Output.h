//
//  UIImage+Output.h
//  WBBIClient
//
//  Created by 黃韜 on 11/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Output)

- (NSData *)ToJPEG:(CGFloat)quality;
- (NSData *)ToPNG;

@end
