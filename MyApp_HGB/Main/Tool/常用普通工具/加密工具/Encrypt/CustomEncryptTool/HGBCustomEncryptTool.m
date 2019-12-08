//
//  HGBCustomEncryptTool.m
//  VirtualCard
//
//  Created by huangguangbao on 2017/6/7.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCustomEncryptTool.h"
#import "HGBEncryptTool.h"

#define RSAPrivateKeyPassword @"123456"
#define RSAPublicKeyPath @"public_key.der"
#define RSAPrivateKeyPath @"private_key.p12"

#define RSAPublicKey @"hcdbhjsdbcdchsdb"
#define RSAPrivateKey @"hcdbhjsdbcdchsdb"

#define DESKEY @"hcdbhjsdbcdchsdb"
#define AESKEY @"hcdbhjsdbcdchsdb"
#define TTAlgorithmSM4_KEY @"hcdbhjsdbcdchsdb"
#define SALTString @"SCHJxN49XQvaLM3YSasKeMQd090803sa1ds5"


@implementation HGBCustomEncryptTool

#pragma mark 特殊字符编码
/**
 特殊字符编码
 
 @param string 字符串
 @return 编码后字符串
 */
+ (NSString *)specialStringEncodingWithString:(NSString *)string{
    return [HGBEncryptTool specialStringEncodingWithString:string];
}
/**
 特殊字符解码
 
 @param string 字符串
 @return 编码后字符串
 */
+ (NSString *)specialStringDecodingWithString:(NSString *)string{
    return [HGBEncryptTool specialStringDecodingWithString:string];
}
#pragma mark Base64-string
/**
 Base64编码-string
 
 @param string 字符串
 @return 编码后字符串
 */
+(NSString *)encryptStringWithBase64:(NSString *)string{
    return [HGBEncryptTool encryptStringWithBase64:string];
}

/**
 Base64解码-string
 
 @param string 字符串
 @return 解码后字符串
 */
+(NSString *)decryptStringWithBase64:(NSString *)string{
    return [HGBEncryptTool decryptStringWithBase64:string];
}

#pragma mark  MD5
/**
 MD5加密-32小写

 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithMD5_32LOW:(NSString *)string{
    return [HGBEncryptTool encryptStringWithMD5_32LOW:string];
}
/**
 MD5加密-32大写

 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithMD5_32UP:(NSString *)string{
    return [HGBEncryptTool encryptStringWithMD5_32UP:string];
}
/**
 MD5加密-16小写

 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithMD5_16LOW:(NSString *)string{
    return [HGBEncryptTool encryptStringWithMD5_16LOW:string];
}
/**
 MD5加密-16大写

 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithMD5_16UP:(NSString *)string{
    return [HGBEncryptTool encryptStringWithMD5_16UP:string];
}
#pragma mark sha1加密
/**
 *  sha1加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString*)encryptStringWithsha1:(NSString*)string{
    return [HGBEncryptTool encryptStringWithsha1:string];
}

#pragma mark 哈希字符串拼接
/**
 哈希字符串拼接

 @param object 对象
 @return hash字符串
 */
+(NSString *)hashStringFromJsonObject:(id )object andWithSalt:(NSString *)salt{
    return [HGBEncryptTool hashStringFromJsonObject:object andWithSalt:SALTString];
}

#pragma mark DES
/**
 DES加密
 
 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithDES3:(NSString *)string{
    return [HGBEncryptTool encryptStringWithDES:string andWithKey:DESKEY];
}
/**
 DES解密
 
 @param string 字符串
 @return 解密后字符串
 */
+(NSString *)decryptStringWithDES:(NSString *)string{
    return  [HGBEncryptTool decryptStringWithDES:string andWithKey:DESKEY];
}
#pragma mark AES128
/**
 AES128加密

 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithAES128:(NSString *)string{
    return [HGBEncryptTool encryptStringWithAES128:string andWithKey:AESKEY];
}
/**
 AES256解密

 @param string 字符串
 @return 解密后字符串
 */
+(NSString *)decryptStringWithAES128:(NSString *)string{
    return [HGBEncryptTool decryptStringWithAES128:string andWithKey:AESKEY];
}



#pragma mark 国密算法-ECB

/**
 *  TTAlgorithmSM4-ECB加密
 *
 *  @param string 要保存的value值
 */
+ (NSString *)encryptStringWithTTAlgorithmSM4_ECB:(NSString *)string{
    return [HGBEncryptTool encryptStringWithTTAlgorithmSM4_ECB:string andWithKey:TTAlgorithmSM4_KEY];
}
/**
 *  TTAlgorithmSM4-ECB解密
 *
 *  @return 获取的对象
 */

+(NSString *)decryptStringWithTTAlgorithmSM4_ECB:(NSString *)string{
    return [HGBEncryptTool decryptStringWithTTAlgorithmSM4_ECB:string andWithKey:TTAlgorithmSM4_KEY];
}
#pragma mark RSA-file 公钥加密 私钥解密
/**
 RSA加密－不编码

 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithFileRSA:(NSString *)string{
    return [HGBEncryptTool encryptStringWithRSA:string andWithPublicKeyPath:RSAPublicKeyPath];
}

/**
 RSA加密－编码

 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithFileRSAEncoding:(NSString *)string{
    return [HGBEncryptTool encryptStringWithRSAEncoding:string andWithPublicKeyPath:RSAPublicKeyPath];
}
/**
 RSA解密

 @param string 字符串
 @return 解密后字符串
 */
+(NSString *)decryptStringWithFileRSA:(NSString *)string{
    return [HGBEncryptTool decryptStringWithRSA:string andWithPrivateKeyPath:RSAPrivateKeyPath andWithPassWord:RSAPrivateKeyPassword];
}
#pragma mark RSA-file 私钥加密 公钥解密
/**
 RSA加密－不编码

 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithFileReverseRSA:(NSString *)string{
    return [HGBEncryptTool encryptStringWithReverseRSA:string andWithPrivateKeyPath:RSAPrivateKeyPath andWithPassWord:RSAPrivateKeyPassword];
}

/**
 RSA加密－编码

 @param string 字符串
 @return 加密后字符串
 */
+(NSString *)encryptStringWithFileReverseRSAEncoding:(NSString *)string{
    return [HGBEncryptTool encryptStringWithReverseRSAEncoding:string andWithPrivateKeyPath:RSAPrivateKeyPath andWithPassWord:RSAPrivateKeyPassword];
}
/**
 RSA解密

 @param string 字符串
 @return 解密后字符串
 */
+(NSString *)decryptStringWithFileReverseRSA:(NSString *)string{
    return [HGBEncryptTool decryptStringWithReverseRSA:string andWithPublicKeyPath:RSAPublicKeyPath];
}
@end
