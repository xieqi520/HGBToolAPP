//
//  HGBCustomKeyBord.m
//  二维码条形码识别
//
//  Created by huangguangbao on 2017/6/9.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCustomKeyBord.h"
#import "HGBNumKeyBord.h"
#import "HGBWordKeyBord.h"
#import "HGBNumOnlyKeyBord.h"
#import "HGBSymbolKeyBord.h"
#import "HGBCustomKeyBordHeader.h"

#import "HGBKeyboard3DESUtil.h"
#import "HGBKeyboardDESUtil.h"
#import "HGBKeyboardAES128Util.h"
#import "HGBKeybordTTAlgorithmSM4.h"
#import "HGBKeybordMD5.h"


@interface HGBCustomKeyBord()<HGBWordKeyboardDelegate,HGBNumKeyboardDelegate,HGBSymbolKeyBordDelegate,HGBNumOnlyKeyBordDelegate>
/**
 相应
 */
@property (nonatomic, weak)   UITextField *responder;
/**
 纯数字键盘
 */
@property (nonatomic, strong) HGBNumOnlyKeyBord    *numOnlyPad;

/**
 数字键盘
 */
@property (nonatomic, strong) HGBNumKeyBord    *numPad;

/**
 字母键盘
 */
@property (nonatomic, strong) HGBWordKeyBord   *wordPad;
/**
 符号键盘
 */
@property (nonatomic, strong) HGBSymbolKeyBord   *symbolPad;
/**
 弹出视图
 */
@property(strong,nonatomic)UIView *backView;
/**
 标题
 */
@property(strong,nonatomic)UIView *titleView;
/**
 输入显示
 */
@property(strong,nonatomic)UILabel *showLabel;



/**
 弹出标志
 */
@property(assign,nonatomic)BOOL popFlag;


/**
 背景按钮
 */
@property(strong,nonatomic)UIButton *backButton;

/**
 键盘位置
 */
@property(assign,nonatomic)CGFloat keybordy;

/**
 键盘尺寸
 */
@property(assign,nonatomic)CGRect keybordFrame;
/**
 键盘尺寸
 */
@property(assign,nonatomic)CGRect mainKeybordFrame;

/**
 输入字符串
 */
@property(strong,nonatomic)NSString *value;
@end

