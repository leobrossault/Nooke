//
//  WebPageViewController.m
//  SchoolApp
//
//  Created by Léo Brossault on 18/04/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import "WebPageViewController.h"
#import "BookReaderController.h"

@interface WebPageViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backToRead;
@property (weak, nonatomic) IBOutlet UIWebView *viewWeb;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadIndicator;

@end

@implementation WebPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *fullURL = [NSString stringWithFormat:@"https://fr.vikidia.org/wiki/%@", self.paramUrl];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.loadIndicator startAnimating];
    
    [self.viewWeb loadRequest:requestObj];
    [self.viewWeb setDelegate:self];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.loadIndicator stopAnimating];
    NSLog(@"loaded");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"goReadFromWeb"]){
        BookReaderController *controller = (BookReaderController *)segue.destinationViewController;
        controller.myPupil = self.myPupil;
        controller.myBook = self.myBook;
        controller.team = self.team;
    }
}

- (IBAction)goBackToRead:(id)sender {
    [self performSegueWithIdentifier:@"goReadFromWeb" sender:sender];
}


//- (BOOL)shouldAutorotate {
//    return NO;
//}

@end
