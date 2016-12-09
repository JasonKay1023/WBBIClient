//
//  GoodsCreateVC.m
//  WBBIClient
//
//  Created by 黃韜 on 6/1/2016.
//  Copyright © 2016 WBB. All rights reserved.
//

#import "GoodsCreateVC.h"
#import "KVModel.h"
#import "GoodsNetworking.h"
#import "GoodsBrandSubmitVC.h"
#import "GoodsTypeSelectVC.h"
#import "GoodsSceneSelectVC.h"
#import "ImagePickerHandler.h"
#import "ActionSheetHandler.h"
#import "UIViewController+ProgressHUD.h"
#import "UIImage+Output.h"

@interface GoodsCreateVC () <GoodsBrandSelectDelegate, GoodsTypeSelectDelegate, GoodsSceneSelectDelegate, ImagePickerDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    NSMutableDictionary *m_pPhotoDictionary;
    NSString *m_strBrand;
    KVModel *m_objType;
    NSArray *m_arrScene;
    NSNumber *m_num_goodsid;
}

@property (weak, nonatomic) IBOutlet UIButton *BrandSelectB;
@property (weak, nonatomic) IBOutlet UITextField *TitleTF;
@property (strong, nonatomic) IBOutlet UITextField *DescriptionTF;
@property (weak, nonatomic) IBOutlet UITextView *DescriptionTV;
@property (weak, nonatomic) IBOutlet UITextField *MadeInTF;
@property (strong, nonatomic) IBOutlet UITextField *AccessoryTF;
@property (weak, nonatomic) IBOutlet UITextField *MadeFromTF;
@property (weak, nonatomic) IBOutlet UITextField *LengthTF;
@property (weak, nonatomic) IBOutlet UITextField *WidthTF;
@property (weak, nonatomic) IBOutlet UITextField *HeightTF;

@property (weak, nonatomic) IBOutlet UIButton *PhotoFrontB;
@property (weak, nonatomic) IBOutlet UIButton *PhotoOverlookB;
@property (weak, nonatomic) IBOutlet UIButton *PhotoLeftB;
@property (weak, nonatomic) IBOutlet UIButton *PhotoRightB;
@property (weak, nonatomic) IBOutlet UIButton *PhotoBackB;
@property (weak, nonatomic) IBOutlet UIButton *PhotoLookupB;
@property (weak, nonatomic) IBOutlet UIButton *PhotoDetailA;
@property (weak, nonatomic) IBOutlet UIButton *PhotoDetailB;
@property (weak, nonatomic) IBOutlet UIButton *PhotoDetailC;

@property (weak, nonatomic) IBOutlet UITextField *PriceTF;
@property (strong, nonatomic) ImagePickerHandler *iph;

- (IBAction)BrandSelectBPressed:(UIButton *)sender;

- (IBAction)PhotoFrontBPressed:(UIButton *)sender;
- (IBAction)PhotoOverlookBPressed:(UIButton *)sender;
- (IBAction)PhotoLeftBPressed:(UIButton *)sender;
- (IBAction)PhotoRightBPressed:(UIButton *)sender;
- (IBAction)PhotoBackBPressed:(UIButton *)sender;
- (IBAction)PhotoLookupBPressed:(UIButton *)sender;
- (IBAction)PhotoDetailAPressed:(UIButton *)sender;
- (IBAction)PhotoDetailBPressed:(UIButton *)sender;
- (IBAction)PhotoDetailCPressed:(UIButton *)sender;

@end

@implementation GoodsCreateVC

