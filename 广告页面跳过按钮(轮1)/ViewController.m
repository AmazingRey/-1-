//
//  ViewController.m
//  广告页面跳过按钮(轮1)
//
//  Created by ss on 16/9/8.
//  Copyright © 2016年 Legend. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic, strong) UIButton    *jumpButton;
@property (nonatomic, strong) UIButton    *backButton;
@end

@implementation ViewController
{
    BOOL    isShowingADImage;
    int64_t showADTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    showADTime = 10;
    [self.view addSubview:self.imageView];
    [self.imageView addSubview:self.backButton];
    [self.imageView addSubview:self.jumpButton];
    [self showingADImageView];
}

- (void)showingADImageView{
    isShowingADImage = true;
    [NSThread detachNewThreadSelector:@selector(intervalTimerToHideADImageInNewthread) toTarget:self withObject:nil];
    NSLog(@"runloop start");
    while (isShowingADImage) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    NSLog(@"runloop end.");
    [self.jumpButton removeFromSuperview];
    [self.backButton removeFromSuperview];
    [self.imageView removeFromSuperview];
}

- (void)intervalTimerToHideADImageInNewthread{
    sleep((unsigned)showADTime-1);
    [self performSelectorOnMainThread:@selector(setEnd) withObject:nil waitUntilDone:NO];
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _imageView.image = [UIImage imageNamed:@"跑车"];
        _imageView.backgroundColor = [UIColor blackColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = self.view.bounds;
        _backButton.backgroundColor = [UIColor clearColor];
        [_backButton addTarget:self action:@selector(tapBackAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)jumpButton{
    if (!_jumpButton) {
        _jumpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_jumpButton addTarget:self action:@selector(tapJumpAction:) forControlEvents:UIControlEventTouchUpInside];
        _jumpButton.frame = CGRectMake(self.view.frame.size.width - 100, 30, 65, 30);
        _jumpButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
        _jumpButton.layer.cornerRadius = 8;
        _jumpButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _jumpButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        NSString *jumpText = [NSString stringWithFormat:@"跳过 %lld",showADTime];
        [_jumpButton setTitle:jumpText forState:UIControlStateNormal];
        [NSTimer scheduledTimerWithTimeInterval:1.f
                                         target:self
                                       selector:@selector(decreaseADTime)
                                       userInfo:nil
                                        repeats:true];
    }
    return _jumpButton;
}

- (void)tapJumpAction:(UIButton *)button{
    [self setEnd];
}

- (void)tapBackAction:(UIButton *)button{
    [self setEnd];
    UIWebView *webView  = [[UIWebView alloc]init];
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"www.baidu.com"]]];
    [self.view addSubview:webView];
}

- (void)setEnd{
    isShowingADImage = false;
}

- (void)decreaseADTime{
    showADTime--;
    if (showADTime < 0) {
        showADTime = 0;
    }
    NSString *jumpText = [NSString stringWithFormat:@"跳过 %lld",showADTime];
    [_jumpButton setTitle:jumpText forState:UIControlStateNormal];
}

@end