//
//  HGBDESEncryption.m
//  测试
//
//  Created by huangguangbao on 2017/9/14.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBDESEncryption.h"
#import <CommonCrypto/CommonCryptor.h>
#import "HGBBase64.h"

static NSString *const kInitVector = @"00000000";


#ifdef HGBLogFlag
#define HGBLog(FORMAT,...) fprintf(stderr,"**********HGBErrorLog-satrt***********\n{\n文件名称:%s;\n方法:%s;\n行数:%d;\n提示:%s\n}\n**********HGBErrorLog-end***********\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],[[NSString stringWithUTF8String:__func__] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define HGBLog(...);
#endif


@interface HGBDESEncryption()

@end
@implementation HGBDESEncryption
#pragma mark 初始化
static HGBDESEncryption *instance=nil;
/**
 单例

 @return 实例
 */
+ (instancetype)shareInstance
{
    if (instance==nil) {
        instance=[[HGBDESEncryption alloc]init];
    }
    return instance;
}
#pragma mark 设置
/**
 设置秘钥

 @param key 秘钥
 */
+(void)setKey:(NSString *)key{
    [HGBDESEncryption shareInstance];
    instance.key=key;
}
/**
 设置加密向量

 @param iv 加密向量
 */
+(void)setIv:(NSString *)iv{
    [HGBDESEncryption shareInstance];
    instance.iv=iv;
    
}
#pragma mark 加密方法
/**
 加密方法

 @param string 原始字符串
 @param key key
 @return 加密字符串
 */
+ (NSString*)DESEncryptString:(NSString*)string WithKey:(NSString *)key{
    if(string==nil){
        HGBLog(@"字符串不能为空");
        return nil;
    }
    if(key==nil){
        HGBLog(@"密钥不能为空");
    }
    [HGBDESEncryption shareInstance];



    const void *vkey = (const void *) [instance.key UTF8String];

    if(key&&key.length!=0){
        vkey=[key UTF8String];
    }
    NSString *result = nil;
//    NSData *textData = [string dataUsingEncoding:NSUTF8StringEncoding];
//    NSUInteger dataLength = [textData length];
//    unsigned char buffer[1024];
//    memset(buffer, 0, sizeof(char));
//    size_t numBytesEncrypted = 0;
//    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];
//    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
//                                          kCCOptionPKCS7Padding,
//                                          [key UTF8String], kCCKeySizeDES,
//                                          initVector.bytes,
//                                          [textData bytes], dataLength,
//                                          buffer, 1024,
//                                          &numBytesEncrypted);
//
//    if (cryptStatus == kCCSuccess) {
//        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
//        result = [HGBBase64 stringByEncodingData:data];
//    }
    return result;

}


/**
 解密方法

 @param string  加密字符串
 @param key key
 @return 解密字符串
 */
+ (NSString*)DESDecryptString:(NSString*)string WithKey:(NSString *)key{
    if(string==nil){
        HGBLog(@"字符串不能为空");
        return nil;
    }
    if(key==nil){
        HGBLog(@"密钥不能为空");
    }
     [HGBDESEncryption shareInstance];


    NSString *result = nil;
//    NSData *cipherdata = [HGBBase64 decodeString:string];
//    unsigned char buffer[1024];
//    memset(buffer, 0, sizeof(char));
//    size_t numBytesDecrypted = 0;
//    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];
//
//    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
//                                          kCCOptionPKCS7Padding,
//                                          [key UTF8String], kCCKeySizeDES,
//                                          initVector.bytes,
//                                          [cipherdata bytes], [cipherdata length],
//                                          buffer, 1024,
//                                          &numBytesDecrypted);
//    if(cryptStatus == kCCSuccess)
//    {
//        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
//        result = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
//    }
    return result;
}
#pragma mark get
-(NSString *)iv{
    if(_iv==nil){
        _iv=@"01234567";
    }
    return _iv;
}
-(NSString *)key{
    if(_key==nil){
        _key=@"01234567";
    }
    return _key;
}
@end