- (void)viewDidLoad {
    self.IsEditMode = YES;
    [super viewDidLoad];
    self.navigationController.navigationBar.clipsToBounds = NO;
    _DescriptionTV.delegate = self;
    _DescriptionTF.delegate = self;
    m_pPhotoDictionary = [NSMutableDictionary dictionaryWithCapacity:9];
    self.title = NSLocalizedString(@"商品申请上架", @"");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 2) {
        return 109.0;
    } else if (indexPath.section == 1 && indexPath.row == 4) {
        return self.view.bounds.size.width + 5.0;
    } else {
        return 44.0;
    }
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row == 1) {
        [self type_select_pressed];
    }
    if (indexPath.section == 2 && indexPath.row == 2) {
        [self scene_select_pressed];
    }
    if (indexPath.section == 3 && indexPath.row == 0) {
        [self save];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)BrandSelectBPressed:(UIButton *)sender
{
    GoodsBrandSubmitVC *vc = [[UIStoryboard storyboardWithName:@"Shop" bundle:nil]
                              instantiateViewControllerWithIdentifier:@"GoodsBrandSubmitVC"];
    vc.Delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)load_photo_picker:(NSNumber *)id
{
    [[ActionSheetHandler new] ShowActionSheet:self title:NSLocalizedString(@"商品图片上传", @"") message:NSLocalizedString(@"请上传商品具体图片", @"")  firstTitle:NSLocalizedString(@"从相机拍摄", @"")  firstAction:^{
        
        ImagePickerHandler *iph = [ImagePickerHandler new];
        [iph AddImageObserver:self withID:id];
        [iph ShowImagePicker:self
                  fromSource:UIImagePickerControllerSourceTypeCamera
                      toSize:CGSizeMake(500.0, 500.0)
                    andScale:0.0];
        
    } secondTitle:NSLocalizedString(@"从相簿获取", @"")  secondAction:^{
        
        _iph = [ImagePickerHandler new];
        [_iph AddImageObserver:self withID:id];
        [_iph ShowImagePicker:self
                   fromSource:UIImagePickerControllerSourceTypePhotoLibrary
                       toSize:CGSizeMake(500.0, 500.0)
                     andScale:0.0];
        
    } cancelTitle:NSLocalizedString(@"取消", @"")  cancelAction:^{
        
    }];
}

- (IBAction)PhotoFrontBPressed:(UIButton *)sender
{
    [self load_photo_picker:@0];
}

- (IBAction)PhotoOverlookBPressed:(UIButton *)sender
{
    [self load_photo_picker:@1];
}

- (IBAction)PhotoLeftBPressed:(UIButton *)sender
{
    [self load_photo_picker:@2];
}

- (IBAction)PhotoRightBPressed:(UIButton *)sender
{
    [self load_photo_picker:@3];
}

- (IBAction)PhotoBackBPressed:(UIButton *)sender
{
    [self load_photo_picker:@4];
}

- (IBAction)PhotoLookupBPressed:(UIButton *)sender
{
    [self load_photo_picker:@5];
}

- (IBAction)PhotoDetailAPressed:(UIButton *)sender
{
    [self load_photo_picker:@6];
}

- (IBAction)PhotoDetailBPressed:(UIButton *)sender
{
    [self load_photo_picker:@7];
}

- (IBAction)PhotoDetailCPressed:(UIButton *)sender
{
    [self load_photo_picker:@8];
}

