//
//  KGImagePickerController.h
//  TestPhotoBrowser
//
//  Created by 邓波 on 2019/5/5.
//  Copyright © 2019 邓波. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGImagePickerController;

@protocol KGImagePickerControllerDelegate <NSObject>

- (void)imagePickerController:(KGImagePickerController *)picker finishedPickingImage:(UIImage *)image;
- (void)imagePickerControllerCancelled:(KGImagePickerController *)picker;

@end

@interface KGImagePickerController : UIViewController

@property (nonatomic, weak) id<KGImagePickerControllerDelegate> delegate;

@end
