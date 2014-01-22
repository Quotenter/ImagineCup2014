//
//  LoginViewController.m
//  SYNAPSE
//
//  Created by 青井 佑 on 2014/01/08.
//  Copyright (c) 2014年 Quotenter. All rights reserved.
//

#import "LoginViewController.h"
#import "SHA1Generator.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushedLoginButton:(id)sender {
    
    // Generate SHA-1 hash from UUID
    //NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
    //NSString *did_h = [SHA1Generator sha1WithString:[uuid UUIDString]];
    NSString *did_h = @"2222222222222222222222222222222222222222";
    
    // Send login data with POST
    NSURL *url = [NSURL URLWithString:@"http://synapse-server.cloudapp.net/Set/Login.aspx"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSString *keyValue = [NSString stringWithFormat:@"uid_h=%@&did_h=%@&pass_h=%@", [SHA1Generator sha1WithString:self.userIDField.text], did_h, [SHA1Generator sha1WithString:self.passwordField.text]];
    
    NSData *post = [keyValue dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:post];
    
    // Post data
    [NSURLConnection sendAsynchronousRequest:request  queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
    
        // Get Cookie
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"%@", httpResponse);
        //NSArray *cookies = [NSHTTPCookie ];
        NSLog(@"%@", data);
        //NSArray *cookies = [NSHTTPCookie ]
        //NSLog(@"cookies: %@", cookies);
        NSHTTPCookieStorage *storage = [ NSHTTPCookieStorage sharedHTTPCookieStorage ];
        NSArray *cookies = [ storage cookiesForURL:[ NSURL URLWithString : @"http://synapse-server.cloudapp.net/" ] ];
        
        // Cookie処理ループ
        for (NSHTTPCookie *cookie in cookies) {
            // 目的のCookieが見つかったら値を返す
            if ([ cookie.name isEqualToString: @"sid" ]) {
                NSString     *fugafuga = cookie.value;
                NSLog(@"sid=%@", fugafuga);
                //return fugafuga;
            }
        }
        /*for (NSHTTPCookie *cookie in cookies) {
            if([cookie.name isEqualToString:@"Content-Type"]) {
                NSLog(@"sid: %@", cookie.value);
            }
        }*/
        /*for (int i = 0; i < cookies.count; i++) {
            NSHTTPCookie *cookie = [cookies objectAtIndex:i];
            NSLog(@"cookie: name=%@, value=%@", cookie.name, cookie.value);
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }*/
    
    }];
    

   

}

@end
