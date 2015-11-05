//
//  HomeViewController.m
//  SchoolApp
//
//  Created by Léo Brossault on 25/03/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "SettingsViewController.h"
#import "ProfilViewController.h"
#import "BookReaderController.h"
#import "Pupils.h"
#import <RestKit/RestKit.h>


@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *textWelcome;
@property (weak, nonatomic) IBOutlet UIButton *btnContinueBook;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSManagedObjectContext *context;

@property (weak, nonatomic) IBOutlet UIImageView *homeStrat1;
@property (weak, nonatomic) IBOutlet UIImageView *homeStrat2;
@property (weak, nonatomic) IBOutlet UIImageView *homeStrat3;
@property (weak, nonatomic) IBOutlet UIImageView *homeStrat4;


@end

@implementation HomeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /* GET PUPIL FROM CORE DATA */
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    
//    NSManagedObjectContext *context = [appDelegate managedObjectContext];
//    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Pupil" inManagedObjectContext: context];
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    [request setEntity:entityDesc];
//    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:nil];
//    [request setPredicate:pred];
//    NSManagedObject *matches = nil;
//    
//    NSError *error;
//    NSArray *objects = [context executeFetchRequest:request error:&error];
//    
//    if ([objects count] == 0) {
//        NSLog(@"Aucun élèves ...");
//    } else {
//        matches = objects[0];
//    }
    
    self.textWelcome.text = [NSString stringWithFormat:@"Bonjour %@", self.myPupil.firstName];
    [self.btnContinueBook setTitle:[NSString stringWithFormat:@"Continuer \"%@\"", self.myBook.title]forState: UIControlStateNormal];
    
    /* MENU NAVIGATION */
    
    UISwipeGestureRecognizer *oneFingerSwipeLeft = [[UISwipeGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(oneFingerSwipeLeft:)] ;
    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:oneFingerSwipeLeft];
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"goToRead"]){
        BookReaderController *controller = (BookReaderController *)segue.destinationViewController;
        controller.myPupil = self.myPupil;
        controller.myBook = self.myBook;
        controller.team = self.team;
    } else if ([segue.identifier isEqualToString:@"settings"]) {
        SettingsViewController *controller = (SettingsViewController *)segue.destinationViewController;
        controller.myPupil = self.myPupil;
        controller.myBook = self.myBook;
        controller.team = self.team;
    } else if ([segue.identifier isEqualToString:@"profil"]) {
        ProfilViewController *controller = (ProfilViewController *)segue.destinationViewController;
        controller.myPupil = self.myPupil;
        controller.myBook = self.myBook;
        controller.team = self.team;
    }

}

- (void)oneFingerSwipeLeft:(UITapGestureRecognizer *)sender {
    [self animateStrat1: @"left"];
    [self animateStrat2: @"left"];
//    [self animateStrat3: @"left"];
//    [self animateStrat4: @"left"];
    [self performSegueWithIdentifier:@"settings" sender:sender];
}

- (void)oneFingerSwipeRight:(UITapGestureRecognizer *)sender {
    [self animateStrat1: @"right"];
    [self animateStrat2: @"right"];
//    [self animateStrat3: @"right"];
//    [self animateStrat4: @"right"];
    [self performSegueWithIdentifier:@"profil" sender:sender];
}

- (IBAction)continueBook:(id)sender {
    [self performSegueWithIdentifier:@"goToRead" sender:sender];
}

- (void) animateStrat1:(NSString *)direction {
    CGPoint origin = self.homeStrat1.center;
    CGPoint target;
    
    if ([direction isEqualToString:@"left"]) {
        target = CGPointMake(self.homeStrat1.center.x-500, self.homeStrat1.center.y);

    } else {
       target = CGPointMake(self.homeStrat1.center.x+500, self.homeStrat1.center.y);
    }
    
    CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.x"];
    [bounce setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.86 :-0.53 :.21 :1.37]];
    bounce.duration = 2.5;
    bounce.fromValue = [NSNumber numberWithInt:origin.x];
    bounce.toValue = [NSNumber numberWithInt:target.x];
    bounce.autoreverses = NO;
    [self.homeStrat1.layer addAnimation:bounce forKey:@"position"];
}

- (void) animateStrat2:(NSString *)direction {
    CGPoint origin = self.homeStrat2.center;
    CGPoint target;
    
    if ([direction isEqualToString:@"left"]) {
        target = CGPointMake(self.homeStrat2.center.x-500, self.homeStrat2.center.y);
        
    } else {
        target = CGPointMake(self.homeStrat2.center.x+500, self.homeStrat2.center.y);
    }
    
    CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.x"];
    [bounce setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.86 :-0.53 :.21 :1.37]];
    bounce.duration = 2.5;
    [bounce setBeginTime:CACurrentMediaTime()+.2];
    bounce.fromValue = [NSNumber numberWithInt:origin.x];
    bounce.toValue = [NSNumber numberWithInt:target.x];
    bounce.autoreverses = NO;
    [self.homeStrat2.layer addAnimation:bounce forKey:@"position"];
}

- (void) animateStrat3:(NSString *)direction {
    CGPoint origin = self.homeStrat3.center;
    CGPoint target;
    
    if ([direction isEqualToString:@"left"]) {
        target = CGPointMake(self.homeStrat3.center.x-500, self.homeStrat3.center.y);
        
    } else {
        target = CGPointMake(self.homeStrat3.center.x+500, self.homeStrat3.center.y);
    }
    
    CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.x"];
    [bounce setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.86 :-0.53 :.21 :1.37]];
    bounce.duration = 2;
    [bounce setBeginTime:CACurrentMediaTime()+.5];
    bounce.fromValue = [NSNumber numberWithInt:origin.x];
    bounce.toValue = [NSNumber numberWithInt:target.x];
    bounce.autoreverses = NO;
    [self.homeStrat3.layer addAnimation:bounce forKey:@"position"];
}

- (void) animateStrat4:(NSString *)direction {
    CGPoint origin = self.homeStrat4.center;
    CGPoint target;
    
    if ([direction isEqualToString:@"left"]) {
        target = CGPointMake(self.homeStrat4.center.x-500, self.homeStrat4.center.y);
        
    } else {
        target = CGPointMake(self.homeStrat4.center.x+500, self.homeStrat4.center.y);
    }
    
    CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.x"];
    [bounce setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.86 :-0.53 :.21 :1.37]];
    bounce.duration = 1.5;
    [bounce setBeginTime:CACurrentMediaTime()+1];
    bounce.fromValue = [NSNumber numberWithInt:origin.x];
    bounce.toValue = [NSNumber numberWithInt:target.x];
    bounce.autoreverses = NO;
    [self.homeStrat4.layer addAnimation:bounce forKey:@"position"];
}

//- (BOOL)shouldAutorotate {
//    return NO;
//}

@end
