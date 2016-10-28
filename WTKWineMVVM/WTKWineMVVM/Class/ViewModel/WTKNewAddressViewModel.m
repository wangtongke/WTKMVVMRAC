//
//  WTKNewAddressViewModel.m
//  WTKWineMVVM
//
//  Created by 王同科 on 16/10/26.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import "WTKNewAddressViewModel.h"
#import "WTKMapViewModel.h"
#import "WTKNewAddressVC.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@interface WTKNewAddressViewModel ()<CNContactPickerDelegate>

@end

@implementation WTKNewAddressViewModel


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
    [[WTKMapManager manager].locationSubject subscribeNext:^(id x) {
        @strongify(self);
        NSDictionary *dic = x[@"address"];
        NSString *address = [NSString stringWithFormat:@"%@ %@ %@ %@",dic[@"admin"],dic[@"city"],dic[@"county"],dic[@"detail"]];
        self.addressString = address;
    }];
    self.saveCommand    = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSString *name  = input[@"name"];
        NSNumber *sex   = input[@"sex"];
        NSString *phone = input[@"phone"];
        NSString *addre = input[@"address"];
        NSString *detail= input[@"detailAddress"];
        if (name.length <= 0)
        {
            SHOW_ERROE(@"请输入姓名");
            DISMISS_SVP(1.2);
        }
        else if(phone.length <= 0)
        {
            SHOW_ERROE(@"请输入手机号");
            DISMISS_SVP(1.2);
        }
        else if (addre.length <= 0)
        {
            SHOW_ERROE(@"请选择地址");
            DISMISS_SVP(1.2);
        }
        else
        {
            NSLog(@"保存地址");
            if (self.address)
            {
                [self.address setValuesForKeysWithDictionary:@{@"w_name":name,
                                                          @"w_address":addre,
                                                          @"w_phone":phone,
                                                          @"w_sex":sex,
                                                          @"w_detailAddress":detail}];
            }
            else
            {
                WTKAddress *address = [[WTKAddress alloc]init];
                [address setValuesForKeysWithDictionary:@{@"w_name":name,
                                                          @"w_address":addre,
                                                          @"w_phone":phone,
                                                          @"w_sex":sex,
                                                          @"w_detailAddress":detail}];
                [CURRENT_USER.address addObject:address];
            }
            [self.naviImpl popViewControllerWithAnimation:YES];
        }
        return [RACSignal empty];
    }];
    
    
    self.addressCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        WTKMapViewModel *viewModel = [[WTKMapViewModel alloc]initWithService:self.services params:@{@"title":@"address"}];
        self.naviImpl.className = @"WTKMapVC";
        [viewModel.addressSubject subscribeNext:^(id x) {
            @strongify(self);
            self.addressString = [NSString stringWithFormat:@"%@ %@ %@",x[@"city"],x[@"name"],x[@"address"]];
        }];
        [self.naviImpl pushViewModel:viewModel animated:YES];

        return [RACSignal empty];
    }];
    
    self.phoneBookCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        CNContactPickerViewController *vc = [[CNContactPickerViewController alloc]init];
        vc.delegate = self;
        [self.vc presentViewController:vc animated:YES completion:nil];
        return [RACSignal empty];
    }];
}

- (void)setAddress:(WTKAddress *)address
{
    _address = address;
    self.deleteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [CURRENT_USER.address removeObject:self.address];
        [self.naviImpl popViewControllerWithAnimation:YES];
        return [RACSignal empty];
    }];
}

#pragma CNContactPickerDelegate

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    NSLog(@"---%@",contactProperty);
    if ([contactProperty.key isEqualToString:@"phoneNumbers"])
    {
//        选中的为手机号
        CNPhoneNumber *number   = contactProperty.value;
        NSString *string        = number.stringValue;
        self.phoneNum           = [string stringByReplacingOccurrencesOfString:@"-" withString:@" "];
        NSString *name          =  contactProperty.contact.givenName;
        self.phoneName          = name;
    }
}

@end
