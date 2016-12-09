//
//  TestingVC.m
//  WBBIClient
//
//  Created by 黃韜 on 20/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "TestingVC.h"
#import "AlipayPayAction.h"
#import "GoodsListVC.h"
#import "GoodsDetailVC.h"
#import "HomeViewController.h"

@interface TestingVC ()

- (IBAction)UserLoginBPressed:(UIButton *)sender;
- (IBAction)UserRegisterBPressed:(UIButton *)sender;
- (IBAction)RealNameBPressed:(UIButton *)sender;
- (IBAction)InfoModifyBPressed:(UIButton *)sender;
- (IBAction)PersonalModify:(UIButton *)sender;
- (IBAction)UserIndexBPressed:(UIButton *)sender;
- (IBAction)GoodsFavourBPressed:(UIButton *)sender;
- (IBAction)GoodsLikeBPressed:(UIButton *)sender;
- (IBAction)CartListBPressed:(UIButton *)sender;
- (IBAction)OrderConfirmBPressed:(UIButton *)sender;
- (IBAction)GoodsCreateBPressed:(UIButton *)sender;
- (IBAction)GoodsIndexBPressed:(UIButton *)sender;
- (IBAction)GoodsListBPressed:(UIButton *)sender;

- (IBAction)PayTesting:(UIButton *)sender;
- (IBAction)IndexBPressed:(UIButton *)sender;

@end

@implementation TestingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)UserLoginBPressed:(UIButton *)sender
{
    UIViewController *login_vc = [[UIStoryboard storyboardWithName:@"User"
                                                            bundle:nil]
                                  instantiateViewControllerWithIdentifier:@"UserLoginVC"];
    [self.navigationController pushViewController:login_vc animated:YES];
}

- (IBAction)UserRegisterBPressed:(UIButton *)sender
{
    UIViewController *reg_vc = [[UIStoryboard storyboardWithName:@"User"
                                                          bundle:nil]
                                  instantiateViewControllerWithIdentifier:@"UserRegisterSubmitVC"];
    [self.navigationController pushViewController:reg_vc animated:YES];
}

- (IBAction)RealNameBPressed:(UIButton *)sender
{
    NSString *identify = @"UserIdentityValidateVC";
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"User"
                                                      bundle:nil]
                            instantiateViewControllerWithIdentifier:identify];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (IBAction)InfoModifyBPressed:(UIButton *)sender
{
    NSString *identify = @"UserInfoModifyVC";
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"User"
                                                      bundle:nil]
                            instantiateViewControllerWithIdentifier:identify];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (IBAction)PersonalModify:(UIButton *)sender
{
    NSString *identify = @"UserPersonalInfoModifyVC";
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"User"
                                                      bundle:nil]
                            instantiateViewControllerWithIdentifier:identify];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (IBAction)UserIndexBPressed:(UIButton *)sender
{
    NSString *identify = @"UserIndexVC";
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"User"
                                                      bundle:nil]
                            instantiateViewControllerWithIdentifier:identify];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (IBAction)GoodsFavourBPressed:(UIButton *)sender
{
    NSString *identify = @"GoodsListVC";
    GoodsListVC *vc = [[UIStoryboard storyboardWithName:@"Shop"
                                                      bundle:nil]
                            instantiateViewControllerWithIdentifier:identify];
    vc.Type = GoodsListTypeFavour;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (IBAction)GoodsLikeBPressed:(id)sender
{
    NSString *identify = @"GoodsListVC";
    GoodsListVC *vc = [[UIStoryboard storyboardWithName:@"Shop"
                                                      bundle:nil]
                       instantiateViewControllerWithIdentifier:identify];
    vc.Type = GoodsListTypeLike;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (IBAction)CartListBPressed:(UIButton *)sender
{
    NSString *identify = @"CartListVC";
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Shop"
                                                      bundle:nil]
                            instantiateViewControllerWithIdentifier:identify];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (IBAction)OrderConfirmBPressed:(UIButton *)sender
{
    NSString *identify = @"OrderConfirmVC";
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Shop"
                                                      bundle:nil]
                            instantiateViewControllerWithIdentifier:identify];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (IBAction)GoodsCreateBPressed:(UIButton *)sender
{
    NSString *identify = @"GoodsCreateVC";
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Shop"
                                                      bundle:nil]
                            instantiateViewControllerWithIdentifier:identify];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (IBAction)GoodsIndexBPressed:(UIButton *)sender
{
    NSString *identify = @"GoodsIndexVC";
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Shop"
                                                      bundle:nil]
                            instantiateViewControllerWithIdentifier:identify];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (IBAction)GoodsListBPressed:(UIButton *)sender
{
    NSString *identify = @"GoodsItemVC";
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Shop"
                                                      bundle:nil]
                            instantiateViewControllerWithIdentifier:identify];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (IBAction)GoodsDetailBPressed:(UIButton *)sender
{
    NSString *identify = @"GoodsDetailVC";
    GoodsDetailVC *vc = [[UIStoryboard storyboardWithName:@"Shop"
                                                   bundle:nil]
                            instantiateViewControllerWithIdentifier:identify];
    vc.GoodsDetailID = 18;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (IBAction)PayTesting:(UIButton *)sender
{
    [[AlipayPayAction new] paymentWithTradeID:[[NSNumber numberWithInt:rand()] stringValue]
                                      inPrice:0.01
                                     forGoods:[NSString stringWithFormat:@"testing %@", [[NSNumber numberWithInt:rand()] stringValue]]
                                   withDetail:@"testing"];
}

- (IBAction)IndexBPressed:(UIButton *)sender
{
    HomeViewController *vc = [[HomeViewController alloc]
                              initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
    [[UIApplication sharedApplication].delegate window].rootViewController = vc;
    //[self.navigationController pushViewController:vc
    //                                     animated:YES];
}

@end
