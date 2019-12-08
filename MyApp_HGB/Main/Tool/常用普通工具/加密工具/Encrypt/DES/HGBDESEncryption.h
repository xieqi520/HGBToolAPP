//
//  HGBDESEncryption.h
//  测试
//
//  Created by huangguangbao on 2017/9/14.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define HGBLogFlag YES
#else
#endif


@interface HGBDESEncryption : NSObject
/**
 秘钥
 */
@property(strong,nonatomic)NSString *key;
/**
 加密向量
 */
@property(strong,nonatomic)NSString *iv;
#pragma mark 加密
/**
 加密方法

 @param string 原始字符串
 @param key key
 @return 加密字符串
 */
+ (NSString*)DESEncryptString:(NSString*)string WithKey:(NSString *)key;


/**
 解密方法

 @param string  加密字符串
 @param key key
 @return 解密字符串
 */
+ (NSString*)DESDecryptString:(NSString*)string WithKey:(NSString *)key;

@end
