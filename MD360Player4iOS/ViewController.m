//
//  ViewController.m
//  MD360Player4IOS
//
//  Created by ashqal on 16/3/27.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "ViewController.h"
#import "PlayerViewController.h"
#import <AFNetworking.h>
#import <AFNetworking/AFNetworking.h>


@interface ViewController(){
}
@property (nonatomic,strong) AFHTTPSessionManager* manager;
@property (weak, nonatomic) IBOutlet UIButton *mRefreshBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
}
- (IBAction)onRequestBtnClicked:(id)sender {
    [self request];
}

- (void) request{
    if (self.mRefreshBtn != nil) {
        [self.mRefreshBtn setEnabled:NO];
    }
    NSString* url = @"http://mnew14.yyport.com/videoset/video.json";
    [self.manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {}
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
             NSString* url = [dic objectForKey:@"url"];
             if (url != nil) {
                [self.mUrlTextView setText:url];
             }
             if (self.mRefreshBtn != nil) {
                 [self.mRefreshBtn setEnabled:YES];
             }
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);
             if (self.mRefreshBtn != nil) {
                 [self.mRefreshBtn setEnabled:YES];
             }
         }
     ];
}

- (IBAction)onNetworkButton:(id)sender {
    NSString* url = self.mUrlTextView.text;
    [self launch:[NSURL URLWithString:url]];
}

- (IBAction)onLocalButton:(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"skyrim360" ofType:@"mp4"];
    [self launch:[NSURL fileURLWithPath:path]];
}

- (void)launch:(NSURL*)url {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Player" bundle:nil];
    PlayerViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PlayerViewController"];
    
    [self presentViewController:vc animated:YES completion:^{
        [vc initParams:url];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
