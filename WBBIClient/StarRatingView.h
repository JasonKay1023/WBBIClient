//
//  StarRatingView.h
//  WBBIClient
//
//  Created by 黃韜 on 18/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kStarRatingQuantity 5

@class StarRatingView;

@protocol StarRatingViewDelegate <NSObject>

@optional
- (void)StarRatingView:(StarRatingView *)view Score:(float)score;

@end

#pragma mark - StarRatingView

@interface StarRatingView : UIView

@property (nonatomic, weak) id<StarRatingViewDelegate> Delegate;
@property (nonatomic, readonly) NSInteger Quantity;

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)number;
- (void)SetScore:(float)score WithAnimation:(BOOL)animated;
- (void)SetScore:(float)score WithAnimation:(BOOL)animated
      Completion:(void (^)(BOOL finished))completion;

@end
