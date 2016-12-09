//
//  DropDownListView.m
//  DropDownList
//
//  Created by Kevin on 16/2/19.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import "DropDownListView.h"


@implementation DropDownListView



- (id)initWithFrame:(CGRect)frame dataSource:(id)datasource delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        currentExtendChooseItem = -1;
        self.dropDownListDataSource = datasource;
        self.dropDownListDelegate = delegate;
        
        NSInteger itemNum = 0;
        if ([self.dropDownListDataSource respondsToSelector:@selector(numberOfItems)]) {//用来判断是否有以某个名字命名的方法(被封装在一个selector的对象里传递)
            itemNum = [self.dropDownListDataSource numberOfItems];
        }
        if (itemNum == 0) {
            self = nil;
        }
        
        //品牌接口
        [[BrandNetworking new]GetList:^(NSArray *response) {
            _brandArray = response;
            [self.m_tableView reloadData];
        } fail:^(HttpResponseJson *response) {
            
        }];
        
        //场景接口
        [[SceneNetworking new]GetList:^(NSArray *response) {
            _sceneArray = response;
            [self.m_tableView reloadData];
        } fail:^(HttpResponseJson *response) {
            
        }];
        
        //类型接口
        [[TypeNetworking new]GetList:^(NSArray *response) {
            _typeArray = response;
            [self.m_tableView reloadData];
        } fail:^(HttpResponseJson *response) {
            
        }];
        
        
        //初始化默认显示view
        CGFloat itemWidth = (1.0*(frame.size.width) / itemNum);
        for (int i = 0; i < itemNum; i++) {
            UIButton *itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, 37)];
            itemBtn.tag = ITEM_BTN_TAG_BEGAIN + i;;
            [itemBtn addTarget:self action:@selector(itemBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            NSString *itemBtnTitle;
            switch (i) {
                case 0:
                    itemBtnTitle = NSLocalizedString(@"品牌", nil);
                    break;
                case 1:
                    itemBtnTitle = NSLocalizedString(@"适宜场合", nil);
                    break;
                case 2:
                    itemBtnTitle = NSLocalizedString(@"类型", nil);
                    break;
                default:
                break;
            }
            [itemBtn setTitle:itemBtnTitle forState:UIControlStateNormal];
            [itemBtn setTitleColor:[UIColor colorWithRed:230.0/255.0 green:80.0/255.0 blue:130.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            itemBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
            [self addSubview:itemBtn];
            
            UIImageView *itemBtnIV = [[UIImageView alloc]initWithFrame:CGRectMake(itemWidth * (i + 1) - 30, (self.frame.size.height - 8) / 2, 8 , 8)];
            [itemBtnIV setImage:[UIImage imageNamed:@"down_dark"]];
            [itemBtnIV setContentMode:UIViewContentModeScaleToFill];
            itemBtnIV.tag = ITEM_BTN_IV_TAG_BAGIN + i ;
            [self addSubview:itemBtnIV];
            
            }
        }
    return self;
}
//菜单Button动作
- (void)itemBtnPressed:(UIButton *)btn{
    NSInteger item = btn.tag - ITEM_BTN_TAG_BEGAIN;//相当于i
    //图片旋转
    UIImageView *currentItemBtnIV = (UIImageView *)[self viewWithTag:ITEM_BTN_IV_TAG_BAGIN + currentExtendChooseItem];
    [UIView animateWithDuration:0.3 animations:^{
        currentItemBtnIV.transform = CGAffineTransformRotate(currentItemBtnIV.transform, M_PI);
    }];
    //判断是否展开
    if (currentExtendChooseItem == item) {
        [self hideExtendChooseItem];
    }else{
        currentExtendChooseItem = item;
        currentItemBtnIV = (UIImageView *)[self viewWithTag:(ITEM_BTN_IV_TAG_BAGIN +currentExtendChooseItem)];
        [UIView animateWithDuration:0.3 animations:^{
            currentItemBtnIV.transform = CGAffineTransformRotate(currentItemBtnIV.transform, M_PI);
        }];
        
        [self showChooseListViewInItem:currentExtendChooseItem choosedIndex:[self.dropDownListDataSource defaultShowItem:currentExtendChooseItem]];
    }
}

//- (void)setTitle:(NSString *)title inItem:(NSInteger) item
//{
//    UIButton *btn = (id)[self viewWithTag:ITEM_BTN_TAG_BEGAIN + item];
//    [btn setTitle:title forState:UIControlStateNormal];
//}
//
//- (BOOL)isShow
//{
//    if (currentExtendChooseItem == -1) {
//        return NO;
//    }
//    return YES;
//}

- (void)hideExtendChooseItem
{
    if (currentExtendChooseItem != -1) {
        currentExtendChooseItem = -1;
        CGRect rect = self.m_tableView.frame;
        rect.size.height = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.m_bottomView.alpha = 1.0;
            self.m_tableView.alpha = 1.0;
            
            self.m_bottomView.alpha = 0.2;
            self.m_tableView.alpha = 0.2;
            
            self.m_tableView.frame = rect;
        } completion:^(BOOL finished) {
            [self.m_tableView removeFromSuperview];
            [self.m_bottomView removeFromSuperview];
        }];
    }
}

