//
//  UIImage+Output.m
//  WBBIClient
//
//  Created by 黃韜 on 11/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "UIImage+Output.h"

@implementation UIImage (Output)

- (NSData *)ToJPEG:(CGFloat)quality
{
    return UIImageJPEGRepresentation(self, quality);
}

- (NSData *)ToPNG
{
    return UIImagePNGRepresentation(self);
}

@end
