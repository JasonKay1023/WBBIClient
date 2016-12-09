//
//  GoodsIntroductionTVC.m
//  WBBIClient
//
//  Created by 黃韜 on 7/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "GoodsIntroductionTVC.h"
#import <UIImageView+WebCache.h>
#import "NSString+URL.h"
#import "UIView+Style.h"

@interface GoodsIntroductionTVC ()

@property (strong, nonatomic) IBOutlet UIImageView *AvatarIV;
@property (strong, nonatomic) IBOutlet UILabel *NameL;
@property (strong, nonatomic) IBOutlet UIView *StarV;
@property (strong, nonatomic) IBOutlet UITextView *IntroductionTV;
@property (strong, nonatomic) IBOutlet UITextView *UserSignatureTV;

@end

@implementation GoodsIntroductionTVC

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)LoadData:(GoodsModel *)goods_instance
{
    NSURL *url = [[goods_instance.Seller.Avatar AppendServerURL] ToURL];
    [_AvatarIV sd_setImageWithURL:url];
    [_AvatarIV SetCornerRadius:_AvatarIV.frame.size.width / 2.0];
    _NameL.text = goods_instance.Seller.NickName;
    _UserSignatureTV.text = goods_instance.Seller.Signature;
    _IntroductionTV.text = goods_instance.Introduction;
}

@end
