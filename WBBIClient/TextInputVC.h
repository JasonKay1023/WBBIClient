//
//  TextInputVC.h
//  WBBIClient
//
//  Created by 黃韜 on 14/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "BaseViewController.h"

#define kTextInputVCKey @"TextInputVCKey"

@interface TextInputVC : BaseViewController

- (void)Mark:(NSString *)mark;
- (void)Title:(NSString *)title andContent:(NSString *)content;

@end
