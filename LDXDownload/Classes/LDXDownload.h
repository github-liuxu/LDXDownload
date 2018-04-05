//
//  LDXDownload.h
//  LDXDownload
//
//  Created by 刘东旭 on 2018/4/1.
//  Copyright © 2018年 刘东旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDXDownload : NSObject

/**
 下载目录默认为Documents/download目录
 */
@property (nonatomic, strong) NSString *downloadDir;

/**
 是否需要缓存 默认YES
 */
@property (nonatomic, assign) BOOL isNeedCache;

- (void)downLoadWithURLString:(NSString *)URLString parameters:(id)parameters progerss:(void (^)(NSProgress * _Nonnull downloadProgress))progress success:(void (^)(NSURL* path))success failure:(void (^)(NSError *error))failure;

@end
