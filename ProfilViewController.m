//
//  ProfilViewController.m
//  SchoolApp
//
//  Created by Léo Brossault on 07/04/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import "ProfilViewController.h"
#import "TeamViewController.h"
#import "HomeViewController.h"

@interface ProfilViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profilStrat1;
@property (weak, nonatomic) IBOutlet UIImageView *profilStrat2;
@property (weak, nonatomic) IBOutlet UIImageView *profilStrat3;
@property (weak, nonatomic) IBOutlet UIImageView *profilStrat4;
@property (weak, nonatomic) IBOutlet UIView *btnSuccessView;
@property (weak, nonatomic) IBOutlet UIView *btnWordsBagView;
@property (weak, nonatomic) IBOutlet UIView *wordsBagView;
@property (weak, nonatomic) IBOutlet UIView *successView;
@property (weak, nonatomic) IBOutlet UIImageView *imgWordsBag;
@property (weak, nonatomic) IBOutlet UIImageView *imgSuccess;
@property (weak, nonatomic) IBOutlet UILabel *myName;
@property (weak, nonatomic) IBOutlet UITableView *tableWords;


@end

@implementation ProfilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myName.text = [NSString stringWithFormat:@"%@ %@", self.myPupil.firstName, self.myPupil.lastName];
    self.wordsSection = [NSArray arrayWithObjects: @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    
    /* INIT BUTTON VIEW */
    self.successBottomBorder = [[UIView alloc] init];
    self.successBottomBorder.backgroundColor = [UIColor colorWithRed:0.722 green:0.278 blue:0.357 alpha:1];
    self.successBottomBorder.frame = CGRectMake(0, self.btnSuccessView.frame.size.height - 5.0, self.btnSuccessView.frame.size.width, 5.0f);
    [self.btnSuccessView addSubview: self.successBottomBorder];
    
    self.wordsBottomBorder = [[UIView alloc] init];
    self.wordsBottomBorder.backgroundColor = [UIColor colorWithRed:0.953 green:0.906 blue:0.906 alpha:1];
    self.wordsBottomBorder.frame = CGRectMake(0, self.btnWordsBagView.frame.size.height - 5.0, self.btnWordsBagView.frame.size.width, 5.0f);
    [self.btnWordsBagView addSubview: self.wordsBottomBorder];
    
    UITapGestureRecognizer *goSuccess = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tab:)];
    [goSuccess setNumberOfTapsRequired: 1];
    [self.btnSuccessView addGestureRecognizer:goSuccess];
    
    UITapGestureRecognizer *goWords = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tab:)];
    [goWords setNumberOfTapsRequired: 1];
    [self.btnWordsBagView addGestureRecognizer:goWords];
    
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
    
    self.section = [[NSMutableDictionary alloc] init];
    BOOL found;
    
    for (NSString *temp in self.myPupil.wordsBag) {
        NSString *c = [temp substringToIndex:1];
        
        found = NO;
        
        for (NSString *str in [self.section allKeys]) {
            if ([str isEqualToString:c]) {
                found = YES;
            }
        }
        
        if (!found) {
            [self.section setValue:[[NSMutableArray alloc] init] forKey:c];
        }
    }
    
    for (NSString *temp in self.myPupil.wordsBag) {
        [[self.section objectForKey:[temp substringToIndex:1]] addObject:temp];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tab:(UITapGestureRecognizer *)sender {
    UIView *selectedView = (UIView *)sender.view;
    UIImage *imageSuccess;
    UIImage *imageWords;
    if (selectedView.tag == 1) {
        imageSuccess = [UIImage imageNamed:@"team"];
        imageWords = [UIImage imageNamed:@"wordsBag_inactiv"];
        [self.imgSuccess setImage: imageSuccess];
        [self.imgWordsBag setImage: imageWords];
        
        self.successBottomBorder.backgroundColor = [UIColor colorWithRed:0.722 green:0.278 blue:0.357 alpha:1];
        self.wordsBottomBorder.backgroundColor = [UIColor colorWithRed:0.953 green:0.906 blue:0.906 alpha:1];
        
        [self.view bringSubviewToFront: self.successView];
        self.successView.hidden = false;
        self.wordsBagView.hidden = true;
    } else {
        imageSuccess = [UIImage imageNamed:@"team_inactiv"];
        imageWords = [UIImage imageNamed:@"wordsBag"];
        [self.imgSuccess setImage: imageSuccess];
        [self.imgWordsBag setImage: imageWords];
        
        self.successBottomBorder.backgroundColor = [UIColor colorWithRed:0.953 green:0.906 blue:0.906 alpha:1];
        self.wordsBottomBorder.backgroundColor = [UIColor colorWithRed:0.718 green:0.271 blue:0.361 alpha:1];
        
        [self.view bringSubviewToFront: self.wordsBagView];
        self.successView.hidden = true;
        self.wordsBagView.hidden = false;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 26;
    return [[self.section allKeys]count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.section valueForKey:[[[self.section allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == Nil) {
        cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *titleText = [[self.section valueForKey:[[[self.section allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    UILabel *wordLabel = [[UILabel alloc] init];
    [wordLabel setFrame: CGRectMake(60, 0, self.tableWords.frame.size.width, cell.frame.size.height)];
    wordLabel.text= titleText;
    wordLabel.textColor = [UIColor colorWithRed:0.494 green:0.412 blue:0.431 alpha:1];
    wordLabel.font = [UIFont fontWithName:@"Museo-300" size:20];
    
    [cell addSubview: wordLabel];
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.wordsSection;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[[self.section allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:
                                 CGRectMake(0, 0, tableView.frame.size.width, 50.0)];
    sectionHeaderView.backgroundColor = [UIColor colorWithRed:0.988 green:0.976 blue:0.976 alpha:1];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:
                            CGRectMake(20, 0, sectionHeaderView.frame.size.width, 40.0)];
    
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor colorWithRed:0.722 green:0.278 blue:0.357 alpha:1];
    [headerLabel setFont:[UIFont fontWithName:@"Museo-700" size:20.0]];
    [sectionHeaderView addSubview:headerLabel];
    
    switch (section) {
        case 0:
            headerLabel.text = @"A";
            return sectionHeaderView;
            break;
        case 1:
            headerLabel.text = @"B";
            return sectionHeaderView;
            break;
        case 2:
            headerLabel.text = @"C";
            return sectionHeaderView;
            break;
        case 3:
            headerLabel.text = @"D";
            return sectionHeaderView;
            break;
        case 4:
            headerLabel.text = @"E";
            return sectionHeaderView;
            break;
        case 5:
            headerLabel.text = @"F";
            return sectionHeaderView;
            break;
        case 6:
            headerLabel.text = @"G";
            return sectionHeaderView;
            break;
        case 7:
            headerLabel.text = @"H";
            return sectionHeaderView;
            break;
        case 8:
            headerLabel.text = @"I";
            return sectionHeaderView;
            break;
        case 9:
            headerLabel.text = @"J";
            return sectionHeaderView;
            break;
        case 10:
            headerLabel.text = @"K";
            return sectionHeaderView;
            break;
        case 11:
            headerLabel.text = @"L";
            return sectionHeaderView;
            break;
        case 12:
            headerLabel.text = @"M";
            return sectionHeaderView;
            break;
        case 13:
            headerLabel.text = @"N";
            return sectionHeaderView;
            break;
        case 14:
            headerLabel.text = @"O";
            return sectionHeaderView;
            break;
        case 15:
            headerLabel.text = @"P";
            return sectionHeaderView;
            break;
        case 16:
            headerLabel.text = @"Q";
            return sectionHeaderView;
            break;
        case 17:
            headerLabel.text = @"R";
            return sectionHeaderView;
            break;
        case 18:
            headerLabel.text = @"S";
            return sectionHeaderView;
            break;
        case 19:
            headerLabel.text = @"T";
            return sectionHeaderView;
            break;
        case 20:
            headerLabel.text = @"U";
            return sectionHeaderView;
            break;
        case 21:
            headerLabel.text = @"V";
            return sectionHeaderView;
            break;
        case 22:
            headerLabel.text = @"W";
            return sectionHeaderView;
            break;
        case 23:
            headerLabel.text = @"X";
            return sectionHeaderView;
            break;
        case 24:
            headerLabel.text = @"Y";
            return sectionHeaderView;
            break;
        case 25:
            headerLabel.text = @"Z";
            return sectionHeaderView;
            break;
        default:
            break;
    }
    
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"homeFromProfil"]){
        HomeViewController *controller = (HomeViewController *)segue.destinationViewController;
        controller.myPupil = self.myPupil;
        controller.myBook = self.myBook;
        controller.team = self.team;
    } else if ([segue.identifier isEqualToString:@"team"]) {
        TeamViewController *controller = (TeamViewController *)segue.destinationViewController;
        controller.myPupil = self.myPupil;
        controller.myBook = self.myBook;
        controller.team = self.team;
    }
}

- (void)oneFingerSwipeLeft:(UITapGestureRecognizer *)sender {
    [self animateStrat1: @"left"];
    [self animateStrat2: @"left"];
    [self animateStrat3: @"left"];
    [self animateStrat4: @"left"];
    [self performSegueWithIdentifier:@"homeFromProfil" sender:sender];
}

- (void)oneFingerSwipeRight:(UITapGestureRecognizer *)sender {
    [self animateStrat1: @"right"];
    [self animateStrat2: @"right"];
    [self animateStrat3: @"right"];
    [self animateStrat4: @"right"];
    [self performSegueWithIdentifier:@"team" sender:sender];
}

- (void) animateStrat1:(NSString *)direction {
    CGPoint origin = self.profilStrat1.center;
    CGPoint target;
    
    if ([direction isEqualToString:@"left"]) {
        target = CGPointMake(self.profilStrat1.center.x-500, self.profilStrat1.center.y);
        
    } else {
        target = CGPointMake(self.profilStrat1.center.x+500, self.profilStrat1.center.y);
    }
    
    CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.x"];
    [bounce setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.86 :-0.53 :.21 :1.37]];
    bounce.duration = 2.5;
    bounce.fromValue = [NSNumber numberWithInt:origin.x];
    bounce.toValue = [NSNumber numberWithInt:target.x];
    bounce.autoreverses = NO;
    [self.profilStrat1.layer addAnimation:bounce forKey:@"position"];
}

- (void) animateStrat2:(NSString *)direction {
    CGPoint origin = self.profilStrat2.center;
    CGPoint target;
    
    if ([direction isEqualToString:@"left"]) {
        target = CGPointMake(self.profilStrat2.center.x-500, self.profilStrat2.center.y);
        
    } else {
        target = CGPointMake(self.profilStrat2.center.x+500, self.profilStrat2.center.y);
    }
    
    CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.x"];
    [bounce setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.86 :-0.53 :.21 :1.37]];
    bounce.duration = 2.5;
    [bounce setBeginTime:CACurrentMediaTime()+.2];
    bounce.fromValue = [NSNumber numberWithInt:origin.x];
    bounce.toValue = [NSNumber numberWithInt:target.x];
    bounce.autoreverses = NO;
    [self.profilStrat2.layer addAnimation:bounce forKey:@"position"];
}

- (void) animateStrat3:(NSString *)direction {
    CGPoint origin = self.profilStrat3.center;
    CGPoint target;
    
    if ([direction isEqualToString:@"left"]) {
        target = CGPointMake(self.profilStrat3.center.x-500, self.profilStrat3.center.y);
        
    } else {
        target = CGPointMake(self.profilStrat3.center.x+500, self.profilStrat3.center.y);
    }
    
    CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.x"];
    [bounce setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.86 :-0.53 :.21 :1.37]];
    bounce.duration = 2;
    [bounce setBeginTime:CACurrentMediaTime()+.5];
    bounce.fromValue = [NSNumber numberWithInt:origin.x];
    bounce.toValue = [NSNumber numberWithInt:target.x];
    bounce.autoreverses = NO;
    [self.profilStrat3.layer addAnimation:bounce forKey:@"position"];
}

- (void) animateStrat4:(NSString *)direction {
    CGPoint origin = self.profilStrat4.center;
    CGPoint target;
    
    if ([direction isEqualToString:@"left"]) {
        target = CGPointMake(self.profilStrat4.center.x-500, self.profilStrat4.center.y);
        
    } else {
        target = CGPointMake(self.profilStrat4.center.x+500, self.profilStrat4.center.y);
    }
    
    CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.x"];
    [bounce setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.86 :-0.53 :.21 :1.37]];
    bounce.duration = 1.5;
    [bounce setBeginTime:CACurrentMediaTime()+1];
    bounce.fromValue = [NSNumber numberWithInt:origin.x];
    bounce.toValue = [NSNumber numberWithInt:target.x];
    bounce.autoreverses = NO;
    [self.profilStrat4.layer addAnimation:bounce forKey:@"position"];
}


//- (void) animateStrat4:(NSString *)direction {
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration: 0.5];
//    
//    if ([direction isEqualToString:@"left"]) {
//        [UIView animateWithDuration: 0.5 delay:0.0 options: UIViewAnimationOptionCurveLinear animations:^{
//            CGAffineTransform animStrat4 = CGAffineTransformMakeTranslation(-200, 0);
//            [self.profilStrat4 setTransform: animStrat4];
//        } completion:^(BOOL finished) {
//            NSLog(@"anim finished");
//        }];
//        
//    } else {
//        [UIView animateWithDuration: 0.5 delay:0.0 options: UIViewAnimationOptionCurveLinear animations:^{
//            CGAffineTransform animStrat4 = CGAffineTransformMakeTranslation(200, 0);
//            [self.profilStrat4 setTransform: animStrat4];
//        } completion:^(BOOL finished) {
//            NSLog(@"anim finished");
//        }];
//    }
//    
//    [UIView commitAnimations];
//}


//- (BOOL)shouldAutorotate {
//    return NO;
//}

@end
