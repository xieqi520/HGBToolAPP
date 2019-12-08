//
//  HGBAppManager.m
//  测试
//
//  Created by huangguangbao on 2018/4/2.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import "HGBAppManager.h"
#import <objc/runtime.h>

#import <spawn.h>
#import <sys/wait.h>
#include <dlfcn.h>
#import <UIKit/UIKit.h>

#define EXECUTABLE_VERSION @"3.4.1"

#define KEY_INSTALL_TYPE @"User"

#define FrameWorkSDKPATH @"project://MobileInstallation.framework/MobileInstallation"


// ipaPath是要安装的IPA包路径
// frameworkPath是MobileInstallion的路径
// 一般来说Mac OSX应该是/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS5.0.sdk/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation
// 真机设备则是/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation
typedef int (*MobileInstallationInstall)(NSString *path, NSDictionary *dict, void *na, NSString *backpath);

typedef int (*MobileInstallationUninstall)(NSString *bundleID, NSDictionary *dict, void *na);

@interface HGBAppManager ()

@end

@implementation HGBAppManager
#pragma mark init
static HGBAppManager *instance=nil;
/**
 单例

 @return 实例
 */
+(instancetype)shareInstance
{
    if (instance==nil) {
        instance=[[HGBAppManager alloc]init];
    }
    return instance;
}
#pragma mark 功能
/**
 获取所有app列表

 @return app列表
 */
-(NSArray *)getAllAppList
{
    NSMutableArray *appList=[NSMutableArray array];
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    NSArray * orignAppList=[workspace performSelector:@selector(allApplications)];

    if (workspace==nil) {
        return nil;
    }

    //设备安装的app列表
    Class LSApplicationProxy_class = object_getClass(@"LSApplicationProxy");
    for (LSApplicationProxy_class in orignAppList) {
        //这里可以查看一些信息
        NSString *bundleID = [LSApplicationProxy_class performSelector:@selector(applicationIdentifier)];
        NSString *appName = [LSApplicationProxy_class performSelector:@selector(localizedName)];
         NSString * type = [LSApplicationProxy_class performSelector:@selector(applicationType)];
        NSString *version = [LSApplicationProxy_class performSelector:@selector(bundleVersion)];
        NSString *shortVersion = [LSApplicationProxy_class performSelector:@selector(shortVersionString)];


        NSMutableDictionary *appInfo=[NSMutableDictionary dictionary];
        if (bundleID) {
            [appInfo setObject:bundleID forKey:@"bundleID"];
        }
        if (appName) {
            [appInfo setObject:appName forKey:@"appName"];
        }
        if(type){
            [appInfo setObject:type forKey:@"appType"];
        }
        if (version) {
            [appInfo setObject:version forKey:@"buildVersion"];
        }
        if (shortVersion) {
            [appInfo setObject:shortVersion forKey:@"version"];
        }

        [appList addObject:appInfo];

    }
    return appList;
}
/**
 获取所有系统app列表

 @return app列表
 */
-(NSArray *)getAllSystemAppList{
    NSMutableArray *appList=[NSMutableArray array];
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    NSArray * orignAppList=[workspace performSelector:@selector(allApplications)];

    if (workspace==nil) {
        return nil;
    }

    //设备安装的app列表
    Class LSApplicationProxy_class = object_getClass(@"LSApplicationProxy");
    for (LSApplicationProxy_class in orignAppList) {
        //这里可以查看一些信息
        NSString *bundleID = [LSApplicationProxy_class performSelector:@selector(applicationIdentifier)];
        NSString *appName = [LSApplicationProxy_class performSelector:@selector(localizedName)];
        NSString * type = [LSApplicationProxy_class performSelector:@selector(applicationType)];
        NSString *version = [LSApplicationProxy_class performSelector:@selector(bundleVersion)];
        NSString *shortVersion = [LSApplicationProxy_class performSelector:@selector(shortVersionString)];


        if([type isEqualToString:@"System"]){
            NSMutableDictionary *appInfo=[NSMutableDictionary dictionary];
            if (bundleID) {
                [appInfo setObject:bundleID forKey:@"bundleID"];
            }
            if (appName) {
                [appInfo setObject:appName forKey:@"appName"];
            }
            if(type){
                [appInfo setObject:type forKey:@"appType"];
            }
            if (version) {
                [appInfo setObject:version forKey:@"version"];
            }
            if (shortVersion) {
                [appInfo setObject:shortVersion forKey:@"shortVersion"];
            }

            [appList addObject:appInfo];

        }

    }
    return appList;
}
/**
 获取所有安装的app列表

 @return app列表
 */
