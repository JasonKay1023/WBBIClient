//
//  ImagePickerHandler.h
//  WBBIClient
//
//  Created by 黃韜 on 10/11/2015.
//  Copyright © 2015 WBB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImagePickerHandler;

@protocol ImagePickerDelegate <NSObject>

@optional
- (void)ImagePicker:(ImagePickerHandler *)picker
              image:(UIImage *)image;
- (void)ImagePicker:(ImagePickerHandler *)picker
              image:(UIImage *)image
              forID:(NSNumber *)id;

@end

@interface ImagePickerHandler : NSObject

- (void)ShowImagePicker:(UIViewController *)viewController
             fromSource:(UIImagePickerControllerSourceType)sourceType
                 toSize:(CGSize)size
               andScale:(CGFloat)scale;

- (void)AddImageObserver:(id<ImagePickerDelegate>)delegate;
- (void)AddImageObserver:(id<ImagePickerDelegate>)delegate
                  withID:(NSNumber *)id;
- (void)RemoveImageObserver:(id<ImagePickerDelegate>)delegate;

@end
