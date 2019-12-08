//
//  HGBKeyboard3DESUtil.h
//  CustomKeyboard
//
//  Created by huangguangbao on 2018/5/18.
//  Copyright © 2018年 com.agree. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define HGBLogFlag YES
#else
#endif


@interface HGBKeyboard3DESUtil : NSObject
#pragma mark 加密
/**
 加密方法

 @param string 原始字符串
 @param key key
 @return 加密字符串
 */
+ (NSString*)DES3EncryptString:(NSString*)string andWithKey:(NSString *)key;


/**
 解密方法

 @param string  加密字符串
 @param key key
 @return 解密字符串
 */
+ (NSString*)DES3DecryptString:(NSString*)string andWithKey:(NSString *)key;
#pragma mark 设置
/**
 设置秘钥

 @param key 秘钥
 */
+(void)setKey:(NSString *)key;
/**
 设置加密向量

 @param iv 加密向量
 */
+(void)setIv:(NSString *)iv;
@end
