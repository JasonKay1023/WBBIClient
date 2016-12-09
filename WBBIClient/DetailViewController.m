//
//  DetailViewController.m
//  WBBIndex
//
//  Created by 黃韜 on 19/1/2016.
//  Copyright © 2016 NextApps. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark DetailView

- (IBAction)didPressCloseButton:(id)sender {
    [self.delegate showFront];
}

@end
