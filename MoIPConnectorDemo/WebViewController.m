//
//  WebViewController.m
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 14/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSString* originalTitle;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.originalTitle = self.title;
    NSURLRequest* request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];

}


#pragma mark - UIWebViewDelegate

- (void) webViewDidStartLoad:(UIWebView *)webView {
    self.title = @"Carregando...";
}


- (void) webViewDidFinishLoad:(UIWebView *)webView {
    self.title = self.originalTitle;
}


- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    self.title = self.originalTitle;
    UIAlertController* controller = [self alertControllerForLocalizedErrorMessage:error];
    [self presentViewController:controller animated:YES completion:nil];
}


#pragma mark - Helpers

- (UIAlertController*) alertControllerForLocalizedErrorMessage:(NSError*) error {
    
    NSString* message = [NSString stringWithFormat:@"%@\n\nCódigo do Erro: %ld",error.localizedDescription,(long)error.code];
    
    UIAlertController* alerController = [UIAlertController alertControllerWithTitle:@"Erro" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alerController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
    
    return alerController;
}

@end