@implementation HGBCustomKeyBord
static  HGBCustomKeyBord *obj = nil;
#pragma mark init
+(instancetype)instance{
    CGRect frame;
    if(kWidth<kHeight){
        frame=CGRectMake(0, 0,kWidth,kWidth*0.576+72*hScale+2);
    }else{
        frame=CGRectMake(0, 0,kHeight*0.8,kHeight*0.8*0.576+72*hScale+2);
    }
    HGBCustomKeyBord *keyboard=[[HGBCustomKeyBord alloc]initWithFrame:frame];
    return keyboard;
}
- (instancetype)init{
    self.keybordy=72*hScale+2;
    CGRect frame;
    if(kWidth<kHeight){
        frame=CGRectMake(0, 0,kWidth,kWidth*0.576+72*hScale+2);
    }else{
        frame=CGRectMake(0, 0,kHeight*0.8,kHeight*0.8*0.576+72*hScale+2);
    }
    self = [self initWithFrame:frame];
    if (self) {
        self.keybordy=72*hScale+2;
    }
    obj=self;
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:209.0/256 green:214.0/256 blue:218.0/256 alpha:153.0/256];

        self.keybordy=72*hScale+2;

        //        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        HGBNumKeyBord *numPad = [[HGBNumKeyBord alloc] initWithFrame:self.mainKeybordFrame];
        numPad.tag=10;
        numPad.delegate = self;
        self.numPad = numPad;
        [self addSubview:numPad];
        [self setTitleView];
    }
    return self;
}
-(void)setKeybordType:(HGBCustomKeyBordType)keybordType{
    _keybordType=keybordType;
    [self.numPad removeFromSuperview];
    if(_keybordType==HGBCustomKeyBordType_NumWord){
        self.numPad.random=self.random;
        self.numPad.delegate=self;
        [self addSubview:self.numPad];
        [self.wordPad removeFromSuperview];
        [self.symbolPad removeFromSuperview];
        [self.numOnlyPad removeFromSuperview];

    }else if(_keybordType==HGBCustomKeyBordType_WordNum){
        self.wordPad.random=self.random;
        self.wordPad.delegate=self;
        [self addSubview:self.wordPad];
        [self.numPad removeFromSuperview];
        [self.symbolPad removeFromSuperview];
        [self.numOnlyPad removeFromSuperview];
    }else if(_keybordType==HGBCustomKeyBordType_Num){
        self.numOnlyPad.random=self.random;
        self.numOnlyPad.delegate=self;
        [self addSubview:self.numOnlyPad];
        [self.numPad removeFromSuperview];
        [self.symbolPad removeFromSuperview];
        [self.wordPad removeFromSuperview];
    }else if(_keybordType==HGBCustomKeyBordType_NumWordSymbol){
        self.numPad.random=self.random;
        self.numPad.delegate=self;
        [self addSubview:self.numPad];
        [self.wordPad removeFromSuperview];
        [self.symbolPad removeFromSuperview];
        [self.numOnlyPad removeFromSuperview];
    }else if(_keybordType==HGBCustomKeyBordType_Word){
        self.wordPad.random=self.random;
        self.wordPad.delegate=self;
        [self addSubview:self.wordPad];
        [self.numPad removeFromSuperview];
        [self.symbolPad removeFromSuperview];
        [self.numOnlyPad removeFromSuperview];

    }else if (keybordType==HGBCustomKeyBordType_WordNumSymbol){
        self.wordPad.random=self.random;
        self.wordPad.delegate=self;
        [self addSubview:self.wordPad];
        [self.numPad removeFromSuperview];
        [self.symbolPad removeFromSuperview];
        [self.numOnlyPad removeFromSuperview];
    }

}
-(HGBNumOnlyKeyBord *)numOnlyPad{
    if(!_numOnlyPad){
        _numOnlyPad=[[HGBNumOnlyKeyBord alloc] initWithFrame:self.mainKeybordFrame];
        _numOnlyPad.tag=10;

        if (self.random) _numOnlyPad.random = self.random;

    }
    _numOnlyPad.delegate=self;
    _numOnlyPad.frame=self.mainKeybordFrame;
    return _numOnlyPad;
}
- (HGBNumKeyBord *)numPad{
    if (!_numPad) {
        _numPad = [[HGBNumKeyBord alloc] initWithFrame:self.mainKeybordFrame];
        _numPad.tag=10;
        if (self.random) _numPad.random = self.random;


    }
    _numPad.delegate = self;
    _numPad.keybordType=self.keybordType;
    _numPad.frame=self.mainKeybordFrame;
    return _numPad;
}
- (HGBWordKeyBord *)wordPad{
    if (!_wordPad) {
        _wordPad = [[HGBWordKeyBord alloc] initWithFrame:self.mainKeybordFrame];
        _wordPad.tag=10;
        if (self.random) _wordPad.random = self.random;


    }
    _wordPad.delegate = self;
    _wordPad.keybordType=self.keybordType;
    _wordPad.frame=self.mainKeybordFrame;
    return _wordPad;
}
-(HGBSymbolKeyBord *)symbolPad{
    if(!_symbolPad){
        _symbolPad = [[HGBSymbolKeyBord alloc] initWithFrame:self.mainKeybordFrame];
        _symbolPad.tag=10;
        if (self.random) _symbolPad.random = self.random;


    }
    _symbolPad.delegate = self;
    _symbolPad.keybordType=self.keybordType;
    _symbolPad.frame=self.mainKeybordFrame;
    return _symbolPad;
}
- (UITextField *)responder{
    //    if (!_responder) {  // 防止多个输入框采用同一个inputview
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow valueForKey:@"firstResponder"];
    _responder = (UITextField *)firstResponder;
    //    _responder
    //    }
    return _responder;
}
#pragma mark pop
/**
 弹出键盘
 @param parent 父控制器
 */
