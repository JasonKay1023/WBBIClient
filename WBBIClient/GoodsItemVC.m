//
//  GoodsItemVC.m
//  WBBIClient
//
//  Created by 黃韜 on 9/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "GoodsItemVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJExtension.h>
#import "GoodsItemCVC.h"
#import "GoodsModel.h"
#import "IndexNetworking.h"
#import "GoodsDetailVC.h"
#import "GoodsItemHeaderV.h"
#import "GoodsItemBottomV.h"
#import "NSString+URL.h"
#import "UIViewController+ProgressHUD.h"
#import "DropDownListView.h"

#define LOAD_COUNT 10
#define HeaderHeight 80.0
#define BottomHeight 75.0

@interface GoodsItemVC ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UISearchBarDelegate,
UISearchDisplayDelegate,
UISearchControllerDelegate,
UITableViewDelegate,
UITableViewDataSource,
DropDownListDelegate,
DropDownListDataSource>
{
    NSString *last_created;
    IndexGoodsType type;
    UICollectionView *m_collectionview;
    UICollectionViewFlowLayout *m_flowlayout;
    UITableView *m_tableview;
    UISearchBar *m_searchbar;
    UISearchController *m_searchcontroller;
    UISearchDisplayController *m_searchdisplay;
    GoodsItemHeaderV *m_view_header;
    GoodsItemBottomV *m_view_bottom;
    NSInteger menuID;
    NSInteger currentSelectMenu;
    DropDownListView *dropDownMenu;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *CartBB;
@property (strong, nonatomic) NSMutableArray<GoodsModel *> *goodsArray;
@property (strong, nonatomic) NSArray *searchArray;

- (IBAction)CartBBPressed:(UIBarButtonItem *)sender;
- (IBAction)BackBBPressed:(id)sender;

@end

@implementation GoodsItemVC

@synthesize goodsArray = m_arrGoods;
@synthesize searchArray = m_arrSearch;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.title = NSLocalizedString(@"商品列表", @"");
    
    currentSelectMenu = -1;
    
    UIView *statusBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    statusBar.backgroundColor = [UIColor colorWithRed:225.0 / 255.0 green:75.0 / 255.0 blue:125.0 / 255.0 alpha:1.0];
     
    //dropdownMenu

    dropDownMenu = [[DropDownListView alloc]initWithFrame:CGRectMake(0, 101, self.view.frame.size.width, 37) dataSource:self delegate:self];
    dropDownMenu.m_superView = self.view;

    
    // Collection view initialization
    
    m_flowlayout = [[UICollectionViewFlowLayout alloc] init];
    m_flowlayout.itemSize = CGSizeMake(self.view.frame.size.width / 2.0 - 8.5,
                                       self.view.frame.size.width / 2.0 + 60.0);
    m_flowlayout.sectionInset = UIEdgeInsetsMake(5.0, 3.5, 5.0, 3.5);
    [m_flowlayout setScrollDirection:(UICollectionViewScrollDirectionVertical)];
    
    m_collectionview = [[UICollectionView alloc] initWithFrame:self.view.frame
                                          collectionViewLayout:m_flowlayout];
    
    //[m_collectionview setBackgroundColor:[UIColor colorWithRed:(221.0/255.0) green:(54.0/255.0) blue:(111.0/255.0) alpha:1.0]];
    m_collectionview.delegate = self;
    m_collectionview.dataSource = self;
    m_collectionview.backgroundColor = [UIColor colorWithRed:(242.0/255.0) green:(242.0/255.0) blue:(242.0/255.0) alpha:1.0];
    [m_collectionview registerNib:[UINib nibWithNibName:@"GoodsItemCell" bundle:nil]
          forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:m_collectionview];
    
    m_arrGoods = [NSMutableArray array];
    
    // Header view
    
    m_view_header = [[[NSBundle mainBundle]
                      loadNibNamed:@"GoodsItemHeaderV" owner:self options:nil] lastObject];
    m_view_header.frame = CGRectMake(0,
                                     64.0,
                                     self.view.frame.size.width,
                                     HeaderHeight);
    [m_view_header.SellB addTarget:self
                            action:@selector(sell_b)
                  forControlEvents:(UIControlEventTouchUpInside)];
    [m_view_header.PriceB addTarget:self
                             action:@selector(price_b)
                   forControlEvents:(UIControlEventTouchUpInside)];
    [m_view_header.CommentB addTarget:self
                               action:@selector(comment_b)
                     forControlEvents:(UIControlEventTouchUpInside)];
    [m_view_header.HotB addTarget:self
                           action:@selector(hot_b)
                 forControlEvents:(UIControlEventTouchUpInside)];
    [m_view_header.BrandB addTarget:self
                             action:@selector(brand_b)
                   forControlEvents:(UIControlEventTouchUpInside)];
    [m_view_header.SceneB addTarget:self
                             action:@selector(scene_b)
                   forControlEvents:(UIControlEventTouchUpInside)];
    [m_view_header.TypeB addTarget:self
                            action:@selector(type_b)
                  forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:m_view_header];
    [self.view bringSubviewToFront:m_view_header];
    
    // Pop up menu
    
    m_view_bottom = [[[NSBundle mainBundle]
                      loadNibNamed:@"GoodsItemBottomV" owner:self options:nil] lastObject];
    [m_view_bottom.ButtonA addTarget:self
                              action:@selector(bottom_a)
                    forControlEvents:(UIControlEventTouchUpInside)];
    [m_view_bottom.ButtonB addTarget:self
                              action:@selector(bottom_b)
                    forControlEvents:(UIControlEventTouchUpInside)];
    [m_view_bottom.ButtonC addTarget:self
                              action:@selector(bottom_c)
                    forControlEvents:(UIControlEventTouchUpInside)];
    [m_view_bottom.MenuB addTarget:self
                            action:@selector(menu)
                  forControlEvents:(UIControlEventTouchUpInside)];
    m_view_bottom.frame = CGRectMake(0,
                                     self.view.frame.size.height - BottomHeight,
                                     self.view.frame.size.width,
                                     BottomHeight);
    [self.view addSubview:m_view_bottom];
    [self.view bringSubviewToFront:m_view_bottom];
    [self.view addSubview:dropDownMenu];
    
    // Table view initialization
    
    m_tableview = [[UITableView alloc] initWithFrame:self.view.frame
                                               style:(UITableViewStylePlain)];
    
    // Search Bar
    
    //m_searchbar = [[UISearchBar alloc] init];
    //m_searchbar.delegate = self;
    //[m_searchbar setPlaceholder:NSLocalizedString(@"搜索", @"")];
    //self.navigationItem.titleView = m_searchbar;
    
    //m_searchdisplay = [[UISearchDisplayController alloc]
    //                   initWithSearchBar:m_searchbar contentsController:self];
    //m_searchdisplay.delegate = self;
    //m_searchdisplay.searchResultsDataSource = self;
    //m_searchdisplay.searchResultsDelegate = self;
    
    // init
    
    type = IndexGoodsTypeCreation;
    last_created = nil;
    
    [self load_next:NO];
    [self.view addSubview:statusBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [m_collectionview reloadData];
}

- (NSInteger)numberOfItems{
    return 3;
}

- (NSInteger)numberOfRowsInItem:(NSInteger)item{
    switch (item) {
        case 0:
            return [dropDownMenu.brandArray count];
            break;
        case 1:
            return [dropDownMenu.sceneArray count];
            break;
        case 2:
            return [dropDownMenu.typeArray count];
            break;
        default:
            break;
    }
    return 0;
}

- (NSString *)titleInItem:(NSInteger)item index:(NSInteger)index{
    switch (item) {
        case 0:
            return ((KVModel *)[dropDownMenu.brandArray objectAtIndex:index]).Name;
            break;
        case 1:
            return ((KVModel *)[dropDownMenu.sceneArray objectAtIndex:index]).Name;
            break;
        case 2:
            return ((KVModel *)[dropDownMenu.typeArray objectAtIndex:index]).Name;
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)defaultShowItem:(NSInteger)Item{
    return 0;
}

- (void)load_next:(BOOL)type_changed
{
    if (type_changed) {
        last_created = nil;
        [m_arrGoods removeAllObjects];
        [m_collectionview reloadData];
    }
    [self ShowProgressHUD:(ProgressHUDDurationTypeStay)
                  message:NSLocalizedString(@"加载ing", @"")
                     mode:(ProgressHUDModeTypeIndeterminate)
    userInteractionEnable:YES];
    [[IndexNetworking new] GetGoodsType:(type) before:last_created count:LOAD_COUNT success:^(IndexGoodsModel *goods) {
        
        [self HideProgressHUD];
        [m_arrGoods addObjectsFromArray:[GoodsModel mj_objectArrayWithKeyValuesArray:goods.Goods]];
        if (m_arrGoods.count == 0) {
            last_created = nil;
            [self ShowProgressHUD:(ProgressHUDDurationTypeSoon1_5s)
                          message:NSLocalizedString(@"没有咯~", @"")
                             mode:(ProgressHUDModeTypeText)
            userInteractionEnable:YES];
            return;
        }
        last_created = goods.FirstCreated;
        [m_collectionview reloadData];
        
    } fail:^(HttpResponseJson *response) {
        
        [self HideProgressHUD];
        [self ShowProgressHUD:(ProgressHUDDurationTypeSoon1_5s)
                      message:NSLocalizedString(@"加载失败", @"")
                         mode:(ProgressHUDModeTypeText)
        userInteractionEnable:YES];
        
    }];
}

- (void)test
{
    GoodsModel *obj = [GoodsModel new];
    obj.id = 18;
    obj.Title = @"Good bags of mine";
    obj.Brand = @"Louis Vuitton";
    obj.Price = @1000.0;
    obj.PhotoFront = @"/";
    [m_arrGoods addObject:obj];
    [m_arrGoods addObject:obj];
    [m_arrGoods addObject:obj];
    [m_arrGoods addObject:obj];
    [m_arrGoods addObject:obj];
    [m_arrGoods addObject:obj];
    [m_arrGoods addObject:obj];
    [m_arrGoods addObject:obj];
    [m_arrGoods addObject:obj];
    [m_arrGoods addObject:obj];
    [m_arrGoods addObject:obj];
    [m_arrGoods addObject:obj];
    [m_arrGoods addObject:obj];
    [m_arrGoods addObject:obj];
    [m_arrGoods addObject:obj];
    [m_arrGoods addObject:obj];
    [m_arrGoods addObject:obj];
    [m_arrGoods addObject:obj];
    [m_arrGoods addObject:obj];
    [m_arrGoods addObject:obj];
    [m_collectionview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)CartBBPressed:(UIBarButtonItem *)sender
{
    
}

- (IBAction)BackBBPressed:(id)sender
{
    [_delegate showFront];
}

#pragma mark - Collection view datasource & delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return m_arrGoods.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsItemCVC *cell = [m_collectionview dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                                     forIndexPath:indexPath];
    GoodsModel *obj = [m_arrGoods objectAtIndex:indexPath.row];
    [cell.AvatarIV sd_setImageWithURL:[[obj.PhotoFront AppendServerURL] ToURL] placeholderImage:[UIImage imageNamed:@"PBUI-BG"]];
    cell.TitleL.text = obj.Title;
    cell.BrandL.text = obj.Brand;
    cell.PriceL.text = [obj.Price stringValue];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailVC *vc = [[UIStoryboard storyboardWithName:@"Shop" bundle:nil]
                         instantiateViewControllerWithIdentifier:@"GoodsDetailVC"];
    vc.GoodsDetailID = [m_arrGoods objectAtIndex:indexPath.row].id;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}
/*
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *view = [m_collectionview dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        return view;
    }
    return nil;
}*/

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width, BottomHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width, HeaderHeight);
}