- (void)showChooseListViewInItem:(NSInteger)item choosedIndex:(NSInteger)index
{
    if (!self.m_tableView) {
        self.m_bottomView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.m_superView.frame.size.height - self.frame.origin.y - self.frame.size.height)];
        self.m_bottomView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1];
        UITapGestureRecognizer *backgroundTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundTap:)];
        [self.m_bottomView addGestureRecognizer:backgroundTap];
        
        self.m_tableView = [[UITableView alloc]initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 240)style:UITableViewStylePlain];
        self.m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.m_tableView.showsVerticalScrollIndicator = NO;

        self.m_tableView.delegate = self;
        self.m_tableView.dataSource = self;
    }
    
    //修改tableView的frame
    int itemWidth = ((self.frame.size.width)/[self.dropDownListDataSource numberOfItems]);
    CGRect rect = self.m_tableView.frame;
    rect.origin.x = itemWidth *item;
    rect.size.width = itemWidth;
    rect.size.height = 0;
    self.m_tableView.frame = rect;
    [self.m_superView addSubview:self.m_bottomView];
    [self.m_superView addSubview:self.m_tableView];
    
    //动画设置位置
    rect.size.height = 240;
    [UIView animateWithDuration:0.3 animations:^{
        self.m_bottomView.alpha = 0.2;
        self.m_tableView.alpha = 0.2;
        
        self.m_bottomView.alpha = 1.0;
        self.m_tableView.alpha = 1.0;
        
        self.m_tableView.frame = rect;
    }];
    [self.m_tableView reloadData];
}

- (void)backgroundTap:(UITapGestureRecognizer *)tap{
    UIImageView *currentItemBtnIV = (UIImageView *)[self viewWithTag:(ITEM_BTN_IV_TAG_BAGIN + currentExtendChooseItem)];
    [UIView animateWithDuration:0.3 animations:^{
        currentItemBtnIV.transform = CGAffineTransformRotate(currentItemBtnIV.transform, M_PI);
    }];
    [self hideExtendChooseItem];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dropDownListDataSource respondsToSelector:@selector(titleInItem:index:)]) {
        NSString *chooseCellTitle = [self.dropDownListDataSource titleInItem:currentExtendChooseItem index:indexPath.row];
        UIButton *currentItemBtn = (UIButton *)[self viewWithTag:ITEM_BTN_TAG_BEGAIN + currentExtendChooseItem];
        [currentItemBtn setTitle:chooseCellTitle forState:UIControlStateNormal];
        UIImageView *currentItemBtnIV = (UIImageView *)[self viewWithTag:(ITEM_BTN_IV_TAG_BAGIN + currentExtendChooseItem)];
        [UIView animateWithDuration:0.3 animations:^{
            currentItemBtnIV.transform = CGAffineTransformRotate(currentItemBtnIV.transform, M_PI);
        }];
        [self hideExtendChooseItem];
    }
}

//一节
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
 
//每节有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dropDownListDataSource numberOfRowsInItem:currentExtendChooseItem];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = [self.dropDownListDataSource titleInItem:currentExtendChooseItem index:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor colorWithRed:230.0/255.0 green:80.0/255.0 blue:130.0/255.0 alpha:1.0];
    return cell;
}

@end