-(void)popKeyBordInParent:(UIViewController *)parent{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self popKeyBordWithType:self.keybordShowType inParent:parent];
}
- (void)keyboardWillHide:(NSNotification *)notification {

    [self disappearSwitchBtnClickWithBlock:^{

    }];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];

}
/**
 弹出键盘
 
 @param showType 弹出类型
 @param parent 父控制器
 */
-(void)popKeyBordWithType:(HGBCustomKeyBordShowType)showType inParent:(UIViewController *)parent{
    
    self.keybordShowType=showType;
    self.popFlag=YES;
    if([obj superview]){
        return;
    }

    
    self.backButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.backButton.frame=parent.view.frame;
    [self.backButton addTarget:self action:@selector(backButtonHandle:) forControlEvents:(UIControlEventTouchDown)];
    [parent.view addSubview:self.backButton];
    
    self.backView=[[UIView alloc]init];
    self.backView.backgroundColor = [UIColor colorWithRed:209.0/256 green:214.0/256 blue:218.0/256 alpha:153.0/256];
    CGRect backFrame=CGRectZero;
    CGRect selfFrame=self.frame;

    backFrame=self.frame;
    selfFrame=self.frame;
    self.keybordy=self.keybordy;
    [self.backView addSubview:self];
    if(self.keybordShowType==HGBCustomKeyBordShowType_EncryptDone||self.keybordShowType==HGBCustomKeyBordShowType_CommonDone){

        self.showLabel=[[UILabel alloc]initWithFrame:CGRectMake(15*wScale, 0, kWidth-30*wScale, 72*hScale)];
        self.showLabel.backgroundColor=[UIColor whiteColor];
        self.showLabel.layer.masksToBounds=YES;
//        self.showLabel.layer.borderWidth=1;
//        self.showLabel.layer.borderColor=[[UIColor lightGrayColor]CGColor];
        self.showLabel.textColor=[UIColor blackColor];
    }
    

    backFrame.origin.y=kHeight;
    self.backView.frame=backFrame;
    self.backView.userInteractionEnabled=YES;




    [UIView animateWithDuration:0.2 animations:^{
        self.backView.frame=CGRectMake(0,kHeight-self.backView.frame.size.height, self.keybordFrame.size.width,self.backView.frame.size.height);



    }];
    [parent.view addSubview:self.backView];

    obj=self;
    
    obj=self;

}
#pragma mark 转换类delegte
- (void)keyboardNumPadDidClickSwitchBtn:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"ABC"]) {
        self.wordPad.random=self.random;
        [self addSubview:self.wordPad];
        [self.numPad removeFromSuperview];
        [self.symbolPad removeFromSuperview];
    }else{
        self.symbolPad.random=self.random;
        [self addSubview:self.symbolPad];
        [self.numPad removeFromSuperview];
        [self.wordPad removeFromSuperview];
    }
}
- (void)keyboardWordPadDidClickSwitchBtn:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"123"]) {
        self.numPad.random=self.random;
        [self addSubview:self.numPad];
        [self.wordPad removeFromSuperview];
        [self.symbolPad removeFromSuperview];
    }else{
        self.symbolPad.random=self.random;
        [self addSubview:self.symbolPad];
        [self.numPad removeFromSuperview];
        [self.wordPad removeFromSuperview];
    }
}
-(void)keyboardOnlyNumPadDidClickSwitchBtn:(UIButton *)btn{
    
}
-(void)keyboardSymbolPadDidClickSwitchBtn:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"123"]) {
        self.numPad.random=self.random;
        [self addSubview:self.numPad];
        [self.wordPad removeFromSuperview];
        [self.symbolPad removeFromSuperview];
    }else{
        self.wordPad.random=self.random;
        [self addSubview:self.wordPad];
        [self.numPad removeFromSuperview];
        [self.symbolPad removeFromSuperview];
    }
}
#pragma mark 数据传输
-(void)keyboardOnlyNumPadReturnMessage:(NSString *)message{
    [self keyboardDidReturnMessage:message];
}
-(void)keyboardNumPadReturnMessage:(NSString *)message{
    [self keyboardDidReturnMessage:message];
}
-(void)keyboardWordPadReturnMessage:(NSString *)message{
   [self keyboardDidReturnMessage:message];
}
-(void)keyboardSymbolPadReturnMessage:(NSString *)message{
    [self keyboardDidReturnMessage:message];
}
-(void)keyboardDidReturnMessage:(NSString *)message{
    if(self.keybordShowType==HGBCustomKeyBordShowType_InTime){
        if(self.delegate&&[self.delegate respondsToSelector:@selector(customKeybord:didReturnMessage:)]){
            [self.delegate customKeybord:self didReturnMessage:[self encryptMessage:message]];
        }
    }else if (self.keybordShowType==HGBCustomKeyBordShowType_EncryptDone){
        if(![self.showLabel superview]){
            [self.titleView addSubview:self.showLabel];
        }
        if([message isEqualToString:@"ok"]){
            if(self.delegate&&[self.delegate respondsToSelector:@selector(customKeybord:didReturnMessage:)]){
                [self.delegate customKeybord:self didReturnMessage:[self encryptMessage:self.value]];
            }

        }else if ([message isEqualToString:@"del"]){
            if (self.value.length>0) {
                self.value=[self.value substringToIndex:self.value.length-1];

            }else{
                self.value=@"";
            }
            NSString *point=@"";
            for(int i=0;i<self.value.length;i++){
                point=[point stringByAppendingString:@"●"];
            }

           self.showLabel.text=point;
        }else if ([message isEqualToString:@"dels"]){
            self.value=@"";
            self.showLabel.text=@"";
        }else{
            self.value=[self.value stringByAppendingString:message];
            NSString *point=@"";
            for(int i=0;i<self.value.length;i++){
                point=[point stringByAppendingString:@"●"];
            }
            self.showLabel.text=point;
        }
    }else if (self.keybordShowType==HGBCustomKeyBordShowType_CommonDone){
        if(![self.showLabel superview]){
            [self.titleView addSubview:self.showLabel];
        }
        if([message isEqualToString:@"ok"]){
            if(self.delegate&&[self.delegate respondsToSelector:@selector(customKeybord:didReturnMessage:)]){
                [self.delegate customKeybord:self didReturnMessage:[self encryptMessage:self.value]];
            }

        }else if ([message isEqualToString:@"del"]){
            if (self.value.length>0) {
                self.value=[self.value substringToIndex:self.value.length-1];

            }else{
                self.value=@"";
            }
            self.showLabel.text=self.value;
        }else if ([message isEqualToString:@"dels"]){
            self.value=@"";
            self.showLabel.text=@"";
        }else{
            self.value=[self.value stringByAppendingString:message];
            self.showLabel.text=self.value;
        }
    }
    if([self.showLabel superview]){
        if(self.showLabel.text.length==0){
            [self.showLabel removeFromSuperview];
        }
    }


    if([message isEqualToString:@"ok"]){
        if([self.backButton superview]){
            [self.backButton removeFromSuperview];
        }
        [UIView animateWithDuration:0.2 animations:^{
            if([self.backView superview]){
                self.backView.frame=CGRectMake(0,kHeight, kWidth,self.backView.frame.size.height);
            }

        } completion:^(BOOL finished) {
            if([self.backView superview]){
                [self.backView removeFromSuperview];
            }
            obj=nil;
        }];

        [[UIApplication sharedApplication].keyWindow endEditing:YES];

    }

}
#pragma mark 设置
- (void)setRandom:(BOOL)random{
    _random = random;
    self.numPad.random = random;
    self.wordPad.random=random;
    self.numOnlyPad.random=random;
    self.symbolPad.random=random;
}
-(void)layoutSubviews{
    [super layoutSubviews];
   
    self.numPad.random=self.random;
    self.wordPad.random=self.random;
}
#pragma mark 加密设置
/**
 加密

 @param message 消息
 @return 加密后消息
 */
