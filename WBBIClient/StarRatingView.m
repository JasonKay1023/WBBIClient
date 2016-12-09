//
//  StarRatingView.m
//  WBBIClient
//
//  Created by 黃韜 on 18/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "StarRatingView.h"

@interface StarRatingView ()

@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;

@end

@implementation StarRatingView

@synthesize Delegate = m_pDelegate;
@synthesize Quantity = m_iQuantity;

@synthesize starBackgroundView = m_pBackgroundV;
@synthesize starForegroundView = m_pForegroundV;

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame numberOfStars:kStarRatingQuantity];
}

- (id)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)number
{
    self = [super initWithFrame:frame];
    if (self) {
        m_iQuantity = kStarRatingQuantity;
        [self initialization];
    }
    return self;
}

- (void)SetScore:(float)score
   WithAnimation:(BOOL)animated
{
    
}

- (void)SetScore:(float)score
   WithAnimation:(BOOL)animated
      Completion:(void (^)(BOOL))completion
{
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    m_iQuantity = kStarRatingQuantity;
    [self initialization];
}

- (void)initialization
{
    
}

@end
