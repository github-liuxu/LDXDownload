//
//  LDXDownload.m
//  LDXDownload
//
//  Created by 刘东旭 on 2018/4/1.
//  Copyright © 2018年 刘东旭. All rights reserved.
//

#import "LDXDownload.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>

@interface LDXDownload ()

//@property (nonatomic, strong) NSMutableArray *taskArray;
@property (nonatomic, strong) AFURLSessionManager *manager;
@property (nonatomic, strong) NSFileManager *fm;

@end

@implementation LDXDownload

- (instancetype)init {
    if (self = [super init]) {
        self.isNeedCache = YES;
//        self.taskArray = [NSMutableArray array];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        self.downloadDir = [document stringByAppendingString:@"/download"];
        self.fm = [NSFileManager defaultManager];
        if (![self.fm fileExistsAtPath:self.downloadDir]) {
            [self.fm createDirectoryAtPath:self.downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return self;
}

- (void)downLoadWithURLString:(NSString *)URLString parameters:(id)parameters progerss:(void (^)(NSProgress * _Nonnull downloadProgress))progress success:(void (^)(NSURL* path))success failure:(void (^)(NSError *error))failure {
    NSString *extensin = [URLString pathExtension];
    NSString *md5Name = [self md5:URLString];
    NSString *fileName = [md5Name stringByAppendingPathExtension:extensin];
    NSString *fullPath = [self.downloadDir stringByAppendingPathComponent:fileName];
    
    //判断是否需要从缓存查找
    if (self.isNeedCache) {
        
        //如果文件存在直接返回
        if ([self fileExistsWithName:fileName]) {
            success([NSURL fileURLWithPath:fullPath]);
            return;
        }
    }

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    NSURLSessionDownloadTask *downLoadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            failure(error);
        } else {
            success(filePath);
        }
    }];
    [downLoadTask resume];
}

- (BOOL)fileExistsWithName:(NSString *)fileName {
    NSString *filePath = [self.downloadDir stringByAppendingPathComponent:fileName];
    return [self.fm fileExistsAtPath:filePath];
}

/**
 对字符串MD5加密

 @param string 需要转为MD5的字符串
 @return MD5字符串
 */
- (NSString *)md5:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
