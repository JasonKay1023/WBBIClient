//
//  NSString+Size.h
//  WBBIClient
//
//  Created by 黃韜 on 19/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Size)

- (CGSize)GetContentSize:(CGSize)size
                    font:(UIFont *)font;

@end
