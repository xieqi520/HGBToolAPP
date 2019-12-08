//
//  HGBKeyboardAES128Util.h
//  CustomKeyboard
//
//  Created by huangguangbao on 2018/5/18.
//  Copyright © 2018年 com.agree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGBKeyboardAES128Util : NSObject
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