- (void)ImagePicker:(ImagePickerHandler *)picker
              image:(UIImage *)image
              forID:(NSNumber *)id
{
    NSData *image_jpg = [image ToJPEG:1.0];
    switch ([id integerValue]) {
        case 0:
            [_PhotoFrontB setBackgroundImage:image
                                    forState:UIControlStateNormal];
            [m_pPhotoDictionary setValue:image_jpg
                                  forKey:@"PhotoFront"];
            break;
        case 1:
            [_PhotoOverlookB setBackgroundImage:image
                                    forState:UIControlStateNormal];
            [m_pPhotoDictionary setValue:image_jpg
                                  forKey:@"PhotoOverlook"];
            break;
        case 2:
            [_PhotoLeftB setBackgroundImage:image
                                    forState:UIControlStateNormal];
            [m_pPhotoDictionary setValue:image_jpg
                                  forKey:@"PhotoLeft"];
            break;
        case 3:
            [_PhotoRightB setBackgroundImage:image
                                    forState:UIControlStateNormal];
            [m_pPhotoDictionary setValue:image_jpg
                                  forKey:@"PhotoRight"];
            break;
        case 4:
            [_PhotoBackB setBackgroundImage:image
                                    forState:UIControlStateNormal];
            [m_pPhotoDictionary setValue:image_jpg
                                  forKey:@"PhotoBack"];
            break;
        case 5:
            [_PhotoLookupB setBackgroundImage:image
                                    forState:UIControlStateNormal];
            [m_pPhotoDictionary setValue:image_jpg
                                  forKey:@"PhotoLookup"];
            break;
        case 6:
            [_PhotoDetailA setBackgroundImage:image
                                    forState:UIControlStateNormal];
            [m_pPhotoDictionary setValue:image_jpg
                                  forKey:@"PhotoDetailA"];
            break;
        case 7:
            [_PhotoDetailB setBackgroundImage:image
                                    forState:UIControlStateNormal];
            [m_pPhotoDictionary setValue:image_jpg
                                  forKey:@"PhotoDetailB"];
            break;
        case 8:
            [_PhotoDetailC setBackgroundImage:image
                                    forState:UIControlStateNormal];
            [m_pPhotoDictionary setValue:image_jpg
                                  forKey:@"PhotoDetailC"];
            break;
    }
    
}

- (void)type_select_pressed
{
    GoodsTypeSelectVC *vc = [[UIStoryboard storyboardWithName:@"Shop" bundle:nil]
                             instantiateViewControllerWithIdentifier:@"GoodsTypeSelectVC"];
    vc.Delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scene_select_pressed
{
    GoodsSceneSelectVC *vc = [[UIStoryboard storyboardWithName:@"Shop" bundle:nil]
                              instantiateViewControllerWithIdentifier:@"GoodsSceneSelectVC"];
    vc.Delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)CallBackGoodsBrand:(NSString *)brand
{
    m_strBrand = brand;
    [_BrandSelectB setTitle:m_strBrand forState:UIControlStateNormal];
    _BrandSelectB.tintColor = [UIColor blackColor];
}

- (void)CallBackGoodsScene:(NSArray *)object
{
    m_arrScene = object;
}

- (void)CallBackGoodsType:(KVModel *)object
{
    m_objType = object;
}

- (void)save
{
    if ([self validate]) 
        [self do_save];

}

- (BOOL)validate
{
    if (m_strBrand.length == 0) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s message:NSLocalizedString(@"品牌未填写", @"") mode:ProgressHUDModeTypeText userInteractionEnable:YES];
        
        return NO;
    }
    if (_TitleTF.text.length == 0) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s message:NSLocalizedString(@"标题未填写", @"") mode:ProgressHUDModeTypeText userInteractionEnable:YES];
        return NO;
    }
    if (_DescriptionTV.text.length == 0) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s message:NSLocalizedString(@"描述未填写", @"") mode:ProgressHUDModeTypeText userInteractionEnable:YES];
        return NO;
    }
    if (_MadeInTF.text.length == 0) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s message:NSLocalizedString(@"产地未填写", @"") mode:ProgressHUDModeTypeText userInteractionEnable:YES];
        return NO;
    }
    if (_AccessoryTF.text.length == 0) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s message:NSLocalizedString(@"配饰未填写", @"") mode:ProgressHUDModeTypeText userInteractionEnable:YES];
        return NO;
    }
    if (_MadeFromTF.text.length == 0) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s message:NSLocalizedString(@"面料未填写", @"") mode:ProgressHUDModeTypeText userInteractionEnable:YES];
        return NO;
    }
    if (_LengthTF.text.length == 0) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s message:NSLocalizedString(@"长度未填写", @"") mode:ProgressHUDModeTypeText userInteractionEnable:YES];
        return NO;
    }
    if (_WidthTF.text.length == 0) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s message:NSLocalizedString(@"宽度未填写", @"") mode:ProgressHUDModeTypeText userInteractionEnable:YES];
        return NO;
    }
    if (_HeightTF.text.length == 0) {
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s message:NSLocalizedString(@"高度未填写", @"") mode:ProgressHUDModeTypeText userInteractionEnable:YES];
        return NO;
    }
    return YES;
}