-(NSArray *)getAllInstalledAppList{
    NSMutableArray *appList=[NSMutableArray array];
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    NSArray * orignAppList=[workspace performSelector:@selector(allApplications)];

    if (workspace==nil) {
        return nil;
    }

    //设备安装的app列表
    Class LSApplicationProxy_class = object_getClass(@"LSApplicationProxy");
    for (LSApplicationProxy_class in orignAppList) {
        //这里可以查看一些信息
        NSString *bundleID = [LSApplicationProxy_class performSelector:@selector(applicationIdentifier)];
        NSString *version = [LSApplicationProxy_class performSelector:@selector(bundleVersion)];
        NSString *shortVersion = [LSApplicationProxy_class performSelector:@selector(shortVersionString)];
        //应用的类型是系统的应用还是第三方的应用
        NSString * type = [LSApplicationProxy_class performSelector:@selector(applicationType)];
        if([type isEqualToString:@"User"]){
            NSString *appName = [LSApplicationProxy_class performSelector:@selector(localizedName)];
            NSMutableDictionary *appInfo=[NSMutableDictionary dictionary];

            if (bundleID) {
                [appInfo setObject:bundleID forKey:@"bundleID"];
            }
            if (appName) {
                [appInfo setObject:appName forKey:@"appName"];
            }
            if(type){
                [appInfo setObject:type forKey:@"appType"];
            }
            if (version) {
                [appInfo setObject:version forKey:@"version"];
            }
            if (shortVersion) {
                [appInfo setObject:shortVersion forKey:@"shortVersion"];
            }
            [appList addObject:appInfo];
        }


    }
    return appList;
    
}




/**
 是否安装app

 @param bundleId bundleId
 @return 结果
 */
-(BOOL)isInstalledWithAppBundleId:(NSString *)bundleId{
    if (bundleId==nil||bundleId.length==0) {
        return NO;
    }
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];

    if (workspace==nil) {
        return NO;
    }

    BOOL isInstall = [workspace performSelector:@selector(applicationIsInstalled:) withObject:bundleId];
    return isInstall;
}
/**
 通过bundleId打开app

 @param bundleId bundleId
 @return 结果
 */
-(BOOL)openAppWithAppBundleId:(NSString *)bundleId{
    if (bundleId==nil||bundleId.length==0) {
        return NO;
    }
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];

    if (workspace==nil) {
        return NO;
    }

    BOOL isInstall = [workspace performSelector:@selector(applicationIsInstalled:) withObject:bundleId];
    if (isInstall) {
        //通过bundle id。打开一个APP
        [workspace performSelector:@selector(openApplicationWithBundleID:) withObject:bundleId];
        return YES;
    }else{
        return NO;
    }
}
/**
 安装app

 @param ipaPath app的路径
 @param bundleId app的bundleid
 @return 卸载结果
 */
-(BOOL)installAppWithIpaPath:(NSString *)ipaPath andWithAppBundleId:(NSString *)bundleId{
    if(ipaPath==nil||ipaPath.length==0||bundleId==nil||bundleId.length==0){
        return NO;
    }
    if(![HGBAppManager urlExistCheck:ipaPath]){
        return NO;
    }
    NSString *lastPath=[HGBAppManager urlAnalysisToPath:ipaPath];

    int ret = -1;
    NSString *frameworkPath=[HGBAppManager urlAnalysisToPath:FrameWorkSDKPATH];
    void *lib = dlopen([frameworkPath UTF8String], RTLD_LAZY);
    if (lib) {
        MobileInstallationInstall install = (MobileInstallationInstall)dlsym(lib, "MobileInstallationInstall");
        NSString* temp = [NSTemporaryDirectory() stringByAppendingPathComponent:[@"Temp_" stringByAppendingString:lastPath.lastPathComponent]];
        if (![[NSFileManager defaultManager] copyItemAtPath:lastPath toPath:temp error:nil]) {
            NSLog(@"检查要安装的IPA路径是否正确!");
            return NO;
        }
        if (install){
            ret = install(temp, [NSDictionary dictionaryWithObject:KEY_INSTALL_TYPE forKey:@"ApplicationType"], 0, lastPath);
        }
        dlclose(lib);
    }
    if (ret==0) {
        return YES;
    }else{
         return NO;
    }




}

