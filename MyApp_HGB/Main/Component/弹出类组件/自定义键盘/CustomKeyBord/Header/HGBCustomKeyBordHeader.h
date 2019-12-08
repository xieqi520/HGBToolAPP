//
//  HGBCustomKeyBordHeader.h
//  二维码条形码识别
//
//  Created by huangguangbao on 2017/6/9.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#ifndef HGBCustomKeyBordHeader_h
#define HGBCustomKeyBordHeader_h

#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0
#define SOUNDID  1104
#define margin 5

#import <AudioToolbox/AudioToolbox.h>


/**
 *	键盘类型Type
 */
typedef enum
{
    HGBCustomKeyBordType_NumWord,//数字及字母键盘
    HGBCustomKeyBordType_WordNum,//字母及数字键盘
    HGBCustomKeyBordType_NumWordSymbol,//数字及字母,标点键盘
    HGBCustomKeyBordType_WordNumSymbol,//字母及数字,标点键盘
    HGBCustomKeyBordType_Num,//仅数字键盘
    HGBCustomKeyBordType_Word//仅字母键盘
    
    
}HGBCustomKeyBordType;


/**
 *	键盘显示类型Type
 */
typedef enum
{
    HGBCustomKeyBordShowType_InTime,//普通
    HGBCustomKeyBordShowType_CommonDone,//显示完成后统一返回
    HGBCustomKeyBordShowType_EncryptDone,//秘文显示完成后统一返回
}HGBCustomKeyBordShowType;


/**
 *    键盘显示类型Type
 */
typedef enum
{
    HGBCustomKeyBordEncryptType_TTAlgorithmSM4,//国密加密
    HGBCustomKeyBordEncryptType_DES,//DES加密
    HGBCustomKeyBordEncryptType_3DES,//3DES加密
    HGBCustomKeyBordEncryptType_AES128,//AES128加密
    HGBCustomKeyBordEncryptType_MD532UP,//MD532UP
    HGBCustomKeyBordEncryptType_MD532LOW,//MD532LOW/
    HGBCustomKeyBordEncryptType_MD516UP,//MD516UP
    HGBCustomKeyBordEncryptType_MD516LOW//MD516LOW/


}HGBCustomKeyBordEncryptType;



typedef void(^ CompleteBlock)(void);

//#define FrameworkPath  [[NSBundle mainBundle] pathForResource:@"HGBCustomKeyBord" ofType:@"framework"]
//
//#define FrameworkBundle  [NSBundle bundleWithPath:FrameworkPath]
//
//#define imageBundle [NSBundle bundleWithPath:[FrameworkBundle pathForResource:@"HGBCustomKeyBordBundle" ofType:@"bundle"]]
//#define UIResourceBundleSubMove(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"images/move/%@",imageName] inBundle:VivienBundle compatibleWithTraitCollection:nil]
//
//
//NS_INLINE UIImage * UIResourceBundleMore(NSString *imageName){
//    return [UIImage imageNamed:[NSString stringWithFormat:@"images/main/%@",imageName] inBundle:imageBundle compatibleWithTraitCollection:nil];
//}
#endif /* HGBCustomKeyBordHeader_h */