#pragma mark - Search display delegate

- (void)searchDisplayController:(UISearchDisplayController *)controller
  didLoadSearchResultsTableView:(UITableView *)tableView
{
    [m_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

#pragma mark - Table view datasource & delegate

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return m_arrSearch.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    return cell;
}

#pragma mark - Header view

- (void)sell_b
{
    menuID = 0;
    if (currentSelectMenu == menuID) {
        [m_view_header.SellB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Sales_01"] forState:UIControlStateNormal];
        [self currentSelectMenureload];
    }else{
        currentSelectMenu = menuID;
        [m_view_header.SellB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Sales_02"] forState:UIControlStateNormal];
        [m_view_header.PriceB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Price_01"] forState:UIControlStateNormal];
        [m_view_header.CommentB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Appraise_01"] forState:UIControlStateNormal];
        [m_view_header.HotB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Hot_01"] forState:UIControlStateNormal];
        
        
    }
}

- (void)price_b
{
    menuID = 1;
    if (currentSelectMenu == menuID) {
        [m_view_header.PriceB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Price_01"] forState:UIControlStateNormal];
        [self currentSelectMenureload];
    }else{
        currentSelectMenu = menuID;
        [m_view_header.PriceB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Price_02"] forState:UIControlStateNormal];
        [m_view_header.HotB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Hot_01"] forState:UIControlStateNormal];
        [m_view_header.CommentB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Appraise_01"] forState:UIControlStateNormal];
        [m_view_header.SellB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Sales_01"] forState:UIControlStateNormal];
        
    }
}

- (void)comment_b
{
    menuID = 2;
    if (currentSelectMenu == menuID) {
        [m_view_header.CommentB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Appraise_01"] forState:UIControlStateNormal];
        [self currentSelectMenureload];
    }else{
        currentSelectMenu = menuID;
        [m_view_header.CommentB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Appraise_02"] forState:UIControlStateNormal];
        [m_view_header.PriceB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Price_01"] forState:UIControlStateNormal];
        [m_view_header.HotB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Hot_01"] forState:UIControlStateNormal];
        [m_view_header.SellB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Sales_01"] forState:UIControlStateNormal];
        
    }
}

- (void)hot_b
{
    menuID = 3;
    if (currentSelectMenu == menuID) {
        [m_view_header.HotB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Hot_01"] forState:UIControlStateNormal];
        [self currentSelectMenureload];
    }else{
        currentSelectMenu = menuID;
        [m_view_header.HotB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Hot_02"] forState:UIControlStateNormal];
        [m_view_header.SellB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Sales_01"] forState:UIControlStateNormal];
        [m_view_header.PriceB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Price_01"] forState:UIControlStateNormal];
        [m_view_header.CommentB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Appraise_01"] forState:UIControlStateNormal];
    }
}

- (void)currentSelectMenureload{
    if (currentSelectMenu != -1) {
        currentSelectMenu = -1;
    }
}

- (void)brand_b
{
    if (m_view_header.BrandB.selected == NO) {
        [m_view_header.BrandB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Brand_02"] forState:UIControlStateNormal];
        m_view_header.BrandB.selected = YES;
    }
    else if (m_view_header.BrandB.selected == YES) {
        [m_view_header.BrandB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Brand_01"] forState:UIControlStateNormal];
        m_view_header.BrandB.selected = NO;
    }
}

- (void)scene_b
{
    if (m_view_header.SceneB.selected == NO) {
        [m_view_header.SceneB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Occasion_02"] forState:UIControlStateNormal];
        m_view_header.SceneB.selected = YES;
    }
    else if (m_view_header.SceneB.selected == YES) {
        [m_view_header.SceneB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Occasion_01"] forState:UIControlStateNormal];
        m_view_header.SceneB.selected = NO;
    }
}

- (void)type_b
{
    if (m_view_header.TypeB.selected == NO) {
        [m_view_header.TypeB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Type_02"] forState:UIControlStateNormal];
        m_view_header.TypeB.selected = YES;
    }
    else if (m_view_header.TypeB.selected == YES) {
        [m_view_header.TypeB setImage:[UIImage imageNamed:@"PBUI_CommodityList_Type_01"] forState:UIControlStateNormal];
        m_view_header.TypeB.selected = NO;
    }
}

#pragma mark - Bottom view

- (void)bottom_a
{
    type = IndexGoodsTypeOfficial;
    [self load_next:YES];
}

- (void)bottom_b
{
    type = IndexGoodsTypeDiscover;
    [self load_next:YES];
}

- (void)bottom_c
{
    type = IndexGoodsTypeCreation;
    [self load_next:YES];
}

- (void)menu
{
    if ([m_view_bottom.ButtonA isHidden]) {
        m_view_bottom.ButtonA.hidden = NO;
        m_view_bottom.ButtonB.hidden = NO;
        m_view_bottom.ButtonC.hidden = NO;
        [m_view_bottom.MenuB setBackgroundImage:[UIImage imageNamed:@"PBUI_CommodityList_Circle_02"] forState:UIControlStateNormal];
    } else {
        m_view_bottom.ButtonA.hidden = YES;
        m_view_bottom.ButtonB.hidden = YES;
        m_view_bottom.ButtonC.hidden = YES;
        [m_view_bottom.MenuB setBackgroundImage:[UIImage imageNamed:@"PBUI_CommodityList_Circle"] forState:UIControlStateNormal];

    }
}

@end
