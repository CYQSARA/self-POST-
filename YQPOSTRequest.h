//
//  YQPOSTRequest.h
//  self－一句话封装POST请求
//
//  Created by Cuiyongqin on 16/4/24.
//  Copyright © 2016年 Cuiyongqin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successBlock)(id data,NSURLResponse *response);
typedef void(^falseBlock)(NSError *error);

@interface YQPOSTRequest : NSObject
+ (instancetype)sharedPOSTRequest;
//MARK: - 多文件上传请求体封装
- (NSData *)getHTTPBodyWithFileKey:(NSString *)fileKey andFileDict:(NSDictionary *)dict andNormalParmaret:(NSDictionary *)normalDict;

//MARK: - 一句话多文件上传
- (void)sendFilesWithURLString:(NSString *)URLSting FileKey:(NSString *)fileKey andFileDict:(NSDictionary *)dict andNormalParmaret:(NSDictionary *)normalDict;

//MARK:- 一句话封装POST请求
- (void)POSTRequestWithURLString:(NSString *)urlString andDict:(NSDictionary *)pramarts andSuccessBlock:(successBlock)successblock andFalseBlock:(falseBlock)falseblock ;

//MARK:- 单文件上传请求体封装
- (NSData *)getHTTPBodyWthKeyName:(NSString *)key  andFileName:(NSString *)fileName andFilePath:(NSString *)filePath;

//MARK: - 一句话单文件上传
- (void)sendFileWithURLString:(NSString *)URLSting KeyName:(NSString *)key  andFileName:(NSString *)fileName andFilePath:(NSString *)filePath;

@end
