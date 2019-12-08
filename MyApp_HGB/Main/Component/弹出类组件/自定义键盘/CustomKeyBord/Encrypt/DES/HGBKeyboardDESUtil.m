//
//  HGBKeyboardDESUtil.m
//  HelloCordova
//
//  Created by huangguangbao on 2017/8/9.
//
//

#import "HGBKeyboardDESUtil.h"


#import <CommonCrypto/CommonCryptor.h>
#import "HGBKeybordBase64.h"

static NSString *const kInitVector = @"00000000";


@implementation HGBKeyboardDESUtil
#pragma mark 加密
/**
 加密方法

 @param string 原始字符串
 @param key key
 @return 加密字符串
 */
+ (NSString*)DESEncryptString:(NSString*)string andWithKey:(NSString *)key{
    NSString *ciphertext = nil;
    NSData *textData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          initVector.bytes,
                                          [textData bytes], dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);

    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [HGBKeybordBase64 stringByEncodingData:data];
    }
    return ciphertext;
}


/**
 解密方法

 @param string  加密字符串
 @param key key
 @return 解密字符串
 */
+ (NSString*)DESDecryptString:(NSString*)string andWithKey:(NSString *)key{
    NSString *plaintext = nil;
    NSData *cipherdata = [HGBKeybordBase64 decodeString:string];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"*******************%@*******************",string);
     NSLog(@"*******************%@*******************",key);

    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          initVector.bytes,
                                          [cipherdata bytes], [cipherdata length],
                                          buffer, 1024,
                                          &numBytesDecrypted);
    if(cryptStatus == kCCSuccess)
    {
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
    }
    NSLog(@"*******************%@*******************",plaintext);
    return plaintext;
}

@end
