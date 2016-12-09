//
//  ConversationListController.h
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/25.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "FlipContainerView.h"

@interface ConversationListController : EaseConversationListViewController

@property (weak, nonatomic) id<FlipContainerDelegate> flip_container_delegate;

- (void)refreshDataSource;

- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;

@end
