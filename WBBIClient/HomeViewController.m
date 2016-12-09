//
//  HomeViewController.m
//  CardFlippingExample
//
//  Created by Jarrod Robins on 3/08/13.
//  Copyright (c) 2013 Jarrod Robins. All rights reserved.
//

#import "HomeViewController.h"
#import <MJExtension.h>
#import "UIView+Style.h"
#import "UIViewController+ProgressHUD.h"
#import "CardFrontView.h"
#import "CardBackView.h"
#import "DetailViewController.h"
#import "UserIndexVC.h"
#import "GoodsIndexVC.h"
#import "GoodsItemVC.h"
#import "CartListVC.h"
#import "GoodsListVC.h"
#import "OrderListVC.h"
#import "UserModel.h"
#import "UserNetworking.h"
#import "PanoramaView.h"
#import "ConversationListController.h"

#define BottomViewWidth 200
#define BottomViewHeight 300

@interface HomeViewController ()
{
    NSInteger m_int_showingview;
    NSMutableArray<FlipContainerView *> *m_arr_bottomviews;
    UserModel *m_user;
    int count;
}

@property (strong, nonatomic) UITapGestureRecognizer *m_tapgesture;
@property (strong, nonatomic) UIViewController *detailView;
@property (strong, nonatomic) IBOutlet UIScrollView *BottomViews;
@property (strong, nonatomic) PanoramaView *PanoramaV;
@property (strong, nonatomic) IBOutlet UILabel *UserNameL;
@property (strong, nonatomic) IBOutlet UITextView *UserSignatureTV;

- (IBAction)UserInfoBPressed:(UIButton *)sender;

@end

@implementation HomeViewController

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    count = 0;
    
    // it's only set to a different colour in the XIB so we can easily see it.
    m_arr_bottomviews = [NSMutableArray<FlipContainerView *> array];
    
    _m_tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_scrollview:)];
    _m_tapgesture.numberOfTapsRequired = 1;
    _m_tapgesture.enabled = YES;
    _m_tapgesture.cancelsTouchesInView = NO;
    [_BottomViews addGestureRecognizer:_m_tapgesture];
    
    _PanoramaV = [[PanoramaView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _PanoramaV.motionEnabled = YES;
    [_PanoramaV setImage:[UIImage imageNamed:@"PBG"]];
    [self.view addSubview:_PanoramaV];
    
    // init data
    _UserNameL.text = NSLocalizedString(@"加载ing", @"");
    _UserSignatureTV.text = NSLocalizedString(@"App正在检查用户状态…", @"");
}

- (void)reload_userinfo
{
    
    [[UserNetworking new] UserInfo:^(HttpResponseJson *response_data) {
        
        if (response_data.StatusCode == 200) {
            m_user = [UserModel mj_objectWithKeyValues:response_data.Result];
            _UserNameL.text = m_user.NickName;
            _UserSignatureTV.text = m_user.Signature;
        } else {
            m_user = nil;
            _UserNameL.text = NSLocalizedString(@"未有登录", @"");
            _UserSignatureTV.text = NSLocalizedString(@"马上点击这里登录吧！", @"");
        }
        
    }];
    
}

- (void)init_bottom:(NSString *)image_name
{
    FlipContainerView *view = [[FlipContainerView alloc] initWithFrame:CGRectMake(0, 0, BottomViewWidth, BottomViewHeight)];
    CardFrontView *card_front = [[[NSBundle mainBundle] loadNibNamed:@"CardFrontView" owner:self options:nil] lastObject];
    CardBackView *card_back = [[[NSBundle mainBundle] loadNibNamed:@"CardBackView" owner:self options:nil] lastObject];
    [card_front.PhotoIV setImage:[UIImage imageNamed:image_name]];
    [card_front SetCornerRadius:10.0];
    card_front.frame = CGRectMake(0, 0, 200, 300);
    card_back.frame = [UIScreen mainScreen].bounds;
    view.delegate = self;
    view.frontView = card_front;
    view.backView = card_back;
    //UIView *view = [UIView new];
    //view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(count * (BottomViewWidth + 8.0) + 8.0,
                            self.view.frame.size.height - BottomViewHeight - 8.0,
                            BottomViewWidth,
                            BottomViewHeight);
    [_BottomViews addSubview:view];
    [m_arr_bottomviews addObject:view];
    ++count;
    card_front.tag = count;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (m_arr_bottomviews.count == 0) {
        [self init_bottom:@"PBUI_Index"];
        [self init_bottom:@"PBUI_Goods"];
        [self init_bottom:@"PBUI_Personal"];
        [self init_bottom:@"PBUI_Car"];
        [self init_bottom:@"PBUI_Favorite"];
        [self init_bottom:@"PBUI_MSG"];
        [self init_bottom:@"PBUI_Order"];
        _BottomViews.contentSize = CGSizeMake(count * (BottomViewWidth + 8.0) + 8.0,
                                              BottomViewHeight + 16.0);
    }
    
    [self reload_userinfo];
}

