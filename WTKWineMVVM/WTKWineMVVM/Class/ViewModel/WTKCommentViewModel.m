//
//  WTKCommentViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 2016/11/11.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKCommentViewModel.h"
#import "WTKCommentVC.h"

@interface WTKCommentViewModel ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation WTKCommentViewModel
- (instancetype)initWithService:(id<WTKViewModelServices>)service params:(NSDictionary *)params
{
    if (self = [super initWithService:service params:params])
    {
        [self initViewModel];
    }
    return self;
}

- (void)initViewModel
{
    @weakify(self);
    self.addPicCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            [self addPickture:UIImagePickerControllerSourceTypeCamera];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            [self addPickture:UIImagePickerControllerSourceTypePhotoLibrary];
        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [action1 setValue:WTKCOLOR(30, 30, 30, 1) forKey:@"titleTextColor"];
        [action2 setValue:WTKCOLOR(30, 30, 30, 1) forKey:@"titleTextColor"];
        [action3 setValue:WTKCOLOR(80, 80, 80, 1) forKey:@"titleTextColor"];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择图片类型" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:action1];
        [alert addAction:action2];
        [alert addAction:action3];
        [self.vc presentViewController:alert animated:YES completion:nil];
        return [RACSignal empty];
    }];
    
    self.changeImgSubject = [RACSubject subject];
    
    self.commitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSString *comment = input[@"comment"];
        if (comment.length > 0)
        {
            SHOW_SVP(@"提交中");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                SHOW_SUCCESS(@"评论成功");
                [self.naviImpl popViewControllerWithAnimation:YES];
                DISMISS_SVP(1.3);
            });
        }
        else
        {
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入您的评论" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:action1];
            [self.vc presentViewController:alert animated:YES completion:nil];
        }
        return [RACSignal empty];
    }];
    
}
- (void)addPickture:(UIImagePickerControllerSourceType)sourcyType
{
    if (![UIImagePickerController isSourceTypeAvailable:sourcyType])
    {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourcyType;
    [self.vc presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self.vc dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *newImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    newImage = [UIImage fixOrientation:newImage];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:newImage forState:UIControlStateNormal];
    [self.vc.imgArray addObject:btn];
    [self.changeImgSubject sendNext:@1];
//    CURRENT_USER.headImage = newImage;
//    [WTKDataManager saveUserData];
//    [self.vc.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}



@end
