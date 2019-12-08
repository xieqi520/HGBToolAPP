//
//  HGBMonitorFileTool.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/5/22.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import "HGBMonitorFileTool.h"
#import <UIKit/UIKit.h>
#import <fcntl.h>
#import <sys/event.h>

@interface HGBMonitorFileTool()
{

    CFFileDescriptorRef kqref;
    CFRunLoopSourceRef  rls;
@private
    NSURL *_fileURL;
    dispatch_source_t _source;
    int _fileDescriptor;
    BOOL _keepMonitoringFile;
}
/**
 watcher回调
 */
@property (nonatomic,copy) void (^watcherFileChangeBlock)(NSInteger type);
/**
 地址
 */
@property (strong) NSString *path;
/**
monitor 回调
 */
@property (nonatomic,copy) void (^monitorFileChangeBlock)(NSInteger type);
@end

@implementation HGBMonitorFileTool
#pragma mark watcher
- (void)kqueueFired
{
    int             kq;
    struct kevent   event;
    struct timespec timeout = { 0, 0 };
    int             eventCount;

    kq = CFFileDescriptorGetNativeDescriptor(self->kqref);
    assert(kq >= 0);

    eventCount = kevent(kq, NULL, 0, &event, 1, &timeout);
    assert( (eventCount >= 0) && (eventCount < 2) );

    if (self.watcherFileChangeBlock) {
        self.watcherFileChangeBlock(eventCount);
    }

    CFFileDescriptorEnableCallBacks(self->kqref, kCFFileDescriptorReadCallBack);
}

static void KQCallback(CFFileDescriptorRef kqRef, CFOptionFlags callBackTypes, void *info)
{
    HGBMonitorFileTool *helper = (HGBMonitorFileTool *)(__bridge id)(CFTypeRef) info;
    [helper kqueueFired];
}

- (void) beginGeneratingDocumentNotificationsInPath: (NSString *) docPath
{
    int                     dirFD;
    int                     kq;
    int                     retVal;
    struct kevent           eventToAdd;
    CFFileDescriptorContext context = { 0, (void *)(__bridge CFTypeRef) self, NULL, NULL, NULL };

    dirFD = open([docPath fileSystemRepresentation], O_EVTONLY);
    assert(dirFD >= 0);

    kq = kqueue();
    assert(kq >= 0);

    eventToAdd.ident  = dirFD;
    eventToAdd.filter = EVFILT_VNODE;
    eventToAdd.flags  = EV_ADD | EV_CLEAR;
    eventToAdd.fflags = NOTE_WRITE;
    eventToAdd.data   = 0;
    eventToAdd.udata  = NULL;

    retVal = kevent(kq, &eventToAdd, 1, NULL, 0, NULL);
    assert(retVal == 0);

    self->kqref = CFFileDescriptorCreate(NULL, kq, true, KQCallback, &context);
    rls = CFFileDescriptorCreateRunLoopSource(NULL, self->kqref, 0);
    assert(rls != NULL);

    CFRunLoopAddSource(CFRunLoopGetCurrent(), rls, kCFRunLoopDefaultMode);
    CFRelease(rls);
    CFFileDescriptorEnableCallBacks(self->kqref, kCFFileDescriptorReadCallBack);
}

- (void) dealloc
{
    self.path = nil;
    CFRunLoopRemoveSource(CFRunLoopGetCurrent(), rls, kCFRunLoopDefaultMode);
    CFFileDescriptorDisableCallBacks(self->kqref, kCFFileDescriptorReadCallBack);
    if (_source) {
        dispatch_source_cancel(_source);
    }
}


/**
 监听文件变化

 @param srcPath 文件路径
 @param block 回调
 @return 结果
 */
- (BOOL)watcherForPath:(NSString *)srcPath block:(void (^)(NSInteger type))block{
    if (srcPath==nil) {
        return NO;
    }
    if (![HGBMonitorFileTool isURL:srcPath]) {
        return NO;
    }
    if (![HGBMonitorFileTool urlExistCheck:srcPath]) {
        return NO;
    }
    NSString *lastPath=[HGBMonitorFileTool urlAnalysisToPath:srcPath];
    self.path = lastPath;
    self.watcherFileChangeBlock = block;
    [self beginGeneratingDocumentNotificationsInPath:lastPath];
    return YES;
}
#pragma mark monitor
/**
 监听文件变化

 @param srcPath 文件路径
 @param block 回调
 @return 结果
 */
