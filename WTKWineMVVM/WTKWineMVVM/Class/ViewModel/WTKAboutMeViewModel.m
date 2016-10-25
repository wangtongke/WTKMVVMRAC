//
//  WTKAboutMeViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/20.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKAboutMeViewModel.h"
#import "WTKAddressManagerViewModel.h"
@interface WTKAboutMeViewModel ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

///昵称
@property(nonatomic,strong)UITextField *textField;

@end

@implementation WTKAboutMeViewModel

- (instancetype)initWithService:(id<WTKViewModelServices>)service params:(NSDictionary *)params
{
    self = [super initWithService:service params:params];
    if (self)
    {
        [self initViewModel];
    }
    return self;
}

- (void)initViewModel
{
    @weakify(self);
    self.cellClickCommand   = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"%@",input);
        NSIndexPath *indexPath = input;
        if (indexPath.section == 0)
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        @strongify(self);
                        [self updateHeader:UIImagePickerControllerSourceTypeCamera];
                    }];
                    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        @strongify(self);
                        [self updateHeader:UIImagePickerControllerSourceTypePhotoLibrary];
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
                }
                    break;
                case 1:
                {
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        @strongify(self);
                        CURRENT_USER.nickName = self.textField.text;
                        [self.vc.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                        [WTKDataManager saveUserData];
                    }];
                    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [action1 setValue:WTKCOLOR(122, 230, 90, 1) forKey:@"titleTextColor"];
                    [action2 setValue:WTKCOLOR(150, 150, 150, 1) forKey:@"titleTextColor"];
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请输入昵称" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:action2];
                    [alert addAction:action1];
                    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        self.textField = textField;
                        self.textField.placeholder = @"请输入昵称";
                        self.textField.text = CURRENT_USER.nickName;
                    }];
                    [self.vc presentViewController:alert animated:YES completion:nil];
                }
                    break;
                case 2:
                {
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        @strongify(self);
                        CURRENT_USER.sex = YES;
                        [self.vc.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                    }];
                    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        CURRENT_USER.sex = NO;
                        [self.vc.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                    }];
                    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [action1 setValue:WTKCOLOR(80, 80, 80, 1) forKey:@"titleTextColor"];
                    [action2 setValue:WTKCOLOR(80, 80, 80, 1) forKey:@"titleTextColor"];
                    [action3 setValue:THEME_COLOR forKey:@"titleTextColor"];
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择性别" preferredStyle:UIAlertControllerStyleActionSheet];
                    [alert addAction:action1];
                    [alert addAction:action2];
                    [alert addAction:action3];
                    [self.vc presentViewController:alert animated:YES completion:nil];
                }
                    break;
                case 3:
                {
                        
                        UIDatePicker *datePicker    = [[UIDatePicker alloc]init];
                        datePicker.datePickerMode   = UIDatePickerModeDate;
                        NSDateFormatter *formatter  = [[NSDateFormatter alloc]init];
                        [formatter setDateFormat:@"yy-MM-dd"];
                        datePicker.minimumDate      = [formatter dateFromString:@"1916-01-01"];
                        datePicker.maximumDate      = [NSDate date];
                        UIAlertController *alert    = [UIAlertController alertControllerWithTitle:@"请选择日期" message:@"\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
                        [alert.view addSubview:datePicker];
                        [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(alert.view).offset(20);
                            make.left.equalTo(alert.view).offset(10);
                            make.right.equalTo(alert.view).offset(-10);
                            make.height.equalTo(datePicker.mas_width);
                        }];
                        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                            @strongify(self);
                            [self updateBirthDay:datePicker.date];
                        }];
                        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        [action1 setValue:WTKCOLOR(122, 230, 90, 1) forKey:@"titleTextColor"];
                        [action2 setValue:WTKCOLOR(150, 150, 150, 1) forKey:@"titleTextColor"];
                        [alert addAction:action2];
                        [alert addAction:action1];
                        [self.vc presentViewController:alert animated:YES completion:nil];

                }
                    break;
                default:
                    break;
            }
        }
        else if (indexPath.section == 1)
        {
            NSLog(@"address");
            WTKAddressManagerViewModel *viewModel = [[WTKAddressManagerViewModel alloc]initWithService:self.services params:@{@"title":@"地址管理"}];
            self.naviImpl.className = @"WTKAddressManagerVC";
            [self.naviImpl pushViewModel:viewModel animated:YES];
        }
        return [RACSignal empty];
    }];
}

- (void)updateBirthDay:(NSDate *)date
{
    NSDateFormatter *formatter  = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *time              = [formatter stringFromDate:date];
    CURRENT_USER.birthDay       = time;
    [self.vc.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [WTKDataManager saveUserData];
    
}

- (void)updateHeader:(UIImagePickerControllerSourceType)sourcyType
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
    CURRENT_USER.headImage = newImage;
    [WTKDataManager saveUserData];
    [self.vc.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
}

@end
