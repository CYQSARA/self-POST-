//
//  YQPOSTRequest.m
//  self－一句话封装POST请求
//
//  Created by Cuiyongqin on 16/4/24.
//  Copyright © 2016年 Cuiyongqin. All rights reserved.
//

#import "YQPOSTRequest.h"
#define kboundary @"boundary"

@implementation YQPOSTRequest
static id _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedPOSTRequest {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}

- (id)copyWithZone :(NSZone *)zone {
    return _instance;
}

//MARK:- 一句话封装POST请求
- (void)POSTRequestWithURLString:(NSString *)urlString andDict:(NSDictionary *)pramarts andSuccessBlock:(successBlock)successblock andFalseBlock:(falseBlock)falseblock {
    
    //MARK:- 创建请求
    NSURL *url = [NSURL URLWithString:urlString];
#warning - POST请求要创建可变请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15];
    
    //MARK:- 设置请求体、请求方法等参数
    request.HTTPMethod = @"POST";
    NSMutableString *strM = [NSMutableString string];
    [pramarts enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *pramKey = key;
        NSString *pramValue = obj;
        [strM appendFormat:@"%@=%@&",pramKey,pramValue];
    }];
    NSString *pramart = [strM substringToIndex:strM.length-1];
    request.HTTPBody = [pramart dataUsingEncoding:NSUTF8StringEncoding];
    
    //MARK:- 发送请求
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data&&!error) {
            if (successblock!=nil) {
               
                id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                if (!obj) {
                    obj = data;
                }
                
                successblock( obj,response);
            }
        }else{
            if (falseblock!=nil) {
                falseblock(error);
            }
        }
        
        
    }]resume];
    
}

//MARK: - 一句话单文件上传
- (void)sendFileWithURLString:(NSString *)URLSting KeyName:(NSString *)key  andFileName:(NSString *)fileName andFilePath:(NSString *)filePath {
  
    NSURL *url = [NSURL URLWithString:URLSting];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *value = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",kboundary];
    [request setValue:value forHTTPHeaderField:@"Content-Type"];
    
       request.HTTPBody = [[YQPOSTRequest sharedPOSTRequest] getHTTPBodyWthKeyName:key andFileName:fileName andFilePath:filePath];
    
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data&&!error) {
            NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]);
        }
        
    }]resume];
    
}

//MARK:- 单文件上传请求体封装
- (NSData *)getHTTPBodyWthKeyName:(NSString *)key  andFileName:(NSString *)fileName andFilePath:(NSString *)filePath{
    
    NSMutableData *data = [NSMutableData data];
    
    //MARK:- 上边界
    NSMutableString *bodyStrM = [NSMutableString stringWithFormat:@"--%@\r\n",kboundary];
    [bodyStrM appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n",key,fileName];
    NSURLResponse *type =[self getResponseWithFileString:filePath];
    [bodyStrM appendFormat:@"Content-Type: %@\r\n\r\n",type.MIMEType];
    [data appendData:[bodyStrM dataUsingEncoding:NSUTF8StringEncoding]];
    
    //MARK:- 文件内容
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    [data appendData:fileData];
    
    //MARK:- 下边界
    NSMutableString *footerStrM = [NSMutableString stringWithFormat:@"\r\n--%@--",kboundary];
    [data appendData:[footerStrM dataUsingEncoding:NSUTF8StringEncoding]];
    
    return data;
    
}

//MARK: - 一句话多文件上传
- (void)sendFilesWithURLString:(NSString *)URLSting FileKey:(NSString *)fileKey andFileDict:(NSDictionary *)dict andNormalParmaret:(NSDictionary *)normalDict {
    
    NSURL *url = [NSURL URLWithString:URLSting];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *value = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",kboundary];
    [request setValue:value forHTTPHeaderField:@"Content-Type"];
    
    request.HTTPBody = [self getHTTPBodyWithFileKey:fileKey andFileDict:dict andNormalParmaret:normalDict];
    
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data&&!error) {
            NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]);
        }
        
    }]resume];
    

}

//MARK: - 多文件上传请求体封装
- (NSData *)getHTTPBodyWithFileKey:(NSString *)fileKey andFileDict:(NSDictionary *)dict andNormalParmaret:(NSDictionary *)normalDict {
    
    NSMutableData *data = [NSMutableData data];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *fileName = key;
        NSString *filePath = obj;
        
        NSMutableString *strMBody = [NSMutableString stringWithFormat:@"\r\n--%@\r\n",kboundary ];
      [ strMBody appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n",fileKey,fileName];
        NSURLResponse *response = [[YQPOSTRequest sharedPOSTRequest] getResponseWithFileString:filePath];
        [strMBody appendFormat:@"Content-Type: %@\r\n\r\n",response.MIMEType];
        [data appendData:[strMBody dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        [data appendData:fileData];
        
    }];
    
    [normalDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *paramaterKey = key;
        NSString *paramaterValue = obj;
        NSMutableString *strMBody = [NSMutableString stringWithFormat:@"\r\n--%@\r\n",kboundary];
        [ strMBody appendFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n",paramaterKey];
        [data appendData:[strMBody dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSData *normalData = [paramaterValue dataUsingEncoding:NSUTF8StringEncoding];
        [data appendData:normalData];
        
    }];
    
    NSMutableString *footerStrM = [NSMutableString stringWithFormat:@"\r\n--%@--",kboundary];
    [data appendData:[footerStrM dataUsingEncoding:NSUTF8StringEncoding]];
    
    return data;
}

//MARK:- 获得response
- (NSURLResponse *)getResponseWithFileString :(NSString *)FileString {
    
    NSString *fileURL = [NSString stringWithFormat:@"file://%@",FileString];
    NSURL *url = [NSURL URLWithString:fileURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];
    return response;
}



@end












