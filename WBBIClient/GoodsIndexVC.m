//
//  GoodsIndexVC.m
//  WBBIClient
//
//  Created by 黃韜 on 9/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "GoodsIndexVC.h"
#import <MJExtension.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "GoodsDetailVC.h"
#import "GoodsModel.h"
#import "GoodsCardV.h"
//#import "GoodsStackV.h"
#import "GoodsIndexItemV.h"
#import "GoodsLikeNetworking.h"
#import "GoodsFavourNetworking.h"
#import "GoodsListVC.h"
#import "UIViewController+ProgressHUD.h"
#import "IndexGoodsModel.h"
#import "IndexNetworking.h"
#import "NSString+URL.h"
#import "GoodsItemVC.h"

#define LOAD_COUNT 10

@interface GoodsIndexVC () <DraggableCardViewDelegate> // <GoodsStackDataSource, GoodsStackDelegate>
{
    NSString *last_created;
    IndexGoodsType type;
    NSArray *segment_goods;
    UISegmentedControl *GoodsTypeSC;
}

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *GoodsLoadingAIV;
@property (weak, nonatomic) IBOutlet UIView *CardPlaceholderV;
//@property (weak, nonatomic) IBOutlet GoodsStackV *PhotoStackV;
@property (strong, nonatomic) NSArray<GoodsModel *> *photoArray;
//@property (strong, nonatomic) GoodsIndexItemV *goodsView;
@property (nonatomic, strong) NSMutableArray<GoodsCardV *> *cardViews;
@property (weak, nonatomic) IBOutlet UIButton *MoreB;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *MenuBB;
@property (strong, nonatomic) UIViewController *MenuTV;

- (IBAction)MenuBBPressed:(UIBarButtonItem *)sender;
- (IBAction)CreateGoodsBBPressed:(id)sender;
- (IBAction)FavouriteBPressed:(UIButton *)sender;
- (IBAction)MoreBPressed:(UIButton *)sender;

@end

@implementation GoodsIndexVC

//@synthesize GoodsTypeSC = m_sc_type;
@synthesize photoArray = m_arr_photo;


- (void)viewDidLoad
{
    
    _MenuTV = [[UITableViewController alloc] initWithStyle:(UITableViewStylePlain)];
    UIView *statusBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    statusBar.backgroundColor = [UIColor colorWithRed:225.0 / 255.0 green:75.0 / 255.0 blue:125.0 / 255.0 alpha:1.0];
    
    [self initSegmentedControl];
    
    _cardViews = [NSMutableArray array];
    _CardPlaceholderV.hidden = YES;
    _GoodsLoadingAIV.hidden = YES;

    type = IndexGoodsTypeOfficial;
    [self load_next:NO];
    
    [self.view addSubview:statusBar];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self layoutCardViews];
}

- (void)initSegmentedControl
{
    segment_goods = [NSArray arrayWithObjects:@"创造", @"精品", @"发现", nil];
    GoodsTypeSC = [[UISegmentedControl alloc]initWithItems:segment_goods];
    [GoodsTypeSC setFrame:CGRectMake(-3, 64, self.view.frame.size.width+6, 40)];
    [GoodsTypeSC addTarget:self action:@selector(SegmentChanged) forControlEvents:UIControlEventValueChanged];
    GoodsTypeSC.selectedSegmentIndex = 1;
    GoodsTypeSC.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:202.0/255.0 blue:217/255.0 alpha:1.0];
    GoodsTypeSC.tintColor = [UIColor colorWithRed:230.0/255.0 green:80.0/255.0 blue:130.0/255.0 alpha:1.0];
    [self.view addSubview:GoodsTypeSC];
    
    NSDictionary *fontSize = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18.0],NSFontAttributeName, nil];
    [GoodsTypeSC setTitleTextAttributes:fontSize forState:UIControlStateNormal];
}

