//
//  HGBKeyboardDESUtil.h
//  HelloCordova
//
//  Created by huangguangbao on 2017/8/9.
//
//

#import <Foundation/Foundation.h>



/**
 DES加密
 */
@interface HGBKeyboardDESUtil : NSObject
#pragma mark 加密
/**
 加密方法

 @param string 原始字符串
 @param key key
 @return 加密字符串
 */
+ (NSString*)DESEncryptString:(NSString*)string andWithKey:(NSString *)key;


/**
 解密方法

 @param string  加密字符串
 @param key key
 @return 解密字符串
 */
+ (NSString*)DESDecryptString:(NSString*)string andWithKey:(NSString *)key;
@end