-(NSString *)encryptMessage:(NSString *)message{
    NSString *msg=[message copy];
    if(self.encryptKey&&self.encryptKey.length!=0){
        if(self.keybordEncryptType==HGBCustomKeyBordEncryptType_DES){
            msg=[HGBKeyboardDESUtil DESEncryptString:message andWithKey:self.encryptKey];
        }else if (self.keybordEncryptType==HGBCustomKeyBordEncryptType_3DES){
            msg=[HGBKeyboard3DESUtil DES3EncryptString:message andWithKey:self.encryptKey];

        }else if (self.keybordEncryptType==HGBCustomKeyBordEncryptType_AES128){
            msg=[HGBKeyboardAES128Util AES128EncryptString:message andWithKey:self.encryptKey];

        }else if (self.keybordEncryptType==HGBCustomKeyBordEncryptType_TTAlgorithmSM4){
            HGBKeybordTTAlgorithmSM4 *sm4=[HGBKeybordTTAlgorithmSM4 ecbSM4WithKey:self.encryptKey];
            msg=[sm4 encryption:message];


        }else if (self.keybordEncryptType==HGBCustomKeyBordEncryptType_MD532UP){
            msg=[HGBKeybordMD5 MD5ForUpper32Bate:message];


        }else if (self.keybordEncryptType==HGBCustomKeyBordEncryptType_MD532LOW){
            msg=[HGBKeybordMD5 MD5ForLower32Bate:message];


        }else if (self.keybordEncryptType==HGBCustomKeyBordEncryptType_MD516UP){
           msg=[HGBKeybordMD5 MD5ForUpper16Bate:message];


        }else if (self.keybordEncryptType==HGBCustomKeyBordEncryptType_MD516LOW){
            msg=[HGBKeybordMD5 MD5ForLower16Bate:message];


        }else{
            msg=message;
        }
    }else{
        msg=message;
    }
    return msg;
}
#pragma mark 解密
/**
 解密

 @param message 消息
 @return 解密后消息
 */