- (BOOL)monitorForPath:(NSString *)srcPath block:(void (^)(NSInteger type))block{
    if (srcPath==nil) {
        return NO;
    }
    if (![HGBMonitorFileTool isURL:srcPath]) {
        return NO;
    }
    if (![HGBMonitorFileTool urlExistCheck:srcPath]) {
        return NO;
    }
    NSString *lastURL=[HGBMonitorFileTool urlAnalysis:srcPath];
    self.monitorFileChangeBlock = block;
    NSURL *url = [NSURL URLWithString:lastURL];
    _fileURL = url;
    _keepMonitoringFile = NO;
    [self __beginMonitoringFile];
    return YES;
}



- (void)__beginMonitoringFile
{

    _fileDescriptor = open([[_fileURL path] fileSystemRepresentation],
                           O_EVTONLY);
    dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,
                                     _fileDescriptor,
                                     DISPATCH_VNODE_ATTRIB | DISPATCH_VNODE_DELETE | DISPATCH_VNODE_EXTEND | DISPATCH_VNODE_LINK | DISPATCH_VNODE_RENAME | DISPATCH_VNODE_REVOKE | DISPATCH_VNODE_WRITE,
                                     defaultQueue);
    dispatch_source_set_event_handler(_source, ^ {
        unsigned long eventTypes = dispatch_source_get_data(_source);
        [self __alertDelegateOfEvents:eventTypes];
    });

    dispatch_source_set_cancel_handler(_source, ^{
        close(_fileDescriptor);
        _fileDescriptor = 0;
        _source = nil;

        // If this dispatch source was canceled because of a rename or delete notification, recreate it
        if (_keepMonitoringFile) {
            _keepMonitoringFile = NO;
            [self __beginMonitoringFile];
        }
    });
    dispatch_resume(_source);
}

- (void)__recreateDispatchSource
{
    _keepMonitoringFile = YES;
    dispatch_source_cancel(_source);
}

- (void)__alertDelegateOfEvents:(unsigned long)eventTypes
{
    dispatch_async(dispatch_get_main_queue(), ^ {
        BOOL recreateDispatchSource = NO;
        NSMutableSet *eventSet = [[NSMutableSet alloc] initWithCapacity:7];

        if (eventTypes & DISPATCH_VNODE_ATTRIB) {
            [eventSet addObject:@(DISPATCH_VNODE_ATTRIB)];
        }
        if (eventTypes & DISPATCH_VNODE_DELETE) {
            [eventSet addObject:@(DISPATCH_VNODE_DELETE)];
            recreateDispatchSource = YES;
        }
        if (eventTypes & DISPATCH_VNODE_EXTEND) {
            [eventSet addObject:@(DISPATCH_VNODE_EXTEND)];
        }
        if (eventTypes & DISPATCH_VNODE_LINK) {
            [eventSet addObject:@(DISPATCH_VNODE_LINK)];
        }
        if (eventTypes & DISPATCH_VNODE_RENAME){
            [eventSet addObject:@(DISPATCH_VNODE_RENAME)];
            recreateDispatchSource = YES;
        }
        if (eventTypes & DISPATCH_VNODE_REVOKE) {
            [eventSet addObject:@(DISPATCH_VNODE_REVOKE)];
        }
        if (eventTypes & DISPATCH_VNODE_WRITE) {
            [eventSet addObject:@(DISPATCH_VNODE_WRITE)];
        }

        for (NSNumber *eventType in eventSet) {
            if (self.monitorFileChangeBlock) {
                self.monitorFileChangeBlock([eventType unsignedIntegerValue]);
            }
        }
        if (recreateDispatchSource) {
            [self __recreateDispatchSource];
        }
    });
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
    if(![HGBMonitorFileTool isURL:url]){
        return NO;
    }
    url=[HGBMonitorFileTool urlAnalysis:url];
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
    if(![HGBMonitorFileTool isURL:url]){
        return nil;
    }
    NSString *urlstr=[HGBMonitorFileTool urlAnalysis:url];
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
    if(![HGBMonitorFileTool isURL:url]){
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
    if(![HGBMonitorFileTool isURL:url]){
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
