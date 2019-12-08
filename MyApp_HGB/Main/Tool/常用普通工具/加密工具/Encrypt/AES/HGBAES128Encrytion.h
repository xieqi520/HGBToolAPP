//
//  HGBAES128Encrytion.h
//  测试
//
//  Created by huangguangbao on 2017/11/1.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define HGBLogFlag YES
#else
#endif

@interface HGBAES128Encrytion : NSObject
#pragma mark 加密
/**
 加密方法

 @param string 原始字符串
 @param key key
 @return 加密字符串
 */
+ (NSString*)AES128EncryptString:(NSString*)string andWithKey:(NSString *)key;


/**
 解密方法

 @param string  加密字符串
 @param key key
 @return 解密字符串
 */
+ (NSString*)AES128DecryptString:(NSString*)string andWithKey:(NSString *)key;
@end
