//
//  ImagePickerHandler.m
//  WBBIClient
//
//  Created by 黃韜 on 10/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import "ImagePickerHandler.h"
#import "AlertHandler.h"

@interface ImagePickerHandler () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    CGSize m_sImageSize;
    CGFloat m_fScale;
    NSNumber *m_iID;
}

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) NSMutableArray *observers;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) AlertHandler *currentAlertHandler;

@end

@implementation ImagePickerHandler

@synthesize viewController = m_pViewController;
@synthesize observers = m_pObservers;
@synthesize imagePicker = m_pImagePicker;
@synthesize currentAlertHandler = m_pCurrentAlertHandler;

#pragma mark - Object life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        m_pObservers = [NSMutableArray arrayWithCapacity:1.0];
    }
    return self;
}

#pragma mark - Public interface

#warning The parameter SCALE may cause some problem.
- (void)ShowImagePicker:(UIViewController *)viewController
             fromSource:(UIImagePickerControllerSourceType)sourceType
                 toSize:(CGSize)size
               andScale:(CGFloat)scale
{
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if (mediaTypes.count > 0 && [UIImagePickerController isSourceTypeAvailable:sourceType]) {
        m_pImagePicker = [[UIImagePickerController alloc] init];
        m_pImagePicker.delegate = self;
        m_pImagePicker.sourceType = sourceType;
        m_pImagePicker.allowsEditing = YES;
        [viewController presentViewController:m_pImagePicker
                                     animated:YES
                                   completion:nil];
    } else {
        m_pCurrentAlertHandler = [[AlertHandler alloc] init];
        [m_pCurrentAlertHandler ShowAlert:viewController title:NSLocalizedString(@"Not supported", @"") message:NSLocalizedString(@"Your device doesn't support your choice.", @"") dismissTitle:NSLocalizedString(@"OK", @"") dismissAction:^{
            
        }];
    }
    m_sImageSize = size;
    m_fScale = scale;
}

- (void)AddImageObserver:(id<ImagePickerDelegate>)delegate
{
    if (delegate != nil) {
        [m_pObservers addObject:delegate];
    }
}
- (void)AddImageObserver:(id<ImagePickerDelegate>)delegate
                  withID:(NSNumber *)id
{
    if (delegate != nil) {
        [m_pObservers addObject:delegate];
    }
    m_iID = id;
}

- (void)RemoveImageObserver:(id<ImagePickerDelegate>)delegate
{
    NSUInteger index = [m_pObservers indexOfObject:delegate];
    if (index != NSNotFound) {
        [m_pObservers removeObjectAtIndex:index];
    } else {
        NSLog(@"Removing not existed object");
    }
}

#pragma mark - Internal methods

- (UIImage *)shrinkImage:(UIImage *)image toSize:(CGSize)size andScale:(CGFloat)scale
{
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *new_image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return new_image;
}

- (void)notifyObservers:(UIImage *)image
{
    for (id<ImagePickerDelegate> delegate in m_pObservers) {
        if (m_iID) {
            [delegate ImagePicker:self image:image forID:m_iID];
        } else {
            [delegate ImagePicker:self image:image];
        }
    }
}

#pragma mark - Image picker controller delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *picked_image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (picked_image != nil) {
        UIImage *avatar_image = [self shrinkImage:picked_image
                                           toSize:m_sImageSize
                                         andScale:m_fScale];
        [m_pImagePicker dismissViewControllerAnimated:YES
                                              completion:nil];
        [self notifyObservers:avatar_image];
    } else {
        [[[AlertHandler alloc] init] ShowAlert:m_pViewController title:NSLocalizedString(@"Cannot pick any image.", @"") message:NSLocalizedString(@"Please check your device.", @"") dismissTitle:NSLocalizedString(@"OK", @"") dismissAction:^{
            [m_pImagePicker dismissViewControllerAnimated:YES
                                                  completion:nil];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [m_pImagePicker dismissViewControllerAnimated:YES
                                       completion:nil];
}

@end
