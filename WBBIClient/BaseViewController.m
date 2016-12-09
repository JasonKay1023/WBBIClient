//
//  BaseViewController.m
//  WBBIClient
//
//  Created by 黃韜 on 9/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

@synthesize IsEditMode = m_bEditMode;

#pragma - Object life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (m_bEditMode) {
        UIGestureRecognizer *pan_gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(HideKeyboard)];
        UIGestureRecognizer *tap_gesutre = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HideKeyboard)];
        [self.view addGestureRecognizer:pan_gesture];
        [self.view addGestureRecognizer:tap_gesutre];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma - Public interface

- (void)HideKeyboard
{
    [self.view endEditing:YES];
}

@end