-(NSString *)decryptMessage:(NSString *)message{
    NSString*msg= [HGBCustomKeyBord decryptMessage:message andWithKey:self.encryptKey andWithEncryptType:(self.keybordEncryptType)];
    return msg;
}
/**
 解密

 @param message 信息
 @param key 秘钥
 @param encryptType 加密类型
 @return 解密后信息
 */
+(NSString *)decryptMessage:(NSString *)message andWithKey:(NSString *)key andWithEncryptType:(HGBCustomKeyBordEncryptType)encryptType{
    NSString *msg=[message copy];
    if(key&&key.length!=0){
        if(encryptType==HGBCustomKeyBordEncryptType_DES){
            msg=[HGBKeyboardDESUtil DESDecryptString:message andWithKey:key];
        }else if (encryptType==HGBCustomKeyBordEncryptType_3DES){
            msg=[HGBKeyboard3DESUtil DES3DecryptString:message andWithKey:key];

        }else if (encryptType==HGBCustomKeyBordEncryptType_AES128){
            msg=[HGBKeyboardAES128Util AES128DecryptString:message andWithKey:key];


        }else if (encryptType==HGBCustomKeyBordEncryptType_TTAlgorithmSM4){
            HGBKeybordTTAlgorithmSM4 *sm4=[HGBKeybordTTAlgorithmSM4 ecbSM4WithKey:key];
            msg=[sm4 decryption:message];


        }else{
            msg=message;
        }
    }else{
        msg=message;
    }
    return msg;
}
#pragma mark 设置标题
-(void)setTitleView{
    
     NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    self.titleView=[[UIView alloc]initWithFrame:CGRectMake(0,2, kWidth, 72*hScale)];
    self.titleView.backgroundColor=[UIColor whiteColor];
    UIImageView *promptImageView=[[UIImageView alloc]initWithFrame:CGRectMake(24*wScale, 21*hScale, 30*wScale, 30*hScale)];
    NSString *icon = [[infoDictionary valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    UIImage *image=[UIImage imageNamed:icon];
    if(!image){
        image=[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/prompt"];
    }
    promptImageView.image=image;
   
    [self.titleView addSubview:promptImageView];
    
    UILabel *promptLabel=[[UILabel alloc]initWithFrame:CGRectMake(68*wScale, 24*hScale, kWidth-120*wScale, 24*hScale)];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    promptLabel.text=@"安全输入";
    if(app_Name&&app_Name.length>0){
        promptLabel.text=[NSString stringWithFormat:@"%@安全输入",app_Name];
    }
    promptLabel.textColor=[UIColor colorWithRed:102.0/256 green:102.0/256 blue:102.0/256 alpha:256.0/256];
    promptLabel.font=[UIFont systemFontOfSize:24*hScale];
    [self.titleView addSubview:promptLabel];
    
    UIButton *disappearSwitchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    disappearSwitchBtn.frame=CGRectMake(CGRectGetMaxX(self.titleView.frame)-100*wScale, 15*hScale, 85*wScale, 42*hScale);
    [disappearSwitchBtn addTarget:self action:@selector(disappearSwitchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [disappearSwitchBtn setImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/icon_keyword"] forState:(UIControlStateNormal)];
    [disappearSwitchBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtn"] forState:UIControlStateNormal];
    [disappearSwitchBtn setBackgroundImage:[UIImage imageNamed:@"HGBCustomKeyBordBundle.bundle/keypadBtnHighLighted"] forState:UIControlStateHighlighted];
    
    disappearSwitchBtn.tag =10;
    [self.titleView addSubview:disappearSwitchBtn];
    
    
    
    if(![self.titleView superview]){
        [self addSubview:self.titleView];
    }
}
-(void)disappearSwitchBtnClick{
    [self disappearSwitchBtnClickWithBlock:^{
        
    }];
}
- (void)disappearSwitchBtnClickWithBlock:(CompleteBlock)completeBlock{
    AudioServicesPlaySystemSound(SOUNDID);
    BOOL canReturn = YES;
    if ([self.responder respondsToSelector:@selector(textFieldShouldReturn:)]) {
        canReturn = [self.responder.delegate textFieldShouldReturn:self.responder];
    }
    if(self.delegate&&[self.delegate respondsToSelector:@selector(customKeybord:didReturnMessage:)]){
        [self.delegate customKeybord:self didReturnMessage:@"ok"];
    }


    if([self.backButton superview]){
        [self.backButton removeFromSuperview];
    }
    [UIView animateWithDuration:0.2 animations:^{
        if([self.backView superview]){
            self.backView.frame=CGRectMake(0,kHeight, kWidth,self.backView.frame.size.height);
        }
    } completion:^(BOOL finished) {
        if([self.backView superview]){
            [self.backView removeFromSuperview];
        }
    }];
    completeBlock();
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    obj=nil;
    
}
-(void)backButtonHandle:(UIButton *)_b{
    [self disappearSwitchBtnClick];
}
#pragma mark get
-(NSString *)value{
    if (_value==nil) {
        _value=@"";
    }
    return _value;
}
-(CGRect)keybordFrame{
    CGRect frame;
    if(kWidth<kHeight){
        frame=CGRectMake(0, 0,kWidth,kWidth*0.576+72*hScale+2);
    }else{
        frame=CGRectMake(0, 0,kHeight*0.8,kHeight*0.8*0.576+72*hScale+2);
    }
    return frame;

}
-(CGRect)mainKeybordFrame{
    CGRect frame;
    if(kWidth<kHeight){
        frame=CGRectMake(0,self.keybordy, kWidth,self.keybordFrame.size.height-self.keybordy);
    }else{
        frame=CGRectMake(0,self.keybordy, kHeight*0.8,self.keybordFrame.size.height-self.keybordy);
    }
    return frame;
}
@end
