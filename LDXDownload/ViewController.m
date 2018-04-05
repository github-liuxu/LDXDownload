//
//  ViewController.m
//  LDXDownload
//
//  Created by 刘东旭 on 2018/4/1.
//  Copyright © 2018年 刘东旭. All rights reserved.
//

#import "ViewController.h"
#import "LDXDownload.h"

@interface ViewController () {
    LDXDownload *download;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    download = [[LDXDownload alloc] init];
    NSString *downloadURLString = @"http://img07.tooopen.com/images/20170316/tooopen_sy_201956178977.jpg";
    [download downLoadWithURLString:downloadURLString parameters:nil progerss:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%lld",downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
    } success:^(NSURL *path) {
        NSLog(@"%@",path);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