- (void)add_bottom_views:(UIView *)view number:(NSInteger)num
{
    view.frame = CGRectMake(num * (BottomViewWidth + 8.0),
                            8.0,
                            BottomViewWidth,
                            BottomViewHeight);
    [_BottomViews addSubview:view];
}

- (void)tap_scrollview:(UITapGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:_BottomViews];
    UIView *tapped_view = [_BottomViews hitTest:point withEvent:nil];
    if (tapped_view.tag == 0) {
        return;
    }
    m_int_showingview = tapped_view.tag - 1;
    FlipContainerView *view = [m_arr_bottomviews objectAtIndex:m_int_showingview];
    [_BottomViews bringSubviewToFront:view];
    view.backView.frame = CGRectMake(-[_BottomViews convertPoint:view.frame.origin toView:nil].x,
                                     0,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height);
    if (m_int_showingview < 2 || m_user) {
        [self showBack];
    } else {
        [self ShowProgressHUD:(ProgressHUDDurationTypeSoon2s)
                      message:NSLocalizedString(@"您还未登录呢", @"")
                         mode:(ProgressHUDModeTypeText)
        userInteractionEnable:YES];
    }
}

#pragma mark HomeViewController

- (UIViewController *)detailView {
	if (!_detailView) {
        NSString *storyboard;
        NSString *identify;
        BOOL navigation;
        
        if (m_int_showingview == 0) {
            
            storyboard = @"Shop";
            identify = @"GoodsIndexVC";
            navigation = YES;
            _detailView = [[UIStoryboard storyboardWithName:storyboard bundle:nil]
                           instantiateViewControllerWithIdentifier:identify];
            ((GoodsIndexVC *)_detailView).delegate = self;
            
        } else if (m_int_showingview == 1) {
            
            storyboard = @"Shop";
            identify = @"GoodsItemVC";
            navigation = YES;
            _detailView = [[UIStoryboard storyboardWithName:storyboard bundle:nil]
                           instantiateViewControllerWithIdentifier:identify];
            ((GoodsItemVC *)_detailView).delegate = self;
            
        } else if (m_int_showingview == 2) {
            
            storyboard = @"User";
            identify = @"UserIndexVC";
            navigation = YES;
            _detailView = [[UIStoryboard storyboardWithName:storyboard bundle:nil]
                           instantiateViewControllerWithIdentifier:identify];
            ((UserIndexVC *)_detailView).delegate = self;
            
        } else if (m_int_showingview == 3) {
            
            storyboard = @"Shop";
            identify = @"CartListVC";
            navigation = YES;
            _detailView = [[UIStoryboard storyboardWithName:storyboard bundle:nil]
                           instantiateViewControllerWithIdentifier:identify];
            ((CartListVC *)_detailView).delegate = self;
            
        } else if (m_int_showingview == 4) {
            
            storyboard = @"Shop";
            identify = @"GoodsListVC";
            navigation = YES;
            _detailView = [[UIStoryboard storyboardWithName:storyboard bundle:nil]
                           instantiateViewControllerWithIdentifier:identify];
            ((GoodsListVC *)_detailView).Type = GoodsListTypeFavour;
            ((GoodsListVC *)_detailView).delegate = self;
            
        } else if (m_int_showingview == 5) {
            
            navigation = YES;
            _detailView = [[ConversationListController alloc] initWithNibName:nil bundle:nil];
            ((ConversationListController *)_detailView).flip_container_delegate = self;
            
        } else if (m_int_showingview == 6) {
            
            storyboard = @"Order";
            identify = @"OrderListVC";
            navigation = YES;
            _detailView = [[UIStoryboard storyboardWithName:storyboard bundle:nil]
                           instantiateViewControllerWithIdentifier:identify];
            ((OrderListVC *)_detailView).delegate = self;
            
        }
        if (navigation) {
            _detailView = [[UINavigationController alloc] initWithRootViewController:_detailView];
        }
        
        //UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0.0);
        //[_detailView.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        //UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        //UIGraphicsEndImageContext();
        //FlipContainerView *fcv = [m_arr_bottomviews objectAtIndex:m_int_showingview];
        //[((CardBackView *)fcv.backView).ImageV setImage:img];
	}
	return _detailView;
}

