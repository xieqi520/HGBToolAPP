//
//  HGBAES256Encrytion.h
//  HGBEncryptTool
//
//  Created by huangguangbao on 2017/8/24.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define HGBLogFlag YES
#else
#endif


@interface HGBAES256Encrytion : NSObject
#pragma mark 快捷加密解密-字符串


/**
 *  @brief  AES256加密-字符串
 *
 *  @param string    明文
 *  @param keyString 32位的密钥
 *
 *  @return 返回加密后的密文
 */
+ (NSString *)AES256EncryptString:(NSString *)string  WithKey:(NSString *)keyString;


/**
 *  @brief  AES256解密-字符串
 *
 *  @param string    密文
 *  @param keyString 32位的密钥
 *
 *  @return 返回解密后的明文
 */
+ (NSString *)AES256DecryptString:(NSString *) string WithKey:(NSString *)keyString;
#pragma mark 快捷加密解密-数据流

/**
 *  @brief  AES256加密-二进制
 *
 *  @param data    明文
 *  @param keyString 32位的密钥
 *
 *  @return 返回加密后的密文
 */
+ (NSData *)AES256EncryptData:(NSData *)data  WithKey:(NSString *)keyString;


/**
 *  @brief  AES256解密-二进制
 *
 *  @param data    密文
 *  @param keyString 32位的密钥
 *
 *  @return 返回解密后的明文
 */
+ (NSData *)AES256DecryptData:(NSData *)data  WithKey:(NSString *)keyString;
@end