/**
 卸载app

 @param bundleId app的bundleid
 @return 卸载结果
 */
-(BOOL)unInstallAppWithAppBundleId:(NSString *)bundleId{
    if(bundleId==nil||bundleId.length==0){
        return NO;
    }
    if (kCFCoreFoundationVersionNumber < 1140.10) {
        NSString *frameworkPath=[HGBAppManager urlAnalysisToPath:FrameWorkSDKPATH];
        void *lib = dlopen([frameworkPath UTF8String], RTLD_LAZY);
        if (lib) {
            MobileInstallationUninstall uninstall = (MobileInstallationUninstall)dlsym(lib, "MobileInstallationUninstall");
            if (uninstall)
                return 0 == uninstall(bundleId, nil, nil);
            dlclose(lib);
        }
    } else {
        Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
        if (LSApplicationWorkspace_class) {
            NSObject *workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
            if (workspace==nil) {
                return NO;
            }
            return  [workspace performSelector:@selector(uninstallApplication:) withObject:bundleId];
        }

    }
    return NO;
}
#pragma mark url
/**
 判断路径是否是URL

 @param url url路径
 @return 结果
 */
+(BOOL)isURL:(NSString*)url{
    if([url hasPrefix:@"project://"]||[url hasPrefix:@"home://"]||[url hasPrefix:@"document://"]||[url hasPrefix:@"caches://"]||[url hasPrefix:@"tmp://"]||[url hasPrefix:@"defaults://"]||[url hasPrefix:@"/User"]||[url hasPrefix:@"/var"]||[url hasPrefix:@"http://"]||[url hasPrefix:@"https://"]||[url hasPrefix:@"file://"]){
        return YES;
    }else{
        return NO;
    }
}
/**
 url校验存在

 @param url url
 @return 是否存在
 */
+(BOOL)urlExistCheck:(NSString *)url{
    if(url==nil||url.length==0){
        return NO;
    }
    if(![HGBAppManager isURL:url]){
        return NO;
    }
    url=[HGBAppManager urlAnalysis:url];
    if(![url containsString:@"://"]){
        url=[[NSURL fileURLWithPath:url]absoluteString];
    }
    if([url hasPrefix:@"file://"]){
        NSString *filePath=[[NSURL URLWithString:url]path];
        if(filePath==nil||filePath.length==0){
            return NO;
        }
        NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
        return [filemanage fileExistsAtPath:filePath];
    }else{
        NSURL *urlCheck=[NSURL URLWithString:url];

        return [[UIApplication sharedApplication]canOpenURL:urlCheck];

    }
}
/**
 url解析

 @return 解析后url
 */
+(NSString *)urlAnalysisToPath:(NSString *)url{
    if(url==nil){
        return nil;
    }
    if(![HGBAppManager isURL:url]){
        return nil;
    }
    NSString *urlstr=[HGBAppManager urlAnalysis:url];
    return [[NSURL URLWithString:urlstr]path];
}
/**
 url解析

 @return 解析后url
 */
+(NSString *)urlAnalysis:(NSString *)url{
    if(url==nil){
        return nil;
    }
    if(![HGBAppManager isURL:url]){
        return nil;
    }
    if([url containsString:@"://"]){
        //project://工程包内
        //home://沙盒路径
        //http:// https://网络路径
        //document://沙盒Documents文件夹
        //caches://沙盒Caches
        //tmp://沙盒Tmp文件夹
        if([url hasPrefix:@"project://"]||[url hasPrefix:@"home://"]||[url hasPrefix:@"document://"]||[url hasPrefix:@"defaults://"]||[url hasPrefix:@"caches://"]||[url hasPrefix:@"tmp://"]){
            if([url hasPrefix:@"project://"]){
                url=[url stringByReplacingOccurrencesOfString:@"project://" withString:@""];
                NSString *projectPath=[[NSBundle mainBundle]resourcePath];
                url=[projectPath stringByAppendingPathComponent:url];
            }else if([url hasPrefix:@"home://"]){
                url=[url stringByReplacingOccurrencesOfString:@"home://" withString:@""];
                NSString *homePath=NSHomeDirectory();
                url=[homePath stringByAppendingPathComponent:url];
            }else if([url hasPrefix:@"document://"]){
                url=[url stringByReplacingOccurrencesOfString:@"document://" withString:@""];
                NSString  *documentPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
                url=[documentPath stringByAppendingPathComponent:url];
            }else if([url hasPrefix:@"defaults://"]){
                url=[url stringByReplacingOccurrencesOfString:@"defaults://" withString:@""];
                NSString  *documentPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
                url=[documentPath stringByAppendingPathComponent:url];
            }else if([url hasPrefix:@"caches://"]){
                url=[url stringByReplacingOccurrencesOfString:@"caches://" withString:@""];
                NSString  *cachesPath =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) lastObject];
                url=[cachesPath stringByAppendingPathComponent:url];
            }else if([url hasPrefix:@"tmp://"]){
                url=[url stringByReplacingOccurrencesOfString:@"tmp://" withString:@""];
                NSString *tmpPath =NSTemporaryDirectory();
                url=[tmpPath stringByAppendingPathComponent:url];
            }
            url=[[NSURL fileURLWithPath:url]absoluteString];

        }else{

        }
    }else {
        url=[[NSURL fileURLWithPath:url]absoluteString];
    }
    return url;
}
/**
 url封装

 @return 封装后url
 */