- (void)do_save
{
    if (m_num_goodsid) {
        [self ShowProgressHUD:ProgressHUDDurationTypeStay
                      message:NSLocalizedString(@"图片上传ing", @"")
                         mode:ProgressHUDModeTypeIndeterminate
        userInteractionEnable:YES];
        [[GoodsNetworking new] UploadPhoto:m_pPhotoDictionary byGoodsID:m_num_goodsid success:^(GoodsModel *response) {
            
            [self HideProgressHUD];
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"图片上传成功", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
            [self jump_to_next];
            
        } fail:^(HttpResponseJson *response) {
            
            [self HideProgressHUD];
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"图片上传失败", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
            
        }];
        return;
    }
    NSMutableArray *scene_arr = [NSMutableArray array];
    for (KVModel *obj in m_arrScene) {
        [scene_arr addObject:[NSNumber numberWithInteger:obj.id]];
    }
    
    [self ShowProgressHUD:ProgressHUDDurationTypeStay
                  message:NSLocalizedString(@"正在创建商品", @"")
                     mode:ProgressHUDModeTypeIndeterminate
    userInteractionEnable:YES];
    
    [[GoodsNetworking new] CreateWithTitle:_TitleTF.text
                                     brand:m_strBrand
                              introduction:_DescriptionTV.text
                                    madeIn:_MadeInTF.text
                                  madeFrom:_MadeFromTF.text
                                 accessory:_AccessoryTF.text
                                    length:[NSNumber numberWithInteger:[_LengthTF.text integerValue]]
                                     width:[NSNumber numberWithInteger:[_WidthTF.text integerValue]]
                                    height:[NSNumber numberWithInteger:[_HeightTF.text integerValue]]
                                     price:[NSNumber numberWithInteger:[_PriceTF.text integerValue]]
#warning Temp Data Start
                            sellerLatitude:[NSNumber numberWithInteger:23.0]
                          sellerLongtitude:[NSNumber numberWithInteger:123.0]
                            sellerLocation:@"Guangzhou,Panyu,Fuhua"
#warning Temp Data End
                              bagAttribute:[NSNumber numberWithInteger:m_objType.id]
                            sceneAttribute:scene_arr success:^(GoodsModel *response) {
                                
        [self HideProgressHUD];
        
        [self ShowProgressHUD:ProgressHUDDurationTypeStay
                      message:NSLocalizedString(@"图片上传ing", @"")
                         mode:ProgressHUDModeTypeIndeterminate
        userInteractionEnable:YES];
        m_num_goodsid = [NSNumber numberWithInteger:response.id];
        [[GoodsNetworking new] UploadPhoto:m_pPhotoDictionary byGoodsID:[NSNumber numberWithInteger:response.id] success:^(GoodsModel *response) {
            
            [self HideProgressHUD];
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"图片上传成功", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
            [self jump_to_next];
            
        } fail:^(HttpResponseJson *response) {
            
            [self HideProgressHUD];
            [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                          message:NSLocalizedString(@"图片上传失败", @"")
                             mode:ProgressHUDModeTypeText
            userInteractionEnable:YES];
            
        }];
    
    } fail:^(HttpResponseJson *response) {
        
        [self HideProgressHUD];
        [self ShowProgressHUD:ProgressHUDDurationTypeSoon1_5s
                      message:NSLocalizedString(@"商品创建失败", @"")
                         mode:ProgressHUDModeTypeText
        userInteractionEnable:YES];
        
    }];
}

- (void)jump_to_next
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (![text isEqualToString:@""]) {
        _DescriptionTF.hidden = YES;
    }
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        _DescriptionTF.hidden = NO;
    }
 
    return YES;
}

@end