- (void)cardView:(DraggableCardView *)cardView
didEndSwipeToDirection:(SwipeDirection)swipeDirection
{
    GoodsCardV *obj = [_cardViews objectAtIndex:0];
    if (LeftSwipeDirection == swipeDirection) {
        
//        [self ShowProgressHUD:(ProgressHUDDurationTypeStay)
//                      message:NSLocalizedString(@"", @"")
//                         mode:(ProgressHUDModeTypeIndeterminate)
//        userInteractionEnable:YES];
        [[[GoodsFavourNetworking alloc] initWithGoodsID:[NSNumber numberWithInteger:obj.id]] Create:^(HttpResponseJson *response) {
            
//            [self HideProgressHUD];
//            [self ShowProgressHUD:(ProgressHUDDurationTypeSoon1_5s)
//                          message:NSLocalizedString(@"点赞！", @"")
//                             mode:(ProgressHUDModeTypeText)
//            userInteractionEnable:YES];
            
        } duplicated:^(HttpResponseJson *response) {
//            
//            [self HideProgressHUD];
//            [self ShowProgressHUD:(ProgressHUDDurationTypeSoon1_5s)
//                          message:NSLocalizedString(@"已点赞", @"")
//                             mode:(ProgressHUDModeTypeText)
//            userInteractionEnable:YES];
            
        } fail:^(HttpResponseJson *response) {
            
//            [self HideProgressHUD];
//            [self ShowProgressHUD:(ProgressHUDDurationTypeSoon1_5s)
//                          message:NSLocalizedString(@"点赞失败", @"")
//                             mode:(ProgressHUDModeTypeText)
//            userInteractionEnable:YES];
            
        }];
    } else if (RightSwipeDirection == swipeDirection) {
        
//        [self ShowProgressHUD:(ProgressHUDDurationTypeStay)
//                      message:NSLocalizedString(@"", @"")
//                         mode:(ProgressHUDModeTypeIndeterminate)
//        userInteractionEnable:YES];
        [[[GoodsLikeNetworking alloc] initWithGoodsID:[NSNumber numberWithInteger:obj.id]] Create:^(HttpResponseJson *response) {
            
//            [self HideProgressHUD];
//            [self ShowProgressHUD:(ProgressHUDDurationTypeSoon1_5s)
//                          message:NSLocalizedString(@"收藏！", @"")
//                             mode:(ProgressHUDModeTypeText)
//            userInteractionEnable:YES];
            
        } duplicated:^(HttpResponseJson *response) {
            
//            [self HideProgressHUD];
//            [self ShowProgressHUD:(ProgressHUDDurationTypeSoon1_5s)
//                          message:NSLocalizedString(@"已收藏", @"")
//                             mode:(ProgressHUDModeTypeText)
//            userInteractionEnable:YES];
//            
        } fail:^(HttpResponseJson *response) {
            
//            [self HideProgressHUD];
//            [self ShowProgressHUD:(ProgressHUDDurationTypeSoon1_5s)
//                          message:NSLocalizedString(@"收藏失败", @"")
//                             mode:(ProgressHUDModeTypeText)
//            userInteractionEnable:YES];
            
        }];
    }
    [_cardViews removeObjectAtIndex:0];
    if (_cardViews.count == 0) {
        [self load_next:NO];
    }
}

- (void)load_next:(BOOL)type_changed
{
    if (type_changed) {
        last_created = nil;
        m_arr_photo = @[];
        for (GoodsCardV *view in _cardViews) {
            [view removeFromSuperview];
        }
        [_cardViews removeAllObjects];
    }
    _GoodsLoadingAIV.hidden = NO;
    [_GoodsLoadingAIV startAnimating];
    [[IndexNetworking new] GetGoodsType:(type) before:last_created count:LOAD_COUNT success:^(IndexGoodsModel *goods) {
        
        _GoodsLoadingAIV.hidden = YES;
        [_GoodsLoadingAIV stopAnimating];
        
        m_arr_photo = [GoodsModel mj_objectArrayWithKeyValuesArray:goods.Goods];
        if (m_arr_photo.count == 0) {
            last_created = nil;
            [self ShowProgressHUD:(ProgressHUDDurationTypeSoon1_5s)
                          message:NSLocalizedString(@"没有啦~", @"")
                             mode:(ProgressHUDModeTypeText)
            userInteractionEnable:YES];
            return;
        }
        last_created = goods.FirstCreated;
        [self load_object];
        
    } fail:^(HttpResponseJson *response) {
        
        _GoodsLoadingAIV.hidden = YES;
        [_GoodsLoadingAIV stopAnimating];
        
        [self ShowProgressHUD:(ProgressHUDDurationTypeSoon1_5s)
                      message:NSLocalizedString(@"加载失败…", @"")
                         mode:(ProgressHUDModeTypeText)
        userInteractionEnable:YES];
        
    }];
}

- (void)load_object
{
    for (NSUInteger i = 0; i != m_arr_photo.count; ++i)
    {
        GoodsCardV *cardView = [[[NSBundle mainBundle] loadNibNamed:@"GoodsCardV" owner:self options:nil]
                                firstObject];
        GoodsModel *goods = [m_arr_photo objectAtIndex:i];
        cardView.id = goods.id;
        cardView.frame = _CardPlaceholderV.frame;
        cardView.delegateOfDragging = self;
        cardView.rightOverlayImage = [UIImage imageNamed:@"PBUI_Home_LoveBox"];
        cardView.leftOverlayImage = [UIImage imageNamed:@"PBUI_Home_CollectionBox"];
        [cardView sendSubviewToBack:cardView.PhotoIV];
        [cardView.PhotoIV sd_setImageWithURL:[[goods.PhotoFront AppendServerURL] ToURL] placeholderImage:[UIImage imageNamed:@"PBUI-BG"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [cardView sendSubviewToBack:cardView.PhotoIV];
        }];
        cardView.TitileL.text = goods.Title;
        cardView.BrandL.text = goods.Brand;
        cardView.PriceL.text = [goods.Price stringValue];
        [_cardViews addObject:cardView];
    }
    
    for (GoodsCardV *cardView in _cardViews.reverseObjectEnumerator)
    {
        [self.view addSubview:cardView];
    }
    [self.view bringSubviewToFront:_MoreB];
}

