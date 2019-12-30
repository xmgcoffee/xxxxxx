//
//  WVViewController.m
//  xxxxxx
//
//  Created by 余妙玉 on 2019/1/27.
//  Copyright © 2019年 debussy. All rights reserved.
//

#import "WVViewController.h"

@interface WVViewController ()<UIGestureRecognizerDelegate,NSURLSessionDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *wv;
@property (nonatomic, strong)UIAlertController *ac;
@end

@implementation WVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"SELF.URL :%@",self.url);
    self.url = @"https://lexr.api.2your.cn";
    NSURLRequest *r = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.wv loadRequest:r];
    [self as];
    [[self view]setTranslatesAutoresizingMaskIntoConstraints:YES];
    [[self view]setAutoresizingMask:UIViewAutoresizingNone];
//    [self vie
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)as
{
    UILongPressGestureRecognizer* longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longPressed.delegate = self;
    [self.wv addGestureRecognizer:longPressed];
}

- (void)longPressed:(UILongPressGestureRecognizer*)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint touchPoint = [recognizer locationInView:self.wv];
    
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    NSString *urlToSave = [self.wv stringByEvaluatingJavaScriptFromString:imgURL];
    
    if (urlToSave.length == 0) {
        return;
    }
    
    [self showImageOptionsWithUrl:urlToSave];
}

- (void)showImageOptionsWithUrl:(NSString *)imageUrl
{
    
    self.ac = [UIAlertController alertControllerWithTitle:@"乐小二" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ac1 = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveImageToDiskWithUrl:imageUrl];
        [_ac dismissViewControllerAnimated:YES completion:nil];

    }];
    UIAlertAction *ac2 =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [_ac dismissViewControllerAnimated:YES completion:nil];
    }];
    [_ac addAction:ac1];
    [_ac addAction:ac2];
    [self presentViewController:_ac animated:YES completion:nil];
}

- (void)saveImageToDiskWithUrl:(NSString *)imageUrl
{
    NSURL *url = [NSURL URLWithString:imageUrl];
    
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue new]];
    
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    
    NSURLSessionDownloadTask  *task = [session downloadTaskWithRequest:imgRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            return ;
        }
        
        NSData * imageData = [NSData dataWithContentsOfURL:location];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage * image = [UIImage imageWithData:imageData];
            
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        });
    }];
    
    [task resume];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        NSLog(@"保存失败");
//        [[RAProgressHUD sharedHUD] showErrorWithMessage:@"保存失败"];
    }else{
        NSLog(@"保存成功");
//        [[RAProgressHUD sharedHUD] showSuccessWithMessage:@"保存成功"];
    }
    [_ac dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

 //In a storyboard-based application, you will often want to do a little preparation before navigation

//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
//}


@end
