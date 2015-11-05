//
//  SettingsViewController.m
//  SchoolApp
//
//  Created by Léo Brossault on 07/04/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import "SettingsViewController.h"
#import "HomeViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *settingsStrat1;
@property (weak, nonatomic) IBOutlet UIImageView *settingsStrat2;
@property (weak, nonatomic) IBOutlet UIImageView *settingsStrat3;
@property (weak, nonatomic) IBOutlet UIImageView *settingsStrat4;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.checkBoxAnim.layer.borderWidth = 1.0f;
    self.checkBoxAnim.layer.borderColor = [UIColor colorWithRed:0.827 green:0.455 blue:0.455 alpha:1].CGColor;
    self.checkBoxAnim.layer.cornerRadius = 20;
    
    self.checkBoxSound.layer.borderWidth = 1.0f;
    self.checkBoxSound.layer.borderColor = [UIColor colorWithRed:0.827 green:0.455 blue:0.455 alpha:1].CGColor;
    self.checkBoxSound.layer.cornerRadius = 20;
    
    UISwipeGestureRecognizer *oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(oneFingerSwipeRight:)] ;
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:oneFingerSwipeRight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"homeFromSettings"]){
        HomeViewController *controller = (HomeViewController *)segue.destinationViewController;
        controller.myPupil = self.myPupil;
        controller.myBook = self.myBook;
        controller.team = self.team;
    }
}


- (void)oneFingerSwipeRight:(UITapGestureRecognizer *)sender {
    [self animateStrat1: @"right"];
    [self animateStrat2: @"right"];
    [self animateStrat3: @"right"];
    [self animateStrat4: @"right"];
    [self performSegueWithIdentifier:@"homeFromSettings" sender:sender];
}

//- (BOOL)shouldAutorotate {
//    return NO;
//}

- (void) animateStrat1:(NSString *)direction {
    CGPoint origin = self.settingsStrat1.center;
    CGPoint target;
    
    if ([direction isEqualToString:@"left"]) {
        target = CGPointMake(self.settingsStrat1.center.x-500, self.settingsStrat1.center.y);
        
    } else {
        target = CGPointMake(self.settingsStrat1.center.x+500, self.settingsStrat1.center.y);
    }
    
    CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.x"];
    [bounce setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.86 :-0.53 :.21 :1.37]];
    bounce.duration = 2.5;
    bounce.fromValue = [NSNumber numberWithInt:origin.x];
    bounce.toValue = [NSNumber numberWithInt:target.x];
    bounce.autoreverses = NO;
    [self.settingsStrat1.layer addAnimation:bounce forKey:@"position"];
}

- (void) animateStrat2:(NSString *)direction {
    CGPoint origin = self.settingsStrat2.center;
    CGPoint target;
    
    if ([direction isEqualToString:@"left"]) {
        target = CGPointMake(self.settingsStrat2.center.x-500, self.settingsStrat2.center.y);
        
    } else {
        target = CGPointMake(self.settingsStrat2.center.x+500, self.settingsStrat2.center.y);
    }
    
    CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.x"];
    [bounce setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.86 :-0.53 :.21 :1.37]];
    bounce.duration = 2.5;
    [bounce setBeginTime:CACurrentMediaTime()+.2];
    bounce.fromValue = [NSNumber numberWithInt:origin.x];
    bounce.toValue = [NSNumber numberWithInt:target.x];
    bounce.autoreverses = NO;
    [self.settingsStrat2.layer addAnimation:bounce forKey:@"position"];
}

- (void) animateStrat3:(NSString *)direction {
    CGPoint origin = self.settingsStrat3.center;
    CGPoint target;
    
    if ([direction isEqualToString:@"left"]) {
        target = CGPointMake(self.settingsStrat3.center.x-500, self.settingsStrat3.center.y);
        
    } else {
        target = CGPointMake(self.settingsStrat3.center.x+500, self.settingsStrat3.center.y);
    }
    
    CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.x"];
    [bounce setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.86 :-0.53 :.21 :1.37]];
    bounce.duration = 2;
    [bounce setBeginTime:CACurrentMediaTime()+.5];
    bounce.fromValue = [NSNumber numberWithInt:origin.x];
    bounce.toValue = [NSNumber numberWithInt:target.x];
    bounce.autoreverses = NO;
    [self.settingsStrat3.layer addAnimation:bounce forKey:@"position"];
}

- (void) animateStrat4:(NSString *)direction {
    CGPoint origin = self.settingsStrat4.center;
    CGPoint target;
    
    if ([direction isEqualToString:@"left"]) {
        target = CGPointMake(self.settingsStrat4.center.x-500, self.settingsStrat4.center.y);
        
    } else {
        target = CGPointMake(self.settingsStrat4.center.x+500, self.settingsStrat4.center.y);
    }
    
    CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.x"];
    [bounce setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.86 :-0.53 :.21 :1.37]];
    bounce.duration = 1.5;
    [bounce setBeginTime:CACurrentMediaTime()+1];
    bounce.fromValue = [NSNumber numberWithInt:origin.x];
    bounce.toValue = [NSNumber numberWithInt:target.x];
    bounce.autoreverses = NO;
    [self.settingsStrat4.layer addAnimation:bounce forKey:@"position"];
}


@end