+(NSString *)urlEncapsulation:(NSString *)url{
    if(![HGBAppManager isURL:url]){
        return nil;
    }
    NSString *homePath=NSHomeDirectory();
    NSString  *documentPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
    NSString  *cachesPath =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) lastObject];
    NSString *projectPath=[[NSBundle mainBundle]resourcePath];
    NSString *tmpPath =NSTemporaryDirectory();

    if([url hasPrefix:@"file://"]){
        url=[url stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    }
    if([url hasPrefix:projectPath]){
        url=[url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",projectPath] withString:@"project://"];
        url=[url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",projectPath] withString:@"project://"];
    }else if([url hasPrefix:documentPath]){
        url=[url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",documentPath] withString:@"defaults://"];
        url=[url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",documentPath] withString:@"defaults://"];
    }else if([url hasPrefix:cachesPath]){
        url=[url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",cachesPath] withString:@"caches://"];
        url=[url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",cachesPath] withString:@"caches://"];
    }else if([url hasPrefix:tmpPath]){
        url=[url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",tmpPath] withString:@"tmp://"];
        url=[url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",tmpPath] withString:@"tmp://"];
    }else if([url hasPrefix:homePath]){
        url=[url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",homePath] withString:@"home://"];
        url=[url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",homePath] withString:@"home://"];
    }else if([url containsString:@"://"]){

    }else{
        url=[[NSURL fileURLWithPath:url]absoluteString];
    }
    return url;
}
@end


/*
@class LSApplicationProxy, NSArray, NSDictionary, NSProgress, NSString, NSURL, NSUUID;

@interface LSApplicationProxy : LSResourceProxy <NSSecureCoding> {
    NSArray *_UIBackgroundModes;
    NSString *_applicationType;
    NSArray *_audioComponents;
    unsigned int _bundleFlags;
    NSURL *_bundleURL;
    NSString *_bundleVersion;
    NSArray *_directionsModes;
    NSDictionary *_entitlements;
    NSDictionary *_environmentVariables;
    unsigned int _flags;
    BOOL _foundBackingBundle;
    NSDictionary *_groupContainers;
    unsigned int _installType;
    BOOL _isAppUpdate;
    BOOL _isInstalled;
    BOOL _isNewsstandApp;
    BOOL _isPlaceholder;
    BOOL _isRestricted;
    NSArray *_machOUUIDs;
    NSArray *_privateDocumentIconNames;
    LSApplicationProxy *_privateDocumentTypeOwner;
    BOOL _profileValidated;
    NSString *_shortVersionString;
    NSString *_signerIdentity;
    NSString *_vendorID;
    NSString *_vendorName;
}

@property(readonly) NSArray * UIBackgroundModes;
@property(readonly) BOOL _gkIsAppleInternal;
@property(readonly) BOOL _gkIsInstalled;
@property(readonly) NSString * applicationIdentifier;
@property(readonly) NSString * applicationType;
@property(readonly) NSArray * audioComponents;
@property(readonly) NSURL * bundleURL;
@property(readonly) NSString * bundleVersion;
@property(readonly) NSURL * containerURL;
@property(readonly) NSUUID * deviceIdentifierForVendor;
@property(readonly) NSArray * directionsModes;
@property(readonly) NSDictionary * entitlements;
@property(readonly) NSDictionary * environmentVariables;
@property(readonly) BOOL foundBackingBundle;
@property(readonly) NSDictionary * groupContainers;
@property(readonly) NSProgress * installProgress;
@property(readonly) unsigned int installType;
@property(readonly) BOOL isAppUpdate;
@property(readonly) BOOL isInstalled;
@property(readonly) BOOL isNewsstandApp;
@property(readonly) BOOL isPlaceholder;
@property(readonly) BOOL isRestricted;
@property(readonly) NSArray * machOUUIDs;
@property(readonly) BOOL profileValidated;
@property(readonly) NSString * roleIdentifier;
@property(readonly) NSString * shortVersionString;
@property(readonly) NSString * signerIdentity;
@property(readonly) NSString * vendorID;
@property(readonly) NSString * vendorName;

+ (id)_gkMetadataForBundleURL:(id)arg1;
+ (id)applicationProxyForIdentifier:(id)arg1 placeholder:(BOOL)arg2 server:(BOOL)arg3;
+ (id)applicationProxyForIdentifier:(id)arg1 placeholder:(BOOL)arg2;
+ (id)applicationProxyForIdentifier:(id)arg1 roleIdentifier:(id)arg2;
+ (id)applicationProxyForIdentifier:(id)arg1;
+ (BOOL)supportsSecureCoding;

- (id)UIBackgroundModes;
- (unsigned char)_createContext:(struct LSContext { struct LSDatabase {} *x1; }*)arg1 andGetBundle:(unsigned int*)arg2 withData:(const struct LSBundleData {}**)arg3;
- (struct CGSize { float x1; float x2; })_defaultStyleSize:(id)arg1;
- (id)_gkAdamID;
- (id)_gkBundle;
- (void)_gkDetachITunesMetadata;
- (id)_gkExternalVersion;
- (id)_gkGameDescriptor;
- (id)_gkITunesMetadata;
- (BOOL)_gkIsAppleInternal;
- (BOOL)_gkIsGameCenterEnabled;
- (BOOL)_gkIsGameCenterEverEnabled;
- (BOOL)_gkIsInstalled;
- (id)_gkItemName;
- (id)_gkPurchaseDate;
- (struct { int x1; struct CGSize { float x_2_1_1; float x_2_1_2; } x2; }*)_iconVariantDefinitions:(id)arg1;
- (id)_initWithApplicationIdentifier:(id)arg1 bundleType:(unsigned int)arg2 name:(id)arg3 containerURL:(id)arg4 resourcesDirectoryURL:(id)arg5 iconsDictionary:(id)arg6 iconFileNames:(id)arg7 iconIsPrerendered:(BOOL)arg8 server:(BOOL)arg9;
- (id)_plistValueForKey:(id)arg1;
- (id)applicationIdentifier;
- (id)applicationType;
- (id)audioComponents;
- (id)bundleURL;
- (id)bundleVersion;
- (id)containerURL;
- (void)dealloc;
- (id)description;
- (id)deviceIdentifierForVendor;
- (id)directionsModes;
- (void)encodeWithCoder:(id)arg1;
- (id)entitlements;
- (id)environmentVariables;
- (BOOL)foundBackingBundle;
- (id)groupContainers;
- (unsigned int)hash;
- (id)iconDataForVariant:(int)arg1;
- (id)iconStyleDomain;
- (id)initWithCoder:(id)arg1;
- (id)installProgress;
- (id)installProgressSync;
- (unsigned int)installType;
- (BOOL)isAppUpdate;
- (BOOL)isEqual:(id)arg1;
- (BOOL)isInstalled;
- (BOOL)isNewsstandApp;
- (BOOL)isPlaceholder;
- (BOOL)isRestricted;
- (id)localizedName;
- (id)machOUUIDs;
- (BOOL)privateDocumentIconAllowOverride;
- (id)privateDocumentIconNames;
- (id)privateDocumentTypeOwner;
- (BOOL)profileValidated;
- (id)resourcesDirectoryURL;
- (id)roleIdentifier;
- (void)setPrivateDocumentIconAllowOverride:(BOOL)arg1;
- (void)setPrivateDocumentIconNames:(id)arg1;
- (void)setPrivateDocumentTypeOwner:(id)arg1;
- (id)shortVersionString;
- (id)signerIdentity;
- (id)vendorID;
- (id)vendorName;

@end
 */
