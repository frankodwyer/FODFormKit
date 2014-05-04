//
//  FODInlinePickerCell.m
//  FormKitDemo
//
//  Copyright 2014 Thimo Bess, arconsis IT-Solutions GmbH
//

#import "FODTextInputCell.h"
#import "FODSwitchCell.h"
#import "FODImagePickerCell.h"


@interface FODImagePickerCell () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIImageView *previewImage;

@property (nonatomic, strong) UINavigationController *navController;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@end


@implementation FODImagePickerCell

- (void)configureCellForRow:(FODFormRow *)row withDelegate:(id)delegate
{
    [super configureCellForRow:row withDelegate:delegate];
    [self.delegate adjustHeight:100.0 forRowAtIndexPath:self.row.indexPath];


    self.title.text = row.title;
    self.previewImage.image = [UIImage imageWithData:(NSData*)row.workingValue];
}

- (void)cellAction:(UINavigationController *)navController
{
    self.navController = navController;

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Foto auswählen"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Abbrechen"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Kamera", @"Fotos", nil];

        [actionSheet showInView:navController.view];
    } else {
        [self showImagePickerWithDataSource:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}


#pragma mark - UIImagePickerControllerDelegate -
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.previewImage.image = chosenImage;


    if ([self.delegate respondsToSelector:@selector(imageSelected:withUserInfo:)]) {
        [self.delegate imageSelected:chosenImage withUserInfo:self.row ];
    }


    [picker dismissViewControllerAnimated:YES completion:NULL];
}



#pragma mark - UIActionSheetDelegate -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 || buttonIndex == 1) {
        if (buttonIndex == 0) {
            [self showImagePickerWithDataSource:UIImagePickerControllerSourceTypeCamera];
        } else {
            [self showImagePickerWithDataSource:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    }
}


#pragma mark - Helper Methods -
- (void)showImagePickerWithDataSource:(UIImagePickerControllerSourceType)sourceType
{
    self.imagePickerController.sourceType = sourceType;
    [self.navController presentViewController:self.imagePickerController animated:YES completion:nil];
}


#pragma mark - Setter / Getter -
- (UIImagePickerController *)imagePickerController
{
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
    }

    return _imagePickerController;
}

@end