- (void)cardViewDidPressed:(DraggableCardView *)cardView
{
    GoodsDetailVC *vc = [[UIStoryboard storyboardWithName:@"Shop" bundle:nil]
                         instantiateViewControllerWithIdentifier:@"GoodsDetailVC"];
    vc.GoodsDetailID = ((GoodsCardV *)cardView).id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)SegmentChanged;
{
    switch (GoodsTypeSC.selectedSegmentIndex) {
        case 0:
            type = IndexGoodsTypeCreation;
            break;
            
        case 1:
            type = IndexGoodsTypeOfficial;
            break;
            
        case 2:
            type = IndexGoodsTypeDiscover;
            break;
            
        default:
            break;
    }
    [self load_next:YES];
}

- (IBAction)MenuBBPressed:(UIBarButtonItem *)sender
{
    [self.delegate showFront];
}

- (IBAction)CreateGoodsBBPressed:(id)sender
{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Shop" bundle:nil] instantiateViewControllerWithIdentifier:@"GoodsCreateVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)FavouriteBPressed:(UIButton *)sender
{
    GoodsListVC *vc = [[UIStoryboard storyboardWithName:@"Shop" bundle:nil]
                       instantiateViewControllerWithIdentifier:@"GoodsListVC"];
    vc.Type = GoodsListTypeFavour;
    vc.navigationItem.leftBarButtonItem = nil;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)MoreBPressed:(UIButton *)sender
{
    GoodsItemVC *vc = [[GoodsItemVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


//@synthesize PhotoStackV = m_view_photostack;
//@synthesize goodsView = m_view_goods;
/*
- (void)viewDidLoad
{
    [super viewDidLoad];
    m_view_photostack.Delegate = self;
    m_view_photostack.DataSource = self;
    
    [self ShowProgressHUD:(ProgressHUDDurationTypeStay)
                  message:NSLocalizedString(@"Loading", @"")
                     mode:(ProgressHUDModeTypeIndeterminate)
    userInteractionEnable:YES];
    [[IndexNetworking new] GetGoodsType:(IndexGoodsTypeDiscover) before:nil count:10 success:^(IndexGoodsModel *goods) {
        
        [self HideProgressHUD];
        m_arr_photo = [GoodsModel mj_objectArrayWithKeyValuesArray:goods.Goods];
        last_created = goods.FirstCreated;
        cursor = 0;
        
    } fail:^(HttpResponseJson *response) {
        
        [self HideProgressHUD];
        [self ShowProgressHUD:(ProgressHUDDurationTypeSoon1_5s)
                      message:NSLocalizedString(@"LoadingError", @"")
                         mode:(ProgressHUDModeTypeText)
        userInteractionEnable:YES];
        
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [m_view_photostack ToNextView];
}

- (UIView *)NextView
{
 
    //UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    //view.backgroundColor= [UIColor colorWithRed:((10 * (rand() % 10)) / 255.0) green:((20 * (rand() % 10))/255.0) blue:((30 * (rand() % 10))/255.0) alpha:1.0f];
    //return view;
    
    if (cursor == m_arr_photo.count) {
        
        return nil;
    }
    GoodsModel *obj = [m_arr_photo objectAtIndex:cursor];
    
    m_view_goods = [[[NSBundle mainBundle] loadNibNamed:@"GoodsIndexItemV"
                                                  owner:self
                                                options:nil]
                    lastObject];
    //m_view_goods.backgroundColor = [UIColor grayColor];
    m_view_goods.AvatarIV.backgroundColor = [UIColor lightGrayColor];
    m_view_goods.AvatarIV.frame = CGRectMake(0,
                                             0,
                                             self.view.frame.size.width / 1.2,
                                             self.view.frame.size.width / 1.2);
    m_view_goods.TitleL.text = obj.Title;
    ++cursor;
    return m_view_goods;
}

- (void)Like
{
    [self ShowProgressHUD:ProgressHUDDurationTypeSoon1s
                  message:NSLocalizedString(@"LikeGoods", @"")
                     mode:ProgressHUDModeTypeText
    userInteractionEnable:YES];
}

- (void)Tap
{
    [self ShowProgressHUD:ProgressHUDDurationTypeSoon1s
                  message:NSLocalizedString(@"TapGoods", @"")
                     mode:ProgressHUDModeTypeText
    userInteractionEnable:YES];
}*/
@end
