//
//  DetailViewController.h
//  WBBIndex
//
//  Created by 黃韜 on 19/1/2016.
//  Copyright © 2016 NextApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlipContainerView.h"

@interface DetailViewController : UIViewController

@property (nonatomic, weak) id<FlipContainerDelegate> delegate;

@end
