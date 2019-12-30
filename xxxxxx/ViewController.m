//
//  ViewController.m
//  xxxxxx
//
//  Created by 余妙玉 on 2019/1/27.
//  Copyright © 2019年 debussy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tv;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _tv.text = @"https://lexr.api.2your.cn";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self performSegueWithIdentifier:@"goWebView" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender NS_AVAILABLE_IOS(5_0);
{
    UIViewController *vc = [segue destinationViewController];
    if (self.tv && [self.tv text]) {
        [vc setValue:[self.tv text] forKey:@"url"];
    }
}
@end
