//
//  NSString+Size.m
//  WBBIClient
//
//  Created by 黃韜 on 19/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)GetContentSize:(CGSize)size
                    font:(UIFont*)font
{
    CGSize expected_label_size = CGSizeZero;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{
                                     NSFontAttributeName: font,
                                     NSParagraphStyleAttributeName: style.copy};
        expected_label_size = [self boundingRectWithSize:size
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:attributes
                                                 context:nil].size;
    } else {
        expected_label_size = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    }
    return expected_label_size;
}

@end
