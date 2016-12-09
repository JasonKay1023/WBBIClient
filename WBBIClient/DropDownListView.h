//
//  DropDownListView.h
//  DropDownList
//
//  Created by Kevin on 16/2/19.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BrandNetworking.h"
#import "SceneNetworking.h"
#import "TypeNetworking.h"
#import "KVModel.h"

#define ITEM_BTN_TAG_BEGAIN 1000
#define ITEM_BTN_IV_TAG_BAGIN 3000

@protocol DropDownListDelegate <NSObject>

@end

@protocol DropDownListDataSource <NSObject>

- (NSInteger)numberOfItems;
- (NSInteger)numberOfRowsInItem:(NSInteger)item;
- (NSString *)titleInItem:(NSInteger)item index:(NSInteger)index;
- (NSInteger)defaultShowItem:(NSInteger)Item;

@end

@interface DropDownListView : UIView <UITableViewDataSource,UITableViewDelegate>{
    NSInteger currentExtendChooseItem; //当前展开的Item 默认为－1时，表示没有展开
}

@property (nonatomic, assign) id<DropDownListDelegate>dropDownListDelegate;
@property (nonatomic, assign) id<DropDownListDataSource>dropDownListDataSource;
@property (nonatomic, strong) UIView *m_superView;
@property (nonatomic, strong) UIView *m_bottomView;
@property (nonatomic, strong) UITableView *m_tableView;

@property (nonatomic, strong) NSArray *brandArray;
@property (nonatomic, strong) NSArray *sceneArray;
@property (nonatomic, strong) NSArray *typeArray;

- (id)initWithFrame:(CGRect)frame dataSource:(id)datasource delegate:(id)delegate;
//- (void)setTitle:(NSString *)title inItem:(NSInteger) item;
//
//- (BOOL)isShow;
- (void)hideExtendChooseItem;




@end