#pragma mark FlipContainerDelegate

- (void)didShowFront {
    _detailView = nil;
}

- (void)didShowBack {
	if (!self.detailView.view.superview) {
		// don't do anything if the detail view already has a superview.
		self.detailView.view.alpha = 0.0f;
		
		[self.view addSubview:self.detailView.view];
		
		// animate in.
		[UIView animateWithDuration:0.3f animations:^{
			self.detailView.view.alpha = 1.0f;
		}];
	}
}

- (void)showFront {
	if ([m_arr_bottomviews objectAtIndex:m_int_showingview].isShowingBack) {
		[UIView animateWithDuration:0.3f animations:^{
			self.detailView.view.alpha = 0.0f;
		} completion:^(BOOL finished) {
			[self.detailView.view removeFromSuperview];
			[[m_arr_bottomviews objectAtIndex:m_int_showingview] flipToFront];
		}];
	}
    [self reload_userinfo];
}

- (void)showBack {
	if (![m_arr_bottomviews objectAtIndex:m_int_showingview].isShowingBack) {
        [_BottomViews bringSubviewToFront:[m_arr_bottomviews objectAtIndex:m_int_showingview]];
		[[m_arr_bottomviews objectAtIndex:m_int_showingview] flipToBack];
	}
}

- (IBAction)UserInfoBPressed:(UIButton *)sender
{
    if (m_user) {
        
        [_BottomViews setContentOffset:CGPointMake((BottomViewWidth + 8.0) * 2.0, 0) animated:YES];
        _BottomViews.userInteractionEnabled = NO;
        double delay_in_seconds = 0.5;
        dispatch_time_t pop_time = dispatch_time(DISPATCH_TIME_NOW, delay_in_seconds * NSEC_PER_SEC);
        dispatch_after(pop_time, dispatch_get_main_queue(), ^{
            m_int_showingview = 2;
            [self showBack];
            _BottomViews.userInteractionEnabled = YES;
        });
        
    } else {
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]
                                instantiateViewControllerWithIdentifier:@"UserLoginVC"];
        UINavigationController *nvc = [[UINavigationController alloc]
                                       initWithRootViewController:vc];
        vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", @"")
                                                                               style:(UIBarButtonItemStyleDone)
                                                                              target:self
                                                                              action:@selector(dismiss_subvc)];
        [self presentViewController:nvc animated:YES completion:nil];
    }
}

- (void)dismiss_subvc
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
