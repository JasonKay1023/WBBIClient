//
//  GoodsDetailTVC.m
//  WBBIClient
//
//  Created by 黃韜 on 14/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "GoodsDetailTVC.h"
#import <UIImageView+WebCache.h>
#import "NSString+URL.h"

@interface GoodsDetailTVC () <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *SlideShowSV;
@property (strong, nonatomic) IBOutlet UIPageControl *SlideShowPC;
@property (strong, nonatomic) IBOutlet UILabel *BrandL;
@property (strong, nonatomic) IBOutlet UILabel *TitleL;
@property (strong, nonatomic) IBOutlet UILabel *DiscoutL;
@property (strong, nonatomic) IBOutlet UILabel *PriceL;
@property (strong, nonatomic) IBOutlet UILabel *SellCountL;
@property (strong, nonatomic) IBOutlet UILabel *DetailBrandL;
@property (strong, nonatomic) IBOutlet UILabel *DetailTypeL;
@property (strong, nonatomic) IBOutlet UILabel *DetailMadeInL;
@property (strong, nonatomic) IBOutlet UILabel *DetailLengthL;
@property (strong, nonatomic) IBOutlet UILabel *DetailWidthL;
@property (strong, nonatomic) IBOutlet UILabel *DetailHeightL;
@property (strong, nonatomic) IBOutlet UILabel *DetailAccessoryL;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation GoodsDetailTVC

- (void)awakeFromNib {
    [self addTimer];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)LoadGoods:(GoodsModel *)goods_instance
{
    NSString *type_name;
    for (NSDictionary *type_dict in goods_instance.Types) {
        NSString *type = [type_dict objectForKey:@"Type"];
        if ([type isEqualToString:@"bag_type"]) {
            type_name = [[[type_dict objectForKey:@"Attribute"] firstObject] objectForKey:@"Name"];
        }
    }
    _BrandL.text = goods_instance.Brand;
    _TitleL.text = goods_instance.Title;
    _DiscoutL.text = [[NSNumber numberWithInteger:[goods_instance.Price integerValue] / 10] stringValue];
    _PriceL.text = [goods_instance.Price stringValue];
    _SellCountL.text = @"0";
    _DetailBrandL.text = goods_instance.Brand;
    _DetailTypeL.text = type_name;
    _DetailMadeInL.text = goods_instance.MadeIn;
    _DetailLengthL.text = [[NSNumber numberWithInteger:goods_instance.Length] stringValue];
    _DetailWidthL.text = [[NSNumber numberWithInteger:goods_instance.Width] stringValue];
    _DetailHeightL.text = [[NSNumber numberWithInteger:goods_instance.Height] stringValue];
    _DetailAccessoryL.text = goods_instance.Accessory;
    
    [self insert_photos:goods_instance.PhotoDetailC number_of_view:0];
    [self insert_photos:goods_instance.PhotoFront number_of_view:1];
    [self insert_photos:goods_instance.PhotoOverlook number_of_view:2];
    [self insert_photos:goods_instance.PhotoLeft number_of_view:3];
    [self insert_photos:goods_instance.PhotoBack number_of_view:4];
    [self insert_photos:goods_instance.PhotoLookup number_of_view:5];
    [self insert_photos:goods_instance.PhotoRight number_of_view:6];
    [self insert_photos:goods_instance.PhotoDetailA number_of_view:7];
    [self insert_photos:goods_instance.PhotoDetailB number_of_view:8];
    [self insert_photos:goods_instance.PhotoDetailC number_of_view:9];
    [self insert_photos:goods_instance.PhotoFront number_of_view:10];
    
    _SlideShowSV.contentSize = CGSizeMake(self.frame.size.width *11,
                                          self.frame.size.width);
    _SlideShowSV.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    _SlideShowSV.delegate = self;
    _SlideShowPC.pageIndicatorTintColor = [UIColor lightGrayColor];
    _SlideShowPC.currentPageIndicatorTintColor = [UIColor colorWithRed:230.0 / 255.0 green:80.0 / 255.0 blue:130.0 / 255.0 alpha:1.0];
}

- (void)insert_photos:(NSString *)avatar_url number_of_view:(NSInteger)num
{
    CGFloat origin = num * self.frame.size.width;
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(origin,
                                                                       0,
                                                                       self.frame.size.width,
                                                                       self.frame.size.width)];
    CGPoint scroll_point = CGPointMake(self.frame.size.width * 1, 0);
    [_SlideShowSV setContentOffset:scroll_point animated:YES];
    [image sd_setImageWithURL:[[avatar_url AppendServerPhotoURL] ToURL] placeholderImage:[UIImage imageNamed:@"PBUI-BG"]];
    [_SlideShowSV addSubview:image];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat page_width = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + page_width * 0.5) / page_width - 1;
    if (page == 9) {
        page = 0;
    }else if (page == -1){
        page = 8;
    }
    _SlideShowPC.currentPage = page;
}

- (void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(toNextImage) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)toNextImage{
    CGFloat image_width = _SlideShowSV.frame.size.width;
    NSInteger page = _SlideShowPC.currentPage;
    if (page == 9) {
        page = 0;
    }else {
        page++;
    }
    [_SlideShowSV setContentOffset:CGPointMake(image_width * (page + 1), 0)animated:YES];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat image_width = _SlideShowSV.frame.size.width;
    int index = (_SlideShowSV.contentOffset.x + image_width * 0.5) / image_width - 1;
    if (index == 9) {
        [_SlideShowSV setContentOffset:CGPointMake(image_width, 0) animated:NO];
    } else if (index == -1) {
        [_SlideShowSV setContentOffset:CGPointMake(9 * image_width, 0) animated:NO];
    }
}
@end
