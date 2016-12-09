//
//  LocationPickerVC.h
//  WBBIClient
//
//  Created by 黃韜 on 12/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "BaseViewController.h"

#define kLocationPickerKey @"LocationPickerKey"

@interface LocationPickerVC : BaseViewController

@property (strong, nonatomic) IBOutlet UIPickerView *PickerPV;

@end
