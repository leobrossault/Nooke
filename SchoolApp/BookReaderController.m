//
//  BookReaderController.m
//  SchoolApp
//
//  Created by Léo Brossault on 31/03/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import "BookReaderController.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "WebPageViewController.h"
#import "TeamViewController.h"
#import "SendMessageViewController.h"

@interface BookReaderController ()

@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *progressBtn;
@property (weak, nonatomic) IBOutlet UILabel *chapter;
@property (weak, nonatomic) IBOutlet UIView *toolBar;
@property (weak, nonatomic) IBOutlet UIButton *closeOpen;
@property (weak, nonatomic) IBOutlet UIButton *btnHome;

/* DEPLOY MENU */
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet UIButton *noteButton;
@property (weak, nonatomic) IBOutlet UIButton *typoButton;

/* BOTTOM VIEW */

@property (weak, nonatomic) IBOutlet UIPickerView *pickerActivity;

@end

@implementation BookReaderController

- (id)init {
    return [super initWithNibName:@"BookReaderController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    self.chapterText = [[UITextView alloc] init];
    [self.chapterText setFrame:CGRectMake(109, 160, 550, 864)];
    [self.chapterText setTextColor:[UIColor blackColor]];
    [self.chapterText setBackgroundColor:[UIColor clearColor]];
    [self.chapterText setFont:[UIFont fontWithName:@"Museo-300" size: 21]];
    self.chapterText.editable = NO;
    self.chapterText.showsVerticalScrollIndicator = NO;
    self.chapterText.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview: self.chapterText];
    
    /* INIT */
    self.arrayClone = [[NSMutableArray alloc] initWithArray:self.myPupil.wordsBag];
    self.chapterText.delegate = self;
    readFinish = false;
    activityStarted = false;
    activityFinish = false;
    tapProgressBtn = false;
    deployMenuActiv = false;
    rotation = true;
    drag1 = false;
    drag2 = false;
    drag3 = false;
    drag4 = false;
    indexTypo = 1;
    indexDrag = 0;
    goodAnswersNb = 0;
    step = 1;
    nbTry = 0;
    self.goodAnswers = @[@"le", @"maître", @"que", @"et", @"il", @"qui", @"la", @"de"];
    
    self.pickerData = @[@"1", @"2", @"3", @"4", @"5"];
    self.pickerActivity.dataSource = self;
    self.pickerActivity.delegate = self;
    self.pickerActivity.hidden = true;
    
    /* READTIME */
    [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(addReadTime:)  userInfo:nil repeats:YES];

    /* TOOLBAR */
    [self initToolBar];
    [self initInfosZone];
    [self initActivity];
    [self initBottomView];
    [self drawProgressBar];
    [self initFinishView];

    if (self.myPupil.currentChapter != nil) {
        index = [self.myPupil.currentChapter intValue];
    } else {
        index = 0;
    }

    /* SET TEXT */
    if ([self.myBook.nbChapter intValue] > index) {
        self.chapter.text = [NSString stringWithFormat:@"%@", [[self.myBook.chapter objectAtIndex: index] objectForKey:@"titleChapter"]];
        self.chapterText.text = [NSString stringWithFormat:@"%@", [[self.myBook.chapter objectAtIndex: index] objectForKey:@"textChapter"]];
    } else {
        self.chapter.text = @"Fin du livre";
        self.chapterText.text = @"Félicitation ! Le livre est terminé !";
    }

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.chapterText.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 15;
    NSDictionary *dict = @{
        NSParagraphStyleAttributeName : paragraphStyle
    };
    [attributedString addAttributes:dict range:NSMakeRange(0, [self.chapterText.text length])];
    
    self.chapterText.attributedText = attributedString;
    self.chapterText.font = [UIFont fontWithName: @"Museo-300" size: 20.0];
    self.chapterText.textAlignment = NSTextAlignmentJustified;
    
    /* GESTURE */
    UISwipeGestureRecognizer *chapterNext = [[UISwipeGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(chapterNext:)] ;
    [chapterNext setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:chapterNext];
    
    
    UISwipeGestureRecognizer *chapterPrev = [[UISwipeGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(chapterPrev:)] ;
    [chapterPrev setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:chapterPrev];

    UILongPressGestureRecognizer *word = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(wordLongPress:)];
    [self.chapterText addGestureRecognizer:word];

    /* GET MESSAGE */
//    TeamViewController *teamController = [[TeamViewController alloc] init];
//    self.messages = [teamController getMessageFromTeam: self.myPupil.team];
//
//    for (int k = 0; k < [self.messages count]; k++) {
//        if ([[[self.messages objectAtIndex: k] objectForKey:@"isReading"] isEqualToString:@"false"] && ![[[self.messages objectAtIndex: k] objectForKey:@"author"] isEqualToString: self.myPupil._id]) {
//            self.myPupil->nbMessageNotRead ++;
//        }
//    }
//    
//    NSLog(@"Nombre de messages non lus : %d", self.myPupil->nbMessageNotRead);
    
    /* DRAG WORD */
    self.dragWord = [[UILabel alloc] init];
    [self.dragWord setFrame:CGRectMake(10, 10, 100, 20)];
    [self.view addSubview: self.dragWord];
    
    self.answer1 = [[UILabel alloc] init];
    [self.view addSubview: self.answer1];
    
    self.answer2 = [[UILabel alloc] init];
    [self.view addSubview: self.answer2];
    
    self.answer3 = [[UILabel alloc] init];
    [self.view addSubview: self.answer3];
    
    self.answer4 = [[UILabel alloc] init];
    [self.view addSubview: self.answer4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) drawProgressBar {
    /* PROGRESS BTN */
    float percent = ([self.myPupil.currentChapter floatValue]/[self.myBook.nbChapter floatValue]) * 100;
    if (activityFinish == false) {
        [self.progressBtn setBackgroundColor: [UIColor colorWithRed:0.949 green:0.894 blue:0.89 alpha:1]];
        [self.progressBtn setTitleColor:[UIColor colorWithRed:0.667 green:0.278 blue:0.357 alpha:1] forState:UIControlStateNormal];
        self.progressBtn.layer.cornerRadius = 10.0f;
        self.bar = [[UIView alloc] init];
    }
    
    [self.progressBtn setTitle:[NSString stringWithFormat:@"%ld%%", lroundf(percent)] forState:UIControlStateNormal];
    
    /* CALCUL WIDTH BAR */
    float width = (lroundf(percent) / 100.0) * 143.0 ;
    
    /* DRAW BAR */
    barFrame = self.bar.frame;
    barFrame.size.width = width;
    barFrame.size.height = 20;
    self.bar.frame = barFrame;
    self.bar.backgroundColor = [UIColor colorWithRed:0.667 green:0.278 blue:0.357 alpha:1];
    [self.progressView addSubview: self.bar];
    
    /* DRAW MASK TO MAKE CORNER RADIUS */
    UIBezierPath *maskPath;
    if (width > 130) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.progressView.bounds
                                         byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomRight)
                                               cornerRadii:CGSizeMake(10.0, 10.0)];
    } else {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.progressView.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerTopLeft)
                                           cornerRadii:CGSizeMake(10.0, 10.0)];
    }
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.progressView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.progressView.layer.mask = maskLayer;
    
    if (activityFinish == false) {
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(btnProgressChange:)];
        [self.progressView addGestureRecognizer:singleFingerTap];
        self.bar.hidden = true;
    }
}

- (IBAction)btnProgressChange:(id)sender {
    if (tapProgressBtn == false) {
        [self.progressBtn setBackgroundColor: [UIColor clearColor]];
        [[self.progressBtn layer] setBorderWidth: 1.0f];
        [[self.progressBtn layer] setBorderColor: [UIColor colorWithRed:0.969 green:0.925 blue:0.933 alpha:1].CGColor];
        [self.progressBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        tapProgressBtn = true;
        /* DRAW BAR */
        self.bar.hidden = false;
    } else {
        [self.progressBtn setBackgroundColor: [UIColor colorWithRed:0.949 green:0.894 blue:0.89 alpha:1]];
        [self.progressBtn setTitleColor:[UIColor colorWithRed:0.667 green:0.278 blue:0.357 alpha:1] forState:UIControlStateNormal];
        [[self.progressBtn layer] setBorderWidth: 0.0f];
        tapProgressBtn = false;
        self.bar.hidden = true;
    }
}

/* INIT ZONE */
- (void) initInfosZone {
    showHideInfos = false;
    
    self.infos =[[UIView alloc] init];
    self.selectedWord = [[UILabel alloc] init];
    self.btnWordBag = [[UIButton alloc] init];
    self.btnVikidia = [[UIButton alloc] init];
    self.closeInfos = [[UIButton alloc] init];
    self.defWord = [[UITextView alloc] init];
    self.btnMessageInfos = [[UIButton alloc] init];
    self.popupWordBag = [[UILabel alloc] init];
    self.plusUn = [[UILabel alloc] init];
    
    [self.closeInfos setFrame:CGRectMake(713, 10, 44, 43)];
    [self.closeInfos setBackgroundImage: [UIImage imageNamed:@"close_infos"] forState:UIControlStateNormal];
    [self.closeInfos addTarget:self action:@selector(closeZoneInfos:) forControlEvents:UIControlEventTouchDown];
    
    self.selectedWord.textColor=[UIColor colorWithRed:0.71 green:0.267 blue:0.353 alpha:1];
    [self.selectedWord setFrame:CGRectMake(64, 50, 200, 50)];
    [self.selectedWord setFont:[UIFont fontWithName: @"Museo-700" size: 22]];
    
    [self.btnWordBag setFrame:CGRectMake(272, 253, 63, 63)];
    [self.btnWordBag addTarget:self action:@selector(addWord:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnWordBag setBackgroundImage: [UIImage imageNamed:@"words_bag"] forState:UIControlStateNormal];
    [self.btnWordBag setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    
    [self.btnVikidia setFrame:CGRectMake(350, 253, 63, 63)];
    [self.btnVikidia addTarget:self action:@selector(goWeb:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnVikidia setBackgroundImage: [UIImage imageNamed:@"vikidia"] forState:UIControlStateNormal];
    [self.btnVikidia setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    
    [self.btnMessageInfos setFrame:CGRectMake(431, 253, 63, 63)];
    [self.btnMessageInfos setBackgroundImage: [UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    UITapGestureRecognizer *goMessage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMsg:)];
    [self.btnMessageInfos addGestureRecognizer:goMessage];
    
    [self.popupWordBag setFrame:CGRectMake(100, 267, 207, 33)];
    self.popupWordBag.font = [UIFont fontWithName:@"Museo-300" size: 15];
    self.popupWordBag.textColor = [UIColor colorWithRed:0.827 green:0.455 blue:0.455 alpha:1];
    self.popupWordBag.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_add_word_bag"]];
    self.popupWordBag.text = @"Déjà dans ton sac !";
    self.popupWordBag.textAlignment = NSTextAlignmentCenter;
    self.popupWordBag.hidden = true;
    
    [self.plusUn setFrame:CGRectMake(290, 260, 18, 14)];
    self.plusUn.font = [UIFont fontWithName:@"Museo-700" size: 15];
    self.plusUn.textColor = [UIColor colorWithRed:0.827 green:0.455 blue:0.455 alpha:1];
    self.plusUn.text = @"+1";
    self.plusUn.hidden = true;
    
    
    /* DEF WORD */
    [self.defWord setFrame:CGRectMake(63, 90, 630, 130)];
    [self.defWord setTextColor:[UIColor blackColor]];
    [self.defWord setBackgroundColor:[UIColor clearColor]];
    [self.defWord setFont:[UIFont fontWithName:@"Museo-300" size: 17]];
    self.defWord.editable = NO;
    
    [self.view addSubview:self.infos];
    [self.infos addSubview:self.selectedWord];
    [self.infos addSubview:self.btnWordBag];
    [self.infos addSubview:self.btnVikidia];
    [self.infos addSubview:self.defWord];
    [self.infos addSubview: self.popupWordBag];
    [self.infos addSubview:self.btnMessageInfos];
    [self.infos addSubview:self.closeInfos];
    [self.infos addSubview:self.plusUn];

    CGRect infoFrame = self.infos.frame;
    infoFrame.size.width = [[UIScreen mainScreen] bounds].size.width;
    infoFrame.size.height = 338;
    infoFrame.origin.y = 1238;
    self.infos.frame = infoFrame;
    self.infos.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_zone_infos"]];
    
    /* BORDER TOP */
    UIView *topBorder = [UIView new];
    topBorder.backgroundColor = [UIColor colorWithRed:0.933 green:0.918 blue:0.922 alpha:1];
    topBorder.frame = CGRectMake(0, 0, self.infos.frame.size.width, 1.0);
    [self.infos addSubview:topBorder];
    
    /* SHADOW */
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect: self.infos.bounds];
    self.infos.layer.masksToBounds = NO;
    self.infos.layer.shadowColor = [UIColor colorWithRed:0.961 green:0.969 blue:0.973 alpha:1].CGColor;
    self.infos.layer.shadowOffset = CGSizeMake(0.0f, -10.0f);
    self.infos.layer.shadowOpacity = 0.5f;
    self.infos.layer.shadowPath = shadowPath.CGPath;
}

/* INIT TOOLBAR */
- (void) initToolBar {
    showHide = true;
    
    UITapGestureRecognizer *showOrHideToolBar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHideToolBar:)] ;
    [[self view] addGestureRecognizer:showOrHideToolBar];
}

- (void) initBottomView {
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_bottom_view"]];
    bottomFrame = self.bottomView.frame;
    bottomFrame.size.height = 460;
    bottomFrame.size.width = self.view.frame.size.width;
    bottomFrame.origin.y = (self.view.frame.size.height);
    self.bottomView.frame = bottomFrame;
    [self.view addSubview:self.bottomView];
    self.sentenceBottom = [[UILabel alloc] init];
    self.sentenceBisBottom = [[UILabel alloc] init];
    self.icoCheck = [[UIImage alloc] init];
    
    [self.bottomView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_bottom_view"]]];
    
    [self.sentenceBottom setFrame:CGRectMake(65, 230, 650, 50)];
    self.sentenceBottom.font = [UIFont fontWithName:@"Museo-700" size: 20];
    self.sentenceBottom.textColor = [UIColor colorWithRed:0.722 green:0.278 blue:0.357 alpha:1];
    self.sentenceBottom.textAlignment = NSTextAlignmentCenter;
    self.sentenceBottom.numberOfLines = 0;
    self.sentenceBottom.lineBreakMode = NSLineBreakByWordWrapping;
    self.sentenceBottom.text = [NSString stringWithFormat: @"Pour continuer la suite des aventures de Phileas Fogg et \n Passe-Partout et découvrir le reste de l’histoire, réalise l’activité n°%d", [self.myPupil.currentChapter intValue] + 1];
    
    self.icoCheck = [UIImage imageNamed:@"check_bottom"];
    self.imageViewBottom = [[UIImageView alloc] initWithImage: self.icoCheck];
    CGRect imageFrame = self.imageViewBottom.frame;
    imageFrame.origin.x = 340;
    imageFrame.origin.y = 300;
    self.imageViewBottom.frame = imageFrame;
    
    [self.sentenceBisBottom setFrame:CGRectMake(350, 400, 68, 15)];
    self.sentenceBisBottom.font = [UIFont fontWithName:@"Museo-300" size: 13];
    self.sentenceBisBottom.textColor = [UIColor colorWithRed:0.722 green:0.278 blue:0.357 alpha:1];
    self.sentenceBisBottom.text = @"C'est parti !";
    
    [self.bottomView addSubview:self.sentenceBottom];
    [self.bottomView addSubview:self.sentenceBisBottom];
    [self.bottomView addSubview:self.imageViewBottom];
}

- (void) hideBottomView {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration: 0.8];
    CGAffineTransform bottomTranslate = CGAffineTransformMakeTranslation(0, 460);
    [self.bottomView setTransform: bottomTranslate];
    [UIView commitAnimations];
}

/* CHANGE CHAPTER */
- (void)chapterPrev:(UILongPressGestureRecognizer *)recognizer {
    self.bottomView.hidden = true;
    if (index != 0 & activityStarted == false) {
        index --;
        self.chapter.text = [NSString stringWithFormat:@"%@", [[self.myBook.chapter objectAtIndex: index] objectForKey:@"titleChapter"]];
        self.chapterText.text = [NSString stringWithFormat:@"%@", [[self.myBook.chapter objectAtIndex: index] objectForKey:@"textChapter"]];
    }
}

- (void)chapterNext:(UITapGestureRecognizer *)recognizer {
    self.bottomView.hidden = true;
    if (index + 1 < [self.myBook.nbChapter intValue] && activityStarted == false) {
        index ++;
        
        if (self.myPupil->canGoingTo >= index) {
            self.chapter.text = [NSString stringWithFormat:@"%@", [[self.myBook.chapter objectAtIndex: index] objectForKey:@"titleChapter"]];
            self.chapterText.text = [NSString stringWithFormat:@"%@", [[self.myBook.chapter objectAtIndex: index] objectForKey:@"textChapter"]];
        } else {
            index --;
        }
    }
}

/* PRESS A WORD */
- (void) wordLongPress:(UIGestureRecognizer *) sender {
    CGPoint locationToParent = [sender locationInView:self.view];
    if ( sender.state == UIGestureRecognizerStateEnded && sender.view == self.chapterText) {
        /* FIND THE WORD */
        UITextView *textView = (UITextView *)sender.view;
        CGPoint location = [sender locationInView:textView];
        UITextPosition *tapPosition = [textView closestPositionToPoint:location];
        UITextRange *textRange = [textView.tokenizer rangeEnclosingPosition:tapPosition withGranularity:UITextGranularityWord inDirection:UITextLayoutDirectionRight];
        NSString *def;
        
        if ([textView textInRange:textRange] != nil) {
            /* INIT ZONE WITH THE WORD */
            if ([textView textInRange:textRange].length > 0 && ![[textView textInRange:textRange]  isEqual: @""]) {
                if (activityStarted == false) {
                    self.selectedWord.text = [NSString stringWithFormat:@"%@", [textView textInRange:textRange]];
                    NSString *capitalized = [[[self.selectedWord.text substringToIndex:1] uppercaseString] stringByAppendingString:[self.selectedWord.text substringFromIndex:1]];
                    self.selectedWord.text = capitalized;
                
                    NSString* userAgent = @"Nook/0.8 (brossault.leo@gmail.com)";
                    NSURL *urlWiki = [NSURL URLWithString:[NSString stringWithFormat:@"https://fr.wikipedia.org/w/api.php?action=opensearch&search=%@&format=json", self.selectedWord.text]];
                    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:urlWiki];
                    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
                    NSError *error;
                    NSURLResponse *response = nil;
                
                    NSData *urlData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&response
                                                                 error:&error];
                    NSLog(@"Show def");
                    if (urlData != nil) {
                        NSMutableArray *object = [NSJSONSerialization
                                       JSONObjectWithData:urlData
                                       options:0
                                       error:&error];
                        NSLog(@"%@", [object objectAtIndex:1]);
                        if ([object objectAtIndex:1] != nil || ![[NSString stringWithFormat:@"%@", [object objectAtIndex:1]] isEqualToString:@""]) {
                            NSLog(@"object ?");
                            if ([[object objectAtIndex:2] objectAtIndex:0] != nil) {
                                NSLog(@"bug ?");
                                if ([[[object objectAtIndex:2] objectAtIndex:0] isEqualToString:@""]) {
                                    def = [NSString stringWithFormat:@"%@", [[object objectAtIndex:2] objectAtIndex:1]];
                                } else {
                                    def = [NSString stringWithFormat:@"%@", [[object objectAtIndex:2] objectAtIndex:0]];
                                }
                                self.defWord.text = def;
                            } else {
                                self.defWord.text = @"Pas de définition disponible";
                            }
                        } else {
                            self.defWord.text = @"Pas de définition disponible";
                        }
                    } else {
                        self.defWord.text = @"Pas de définition disponible";
                    }
                    /* LAUNCH ANIM */
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.8];
                    CGAffineTransform transform;
                
                    if (showHideInfos == false) {
                        transform = CGAffineTransformMakeTranslation(0, -550);
                        showHideInfos = true;
                        [self.infos setTransform:transform];
                        [UIView commitAnimations];
                    }
                }
            }
        }
    }
    
    if (activityStarted == true) {
        UITextView *textView = (UITextView *)sender.view;
        CGPoint location = [sender locationInView:textView];
        UITextPosition *tapPosition = [textView closestPositionToPoint:location];
        UITextRange *textRange = [textView.tokenizer rangeEnclosingPosition:tapPosition withGranularity:UITextGranularityWord inDirection:UITextLayoutDirectionRight];
    
        if (![[textView textInRange:textRange]  isEqual: @""] && [textView textInRange:textRange].length > 0) {
            indexDrag ++;
            
            if (indexDrag < 2) {
                [self.dragWord setFrame:CGRectMake(locationToParent.x - 50, locationToParent.y - 10, 100, 20)];
                self.dragWord.text = [NSString stringWithFormat:@"%@", [textView textInRange:textRange]];
                self.dragWord.textColor = [UIColor blackColor];
                self.dragWord.backgroundColor = [UIColor colorWithRed:0.992 green:0.984 blue:0.984 alpha:1];
                self.dragWord.textAlignment = NSTextAlignmentCenter;
                self.dragWord.font = [UIFont fontWithName:@"Museo-300" size: 15];
            }

            if (sender.state == UIGestureRecognizerStateChanged || sender.state == UIGestureRecognizerStateEnded) {
                [self.dragWord setFrame:CGRectMake(locationToParent.x - 50, locationToParent.y - 10, 100, 20)];
                if (locationToParent.x > [self.word1 convertPoint:self.word1.frame.origin toView:nil].x - 55 && locationToParent.x < [self.word1 convertPoint:self.word1.frame.origin toView:nil].x + 223 && locationToParent.y > [self.word1 convertPoint:self.word1.frame.origin toView:nil].y - 125 && locationToParent.y < [self.word1 convertPoint:self.word1.frame.origin toView:nil].y - 75 && drag1 == false) {
                    [self dragHover:locationToParent.x coordY:locationToParent.y];
                    if (sender.state == UIGestureRecognizerStateEnded) {
                        drag1 = true;
                        [self dragAndDrop:1 coordX:locationToParent.x coordY:locationToParent.y];
                        indexDrag = 0;
                    }
                } else if (locationToParent.x > [self.word1 convertPoint:self.word1.frame.origin toView:nil].x - 55 && locationToParent.x < [self.word1 convertPoint:self.word1.frame.origin toView:nil].x + 223 && locationToParent.y > [self.word1 convertPoint:self.word1.frame.origin toView:nil].y - 45 && locationToParent.y < [self.word1 convertPoint:self.word1.frame.origin toView:nil].y + 5 && drag2 == false) {
                    [self dragHover:locationToParent.x coordY:locationToParent.y];
                    if (sender.state == UIGestureRecognizerStateEnded) {
                        drag2 = true;
                        [self dragAndDrop:2 coordX:locationToParent.x coordY:locationToParent.y];
                        indexDrag = 0;
                    }
                } else if (locationToParent.x > [self.word1 convertPoint:self.word1.frame.origin toView:nil].x - 55 && locationToParent.x < [self.word1 convertPoint:self.word1.frame.origin toView:nil].x + 223 && locationToParent.y > [self.word1 convertPoint:self.word1.frame.origin toView:nil].y + 35 && locationToParent.y < [self.word1 convertPoint:self.word1.frame.origin toView:nil].y + 85 && drag3 == false) {
                    [self dragHover:locationToParent.x coordY:locationToParent.y];
                    if (sender.state == UIGestureRecognizerStateEnded) {
                        drag3 = true;
                        [self dragAndDrop:3 coordX:locationToParent.x coordY:locationToParent.y];
                        indexDrag = 0;
                    }
                } else if (locationToParent.x > [self.word1 convertPoint:self.word1.frame.origin toView:nil].x - 55 && locationToParent.x < [self.word1 convertPoint:self.word1.frame.origin toView:nil].x + 223 && locationToParent.y > [self.word1 convertPoint:self.word1.frame.origin toView:nil].y + 115 && locationToParent.y < [self.word1 convertPoint:self.word1.frame.origin toView:nil].y + 165 && drag4 == false) {
                    [self dragHover:locationToParent.x coordY:locationToParent.y];
                    if (sender.state == UIGestureRecognizerStateEnded) {
                        drag4 = true;
                        [self dragAndDrop:4 coordX:locationToParent.x coordY:locationToParent.y];
                        indexDrag = 0;
                    }
                } else {
                    [self.dragWord setFrame:CGRectMake(locationToParent.x - 50, locationToParent.y - 10, 100, 20)];
                    self.dragWord.textColor = [UIColor blackColor];
                    self.dragWord.font = [UIFont fontWithName:@"Museo-300" size: 15];
                    if (sender.state == UIGestureRecognizerStateEnded) {
                        [self.dragWord setFrame:CGRectMake(0, 0, 0, 0)];
                        indexDrag = 0;
                    }
                }
            }
        }
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

/* UPDATE CURRENT CHAPTER IN BDD */
-(void)updateCurrentChapter: (int) indexChap {
    NSString *url = [NSString stringWithFormat:@"http://macbook-pro-de-leo.local:8080/app/pupil/currentChapter/%@/%d", self.myPupil._id, indexChap];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    self.myPupil.currentChapter = [NSString stringWithFormat:@"%d", indexChap];
}

/* TAP ON SCREEN TO SHOW/HIDE BTNS */
- (void) showOrHideToolBar:(UITapGestureRecognizer*)sender {
    if (deployMenuActiv == true) {
        [self deployLibrary: sender];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    CGAffineTransform transform;
    CGAffineTransform transformBtnHome;
    CGAffineTransform transformInfos;
    
    if (showHide == true) {
        transform = CGAffineTransformMakeTranslation(60, -67);
        transformBtnHome = CGAffineTransformMakeTranslation(-57, -67);
        
        if (showHideInfos == true) {
            transformInfos = CGAffineTransformMakeTranslation(0, 0);
        }
        
        showHide = false;
    } else {
        transform = CGAffineTransformMakeTranslation(0, 0);
        transformBtnHome = CGAffineTransformMakeTranslation(0, 0);
    
        if (showHideInfos == true) {
            transformInfos = CGAffineTransformMakeTranslation(0, 0);
        }

        showHide = true;
    }
    
    [self.toolBar setTransform:transform];
    [self.btnHome setTransform:transformBtnHome];
    if (showHideInfos == true) {
        [self.infos setTransform:transformInfos];
        showHideInfos = false;
    }
    [UIView commitAnimations];
    
    if (readFinish == true) {
        [self hideBottomView];
    }
}

- (void) closeZoneInfos:(UIButton *)button {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.8];
    
    CGAffineTransform closeTransform;
    closeTransform = CGAffineTransformMakeTranslation(0, 0);
    [self.infos setTransform:closeTransform];
    [UIView commitAnimations];
}

/* ADD TIME (/10SEC) */
- (void) addReadTime:(NSTimer *)timer {
    if (activityStarted == false) {
        int value = [self.myPupil.readTime intValue];
        self.myPupil.readTime = [NSNumber numberWithInt:value + 10];
    
        NSString *url = [NSString stringWithFormat:@"http://macbook-pro-de-leo.local:8080/app/pupil/addReadTime/%@/%d", self.myPupil._id, value];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [conn start];
    }
}

/* ADD WORD TO WORD'S BAG */
- (void) addWord:(UIButton *)button {
    BOOL isExisting = false;
    self.popupWordBag.hidden = false;
    self.plusUn.hidden = false;
    
    [UIView animateWithDuration: 0.4 delay:0.0 options: UIViewAnimationOptionCurveLinear animations:^{
        CGAffineTransform animWordBag = CGAffineTransformMakeTranslation(-40, 0);
        [self.popupWordBag setTransform: animWordBag];
    } completion:Nil];
    
    [UIView animateWithDuration: 2 delay:0.0 options: UIViewAnimationOptionCurveLinear animations:^{
        self.popupWordBag.alpha = 0;
    } completion: ^(BOOL finished){
        self.popupWordBag.hidden = true;
        self.popupWordBag.alpha = 1;
        CGAffineTransform animWordBag = CGAffineTransformMakeTranslation(0, 0);
        [self.popupWordBag setTransform: animWordBag];
    }];
    
    
    for (int d = 0; d < self.arrayClone.count ; d++) {
        if ([[self.arrayClone objectAtIndex:d] isEqualToString: self.selectedWord.text]) {
            self.popupWordBag.text = @"Déjà dans le sac";
            isExisting = true;
        }
    }
    
    if (isExisting == false) {
        self.popupWordBag.text = @"Ajouté à ton sac de mot !";
        [UIView animateWithDuration: 0.4 delay:0.0 options: UIViewAnimationOptionCurveLinear animations:^{
            CGAffineTransform animPlusUn = CGAffineTransformMakeTranslation(0, -30);
            [self.plusUn setTransform: animPlusUn];
        } completion:Nil];
        [UIView animateWithDuration: 2 delay:0.0 options: UIViewAnimationOptionCurveLinear animations:^{
            self.plusUn.alpha = 0;
        } completion: ^(BOOL finished){
            self.plusUn.hidden = true;
            self.plusUn.alpha = 1;
            CGAffineTransform animPlusUn = CGAffineTransformMakeTranslation(0, 0);
            [self.plusUn setTransform: animPlusUn];
        }];
       [self.arrayClone addObject:self.selectedWord.text];
        self.myPupil.wordsBag = self.arrayClone;
        NSString *url = [NSString stringWithFormat:@"http://macbook-pro-de-leo.local:8080/app/pupil/addWordBag/%@/%@", self    .myPupil._id, self.selectedWord.text];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [conn start];
    }
    
    [UIView commitAnimations];
}

- (void) goWeb:(UIButton *)sender {
    [self performSegueWithIdentifier:@"goWeb" sender:sender];
}

/* DETECT END OF READING */
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
        if (self.myPupil->canGoingTo <= index && rotation == true) {
            readFinish = true;
            self.bottomView.hidden = false;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration: 0.8];
            CGAffineTransform bottomTranslate = CGAffineTransformMakeTranslation(0, -460);
            [self.bottomView setTransform: bottomTranslate];
            [UIView commitAnimations];
        }
    }
}

/* DETECT DEVICE ROTATION */
- (void) deviceOrientationDidChangeNotification:(NSNotification*)note {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        if (readFinish == true) {
            [self launchActivity: [self.myPupil.currentChapter intValue] question: 0];
            [self hideBottomView];
        }
    } else if (readFinish == true || activityFinish == true) {
        [self hideBottomView];
        if (activityFinish == true) {
            [self launchChapterAfterActivity];
            [self.chapterText setFrame:CGRectMake(109, 160, 550, 864)];
            activityFinish = false;
            nbTry = 0;
            self.progressView.hidden = false;
            self.activity.hidden = true;
            [self drawProgressBar];
        }
    }
}

/* ACCEPT OR NOT DEVICE ROTATION */
//- (BOOL) shouldAutorotate {
//    if (readFinish == true || activityFinish == true) {
//        NSLog(@"Rotation");
//        return YES;
//    } else {
//        return NO;
//    }
//}


- (IBAction) deployLibrary:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration: 0.4];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    CGAffineTransform transformHelp;
    CGAffineTransform transformNote;
    CGAffineTransform transformTypo;
    
    if (deployMenuActiv == false) {
        [UIView animateWithDuration: 0.2 delay:0.0 options: UIViewAnimationOptionCurveLinear animations:^{
            CGAffineTransform transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(45));
            self.closeOpen.transform = transform;
        } completion:NULL];
        transformHelp = CGAffineTransformMakeTranslation(0, 80);
        transformNote = CGAffineTransformMakeTranslation(0, 160);
        transformTypo = CGAffineTransformMakeTranslation(0, 240);
        self.helpButton.hidden = false;
        self.noteButton.hidden = false;
        self.typoButton.hidden = false;

        deployMenuActiv = true;
    } else {
        [UIView animateWithDuration: 0.2 delay:0.0 options: UIViewAnimationOptionCurveLinear animations:^{
            CGAffineTransform transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
            self.closeOpen.transform = transform;
        } completion:NULL];
        transformHelp = CGAffineTransformMakeTranslation(0, 0);
        transformNote = CGAffineTransformMakeTranslation(0, 0);
        transformTypo = CGAffineTransformMakeTranslation(0, 0);
    
        deployMenuActiv = false;
    }
    
    [self.helpButton setTransform: transformHelp];
    [self.noteButton setTransform: transformNote];
    [self.typoButton setTransform: transformTypo];
    
    [UIView commitAnimations];
}

- (void) animationDidStop:(NSString*)animationID finished:(BOOL)finished context:(void *)context {
    if (deployMenuActiv == false) {
        self.helpButton.hidden = true;
        self.noteButton.hidden = true;
        self.typoButton.hidden = true;
    }
}

- (IBAction) changeTypo:(id)sender {
    UIFont *myFont;
    indexTypo ++;

    switch (indexTypo) {
        case 1:
            myFont = [self.chapterText.font fontWithSize: 20.0];
            break;
            
        case 2:
            myFont = [self.chapterText.font fontWithSize: 22.0];
            break;
            
        case 3:
            myFont = [self.chapterText.font fontWithSize: 18.0];
            indexTypo = 1;
            break;
            
        default:
            break;
    }
    
    self.chapterText.font = myFont;
}

- (IBAction)goToMsg:(id)sender {
    [self performSegueWithIdentifier:@"goToSendMsgFromBook" sender:sender];
}

/* SEND DATA TO OTHERS VIEWS */
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"backHome"]){
        HomeViewController *controller = (HomeViewController *)segue.destinationViewController;
        controller.myPupil = self.myPupil;
        controller.myBook = self.myBook;
        controller.team = self.team;
    } else if([segue.identifier isEqualToString:@"goWeb"]){
        WebPageViewController *controller = (WebPageViewController *)segue.destinationViewController;
        controller.myPupil = self.myPupil;
        controller.myBook = self.myBook;
        controller.team = self.team;
        controller.paramUrl = self.selectedWord.text;
    } else if([segue.identifier isEqualToString:@"goToSendMsgFromBook"]){
        SendMessageViewController *controller = (SendMessageViewController *)segue.destinationViewController;
        controller.myPupil = self.myPupil;
        controller.myBook = self.myBook;
        controller.team = self.team;
        controller.fromBook = @"true";
    }    
}

/* ACTIVITY */
/* INIT ACTIVITY ZONE */
- (void) initActivity {
    /* INIT ZONE */
    self.activity =[[UIView alloc] init];
    [self.view addSubview:self.activity];
    CGRect activityFrame = self.activity.frame;
    activityFrame.size.width = 380;
    activityFrame.size.height = 600;
    activityFrame.origin.x = 530;
    activityFrame.origin.y = 150;
    self.activity.frame = activityFrame;
    self.activity.hidden = true;
    
    [self.activity addSubview: self.pickerActivity];
    
    /* CONTAINER ORDER */
    self.containerOrder = [[UIView alloc] init];
    CGRect containerOrderFrame = self.containerOrder.frame;
    containerOrderFrame.size.width = 380;
    containerOrderFrame.size.height = 80;
    self.containerOrder.frame = containerOrderFrame;
    self.containerOrder.backgroundColor = [UIColor colorWithRed:0.988 green:0.984 blue:0.984 alpha:1];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, 80.0f, self.containerOrder.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.965 green:0.929 blue:0.929 alpha:1].CGColor;
    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(380, 0.0f, 5.0f, self.containerOrder.frame.size.height + 1);
    rightBorder.backgroundColor = [UIColor colorWithRed:0.898 green:0.663 blue:0.635 alpha:1].CGColor;
    [self.activity.layer addSublayer:bottomBorder];
    [self.activity.layer addSublayer:rightBorder];
    [self.activity addSubview: self.containerOrder];
    
    /* INIT NUM ICO */
    self.numQuestion1Ico = [UIImage imageNamed:@"questionNum1"];
    self.imageViewNumQuestion1 = [[UIImageView alloc] initWithImage: self.numQuestion1Ico];
    CGRect image1Frame = self.imageViewNumQuestion1.frame;
    image1Frame.origin.x = 12;
    image1Frame.origin.y = 12;
    self.imageViewNumQuestion1.frame = image1Frame;
    [self.containerOrder addSubview: self.imageViewNumQuestion1];
    
    self.numQuestion2Ico = [UIImage imageNamed:@"questionNum2"];
    self.imageViewNumQuestion2 = [[UIImageView alloc] initWithImage: self.numQuestion2Ico];
    CGRect image2Frame = self.imageViewNumQuestion2.frame;
    image2Frame.origin.x = 12;
    image2Frame.origin.y = 12;
    self.imageViewNumQuestion2.frame = image2Frame;
    [self.containerOrder addSubview: self.imageViewNumQuestion2];
    self.imageViewNumQuestion2.hidden = true;
    
    self.numQuestion3Ico = [UIImage imageNamed:@"questionNum3"];
    self.imageViewNumQuestion3 = [[UIImageView alloc] initWithImage: self.numQuestion3Ico];
    CGRect image3Frame = self.imageViewNumQuestion3.frame;
    image3Frame.origin.x = 12;
    image3Frame.origin.y = 12;
    self.imageViewNumQuestion3.frame = image3Frame;
    [self.containerOrder addSubview: self.imageViewNumQuestion3];
    self.imageViewNumQuestion3.hidden = true;
    
    /* INIT ORDER */
    self.order = [[UILabel alloc] init];
    [self.order setFrame:CGRectMake(80, 5, 290, 70)];
    self.order.font = [UIFont fontWithName: @"Museo-300" size: 17.0];
    self.order.textColor = [UIColor colorWithRed:0.827 green:0.455 blue:0.455 alpha:1];
    self.order.numberOfLines = 0;
    self.order.lineBreakMode = NSLineBreakByWordWrapping;
    [self.containerOrder addSubview: self.order];
    
    /* BTN NEXT/FINISH */
    self.nextQuestion = [[UIButton alloc] init];
    [self.nextQuestion setFrame:CGRectMake(130, 480, 135, 32)];
    [self.nextQuestion setTitle:@"Suivant" forState:UIControlStateNormal];
    [self.nextQuestion setBackgroundColor:[UIColor colorWithRed:0.965 green:0.929 blue:0.929 alpha:1]];
    [self.nextQuestion setTitleColor: [UIColor colorWithRed:0.804 green:0.804 blue:0.804 alpha:1] forState:UIControlStateNormal];
    [self.nextQuestion.titleLabel setFont:[UIFont fontWithName:@"Museo-300" size:17.0]];
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.nextQuestion.bounds
                                         byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomRight)
                                               cornerRadii:CGSizeMake(15.0, 15.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.nextQuestion.bounds;
    maskLayer.path = maskPath.CGPath;
    self.nextQuestion.layer.mask = maskLayer;
    [self.activity addSubview: self.nextQuestion];
    
    /* ACT 1 - Q1 */
    self.word1 = [[UIView alloc] init];
    self.word2 = [[UIView alloc] init];
    self.word3 = [[UIView alloc] init];
    self.word4 = [[UIView alloc] init];
    
    [self.activity addSubview: self.word1];
    [self.activity addSubview: self.word2];
    [self.activity addSubview: self.word3];
    [self.activity addSubview: self.word4];
    
    /* ACT 1 - Q2 */
    self.choice1 = [[UILabel alloc] init];
    self.choice2 = [[UILabel alloc] init];
    self.choice3 = [[UILabel alloc] init];
    self.choice4 = [[UILabel alloc] init];
    
    [self.activity addSubview: self.choice1];
    [self.activity addSubview: self.choice2];
    [self.activity addSubview: self.choice3];
    [self.activity addSubview: self.choice4];
    
    UITapGestureRecognizer *labelSelected1 = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(selectLabelActivity:)];
    labelSelected1.numberOfTapsRequired = 1;
    UITapGestureRecognizer *labelSelected2 = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(selectLabelActivity:)];
    labelSelected2.numberOfTapsRequired = 1;
    UITapGestureRecognizer *labelSelected3 = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(selectLabelActivity:)];
    labelSelected3.numberOfTapsRequired = 1;
    UITapGestureRecognizer *labelSelected4 = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(selectLabelActivity:)];
    labelSelected4.numberOfTapsRequired = 1;
    self.choice1.userInteractionEnabled = YES;
    self.choice2.userInteractionEnabled = YES;
    self.choice3.userInteractionEnabled = YES;
    self.choice4.userInteractionEnabled = YES;
    [self.choice1 addGestureRecognizer:labelSelected1];
    [self.choice2 addGestureRecognizer:labelSelected2];
    [self.choice3 addGestureRecognizer:labelSelected3];
    [self.choice4 addGestureRecognizer:labelSelected4];
    
    /* ACT 1 - Q3 */

}

- (void) launchActivity:(int) numActivity question: (int)numQuestion {
    readFinish = false;
    rotation = false;
    activityStarted = true;
    self.progressView.hidden = true;
    [self.chapterText setContentOffset:CGPointZero animated:NO];
    
    [self.chapterText setFrame:CGRectMake(60, 160, 450, 864)];
    
    self.activity.hidden = false;
    
    [self firstActivity: 0];
}

/* LAUNCH NEXT CHAPTER */
- (void) launchChapterAfterActivity {
    if ([self.myBook.nbChapter intValue] > index) {
        rotation = true;
        NSString *url = [NSString stringWithFormat:@"http://macbook-pro-de-leo.local:8080/app/pupil/chapter/unlock/%@/%d", self.myPupil._id, index];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [conn start];
        self.chapter.text = [NSString stringWithFormat:@"%@", [[self.myBook.chapter objectAtIndex: index] objectForKey:@"titleChapter"]];
        self.chapterText.text = [NSString stringWithFormat:@"%@", [[self.myBook.chapter objectAtIndex: index] objectForKey:@"textChapter"]];
    } else {
        self.chapterText.text = @"Félicitation ! Le livre est terminé !";
    }
}

-(void) firstActivity: (int)numQuestion {
    int width = 278;
    int height = 45;
    switch (numQuestion) {
        case 0:
            self.order.text = @"Dans le texte que tu viens de  lire, trouve 4 mots appartenant au même champ lexical que le mot “argent”";
            
            self.imageViewNumQuestion1.hidden = false;
            self.imageViewNumQuestion2.hidden = true;
            self.imageViewNumQuestion3.hidden = true;
            drag1 = false;
            drag2 = false;
            drag3 = false;
            drag4 = false;
            [self.answer1 setFrame:CGRectMake(0, 0, 0, 0)];
            [self.answer2 setFrame:CGRectMake(0, 0, 0, 0)];
            [self.answer3 setFrame:CGRectMake(0, 0, 0, 0)];
            [self.answer4 setFrame:CGRectMake(0, 0, 0, 0)];
            
            self.pickerActivity.hidden = true;
            
            [self.nextQuestion setBackgroundColor:[UIColor colorWithRed:0.965 green:0.929 blue:0.929 alpha:1]];
            [self.nextQuestion setTitleColor: [UIColor colorWithRed:0.804 green:0.804 blue:0.804 alpha:1] forState:UIControlStateNormal];
            self.nextQuestion.enabled = NO;
            
            CGRect dropZone1 = self.word1.frame;
            CGRect dropZone2 = self.word2.frame;
            CGRect dropZone3 = self.word3.frame;
            CGRect dropZone4 = self.word4.frame;
            
            dropZone1.origin.x = 60;
            dropZone1.origin.y = 120;
            dropZone2.origin.x = 60;
            dropZone2.origin.y = 200;
            dropZone3.origin.x = 60;
            dropZone3.origin.y = 280;
            dropZone4.origin.x = 60;
            dropZone4.origin.y = 360;
            
            dropZone1.size.width = width;
            dropZone1.size.height = height;
            dropZone2.size.width = width;
            dropZone2.size.height = height;
            dropZone3.size.width = width;
            dropZone3.size.height = height;
            dropZone4.size.width = width;
            dropZone4.size.height = height;
            
            self.word1.frame = dropZone1;
            self.word2.frame = dropZone2;
            self.word3.frame = dropZone3;
            self.word4.frame = dropZone4;
            
            self.word1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_drop_zone"]];
            self.word2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_drop_zone"]];
            self.word3.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_drop_zone"]];
            self.word4.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_drop_zone"]];
            
            self.word1.hidden = false;
            self.word2.hidden = false;
            self.word3.hidden = false;
            self.word4.hidden = false;
            self.answer1.hidden = false;
            self.answer2.hidden = false;
            self.answer3.hidden = false;
            self.answer4.hidden = false;
            
            break;
        case 1:
            step = 2;
            self.imageViewNumQuestion1.hidden = true;
            self.imageViewNumQuestion2.hidden = false;
            self.imageViewNumQuestion3.hidden = true;
            self.order.text = @"Quel est l’état civil de Phileas Fogg ?";
            [self.nextQuestion setBackgroundColor:[UIColor colorWithRed:0.965 green:0.929 blue:0.929 alpha:1]];
            [self.nextQuestion setTitleColor: [UIColor colorWithRed:0.804 green:0.804 blue:0.804 alpha:1] forState:UIControlStateNormal];
            self.nextQuestion.enabled = NO;
            
            [self.choice1 setFrame:CGRectMake(60, 120, width, height)];
            [self.choice2 setFrame:CGRectMake(60, 200, width, height)];
            [self.choice3 setFrame:CGRectMake(60, 280, width, height)];
            [self.choice4 setFrame:CGRectMake(60, 360, width, height)];
            
            self.choice1.text = @"Veuf";
            self.choice2.text = @"Divorcé";
            self.choice3.text = @"Célibataire";
            self.choice4.text = @"Marié";
            
            self.choice1.textColor = [UIColor colorWithRed:0.192 green:0.192 blue:0.192 alpha:1];
            self.choice2.textColor = [UIColor colorWithRed:0.192 green:0.192 blue:0.192 alpha:1];
            self.choice3.textColor = [UIColor colorWithRed:0.192 green:0.192 blue:0.192 alpha:1];
            self.choice4.textColor = [UIColor colorWithRed:0.192 green:0.192 blue:0.192 alpha:1];
            
            self.choice1.textAlignment = NSTextAlignmentCenter;
            self.choice2.textAlignment = NSTextAlignmentCenter;
            self.choice3.textAlignment = NSTextAlignmentCenter;
            self.choice4.textAlignment = NSTextAlignmentCenter;
            
            self.choice1.font = [UIFont fontWithName:@"Museo-300" size:25];
            self.choice2.font = [UIFont fontWithName:@"Museo-300" size:25];
            self.choice3.font = [UIFont fontWithName:@"Museo-300" size:25];
            self.choice4.font = [UIFont fontWithName:@"Museo-300" size:25];
            
            self.choice1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_drop_zone"]];
            self.choice2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_drop_zone"]];
            self.choice3.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_drop_zone"]];
            self.choice4.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_drop_zone"]];
            
            self.choice1.hidden = true;
            self.choice2.hidden = true;
            self.choice3.hidden = true;
            self.choice4.hidden = true;
            break;
        case 2:
            step = 3;
            [self.nextQuestion setBackgroundColor:[UIColor colorWithRed:0.965 green:0.929 blue:0.929 alpha:1]];
            [self.nextQuestion setTitleColor: [UIColor colorWithRed:0.804 green:0.804 blue:0.804 alpha:1] forState:UIControlStateNormal];
            self.nextQuestion.enabled = NO;
            self.imageViewNumQuestion1.hidden = true;
            self.imageViewNumQuestion2.hidden = true;
            self.imageViewNumQuestion3.hidden = false;
            self.order.text = @"Combien de domestique a Phileas Fogg ?";
            CGRect pickerFrame = self.pickerActivity.frame;
            pickerFrame.origin.x = 90;
            pickerFrame.origin.y = 120;
            self.pickerActivity.frame = pickerFrame;
            break;
            
        default:
            break;
    }
}

- (void) dragHover: (float) x coordY: (float) y  {
    [self.dragWord setFrame:CGRectMake(x - 50, y - 15, 200, 30)];
    [self.dragWord setFont: [UIFont fontWithName:@"Museo-300" size: 20.0f]];
    self.dragWord.textColor = [UIColor colorWithRed:0.898 green:0.663 blue:0.635 alpha:1];
}

- (void) dragAndDrop: (int) numZone coordX: (float) x coordY: (float) y {
    [self.dragWord setFrame:CGRectMake(0, 0, 0, 0)];
    
    switch (numZone) {
        case 1:
            [self.answer1 setFrame:CGRectMake(x - 50, y - 15, 200, 30)];
            [self.answer1 setFont: [UIFont fontWithName:@"Museo-300" size: 20.0f]];
            self.answer1.textColor = [UIColor colorWithRed:0.898 green:0.663 blue:0.635 alpha:1];
            self.answer1.backgroundColor = [UIColor colorWithRed:0.992 green:0.984 blue:0.984 alpha:1];
            self.answer1.textAlignment = NSTextAlignmentCenter;
            self.answer1.text = self.dragWord.text;
            break;
        case 2:
            [self.answer2 setFrame:CGRectMake(x - 50, y - 15, 200, 30)];
            [self.answer2 setFont: [UIFont fontWithName:@"Museo-300" size: 20.0f]];
            self.answer2.textColor = [UIColor colorWithRed:0.898 green:0.663 blue:0.635 alpha:1];
            self.answer2.backgroundColor = [UIColor colorWithRed:0.992 green:0.984 blue:0.984 alpha:1];
            self.answer2.textAlignment = NSTextAlignmentCenter;
            self.answer2.text = self.dragWord.text;
            break;
        case 3:
            [self.answer3 setFrame:CGRectMake(x - 50, y - 15, 200, 30)];
            [self.answer3 setFont: [UIFont fontWithName:@"Museo-300" size: 20.0f]];
            self.answer3.textColor = [UIColor colorWithRed:0.898 green:0.663 blue:0.635 alpha:1];
            self.answer3.backgroundColor = [UIColor colorWithRed:0.992 green:0.984 blue:0.984 alpha:1];
            self.answer3.textAlignment = NSTextAlignmentCenter;
            self.answer3.text = self.dragWord.text;
            break;
        case 4:
            [self.answer4 setFrame:CGRectMake(x - 50, y - 15, 200, 30)];
            [self.answer4 setFont: [UIFont fontWithName:@"Museo-300" size: 20.0f]];
            self.answer4.textColor = [UIColor colorWithRed:0.898 green:0.663 blue:0.635 alpha:1];
            self.answer4.backgroundColor = [UIColor colorWithRed:0.992 green:0.984 blue:0.984 alpha:1];
            self.answer4.textAlignment = NSTextAlignmentCenter;
            self.answer4.text = self.dragWord.text;
            break;
            
        default:
            break;
    }
    
    if (drag1 == true & drag2 == true & drag3 == true & drag4 == true) {
        self.nextQuestion.enabled = YES;
        self.nextQuestion.backgroundColor = [UIColor colorWithRed:0.898 green:0.663 blue:0.635 alpha:1];
        [self.nextQuestion setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.nextQuestion addTarget:self action:@selector(question2Activity1:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void) selectLabelActivity: (UIGestureRecognizer *)sender {
    self.choice1.textColor = [UIColor colorWithRed:0.192 green:0.192 blue:0.192 alpha:1];
    self.choice2.textColor = [UIColor colorWithRed:0.192 green:0.192 blue:0.192 alpha:1];
    self.choice3.textColor = [UIColor colorWithRed:0.192 green:0.192 blue:0.192 alpha:1];
    self.choice4.textColor = [UIColor colorWithRed:0.192 green:0.192 blue:0.192 alpha:1];
    self.choice1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_drop_zone"]];
    self.choice2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_drop_zone"]];
    self.choice3.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_drop_zone"]];
    self.choice4.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_drop_zone"]];

    if( [sender state] == UIGestureRecognizerStateEnded ) {
        self.selected = (UILabel*)[sender view];
        self.selected.textColor = [UIColor whiteColor];
        self.selected.backgroundColor = [UIColor colorWithRed:0.898 green:0.663 blue:0.635 alpha:1];
        NSLog(@"%@", self.selected.text);
        
        self.nextQuestion.enabled = YES;
        self.nextQuestion.backgroundColor = [UIColor colorWithRed:0.898 green:0.663 blue:0.635 alpha:1];
        [self.nextQuestion setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.nextQuestion addTarget:self action:@selector(question3Activity1:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (int) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (int) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerData.count;
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerData[row];
}

- (CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 80.0f;
}

-(UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 80)];
    label.textColor = [UIColor colorWithRed:0.898 green:0.663 blue:0.635 alpha:1];
    label.font = [UIFont fontWithName:@"Museo-300" size:70];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%ld", row+1];
    return label;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    rowSelected = row + 1;
    self.nextQuestion.enabled = YES;
    [self.nextQuestion setTitle:@"Valider" forState:UIControlStateNormal];
    self.nextQuestion.backgroundColor = [UIColor colorWithRed:0.898 green:0.663 blue:0.635 alpha:1];
    [self.nextQuestion setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextQuestion addTarget:self action:@selector(validateActivity:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) question2Activity1:(UIButton *)sender {
    if (step == 1) {
        NSLog(@"%lu", (unsigned long)[self.goodAnswers count]);
        for (int o = 0; o < [self.goodAnswers count]; o++) {
            if ([[self.goodAnswers objectAtIndex:o] isEqualToString:self.answer1.text ]) {
                goodAnswersNb ++;
                NSLog(@"Good Answer rep1");
            } else if ([[self.goodAnswers objectAtIndex:o] isEqualToString:self.answer2.text]) {
                goodAnswersNb ++;
                NSLog(@"Good Answer rep2");
            } else if ([[self.goodAnswers objectAtIndex:o] isEqualToString:self.answer3.text]) {
                goodAnswersNb ++;
                NSLog(@"Good Answer rep3");
            } else if ([[self.goodAnswers objectAtIndex:o] isEqualToString:self.answer4.text]) {
                goodAnswersNb ++;
                NSLog(@"Good Answer rep4");
            }
        }
    
        [self firstActivity:1];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration: 0.6];
        [UIView animateWithDuration: 0.6 delay:0.0 options: UIViewAnimationOptionCurveLinear animations:^{
            CGAffineTransform question1Right = CGAffineTransformMakeTranslation(500, 0);
            [self.word1 setTransform: question1Right];
            [self.word2 setTransform: question1Right];
            [self.word3 setTransform: question1Right];
            [self.word4 setTransform: question1Right];
            [self.answer1 setTransform: question1Right];
            [self.answer2 setTransform: question1Right];
            [self.answer3 setTransform: question1Right];
            [self.answer4 setTransform: question1Right];
        } completion:^(BOOL finished) {
            self.word1.hidden = true;
            self.word2.hidden = true;
            self.word3.hidden = true;
            self.word4.hidden = true;
            self.answer1.hidden = true;
            self.answer2.hidden = true;
            self.answer3.hidden = true;
            self.answer4.hidden = true;
            self.choice1.hidden = false;
            self.choice2.hidden = false;
            self.choice3.hidden = false;
            self.choice4.hidden = false;
            CGAffineTransform question1Right = CGAffineTransformMakeTranslation(-500, 0);
            [self.word1 setTransform: question1Right];
            [self.word2 setTransform: question1Right];
            [self.word3 setTransform: question1Right];
            [self.word4 setTransform: question1Right];
            [self.answer1 setTransform: question1Right];
            [self.answer2 setTransform: question1Right];
            [self.answer3 setTransform: question1Right];
            [self.answer4 setTransform: question1Right];
        }];
    
        [UIView commitAnimations];
    }
}

- (void) question3Activity1:(UIButton *)sender {
    if (step == 2) {
        if ([self.selected.text isEqualToString:@"Célibataire"]) {
            goodAnswersNb ++;
            NSLog(@"Good answer celibataire");
        }
    
        [self firstActivity:2];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration: 0.6];
    
        [UIView animateWithDuration: 0.6 delay:0.0 options: UIViewAnimationOptionCurveLinear animations:^{
            CGAffineTransform question1Right = CGAffineTransformMakeTranslation(500, 0);
            [self.choice1 setTransform: question1Right];
            [self.choice2 setTransform: question1Right];
            [self.choice3 setTransform: question1Right];
            [self.choice4 setTransform: question1Right];
        } completion:^(BOOL finished) {
            self.choice1.hidden = true;
            self.choice2.hidden = true;
            self.choice3.hidden = true;
            self.choice4.hidden = true;
            self.pickerActivity.hidden = false;
            CGAffineTransform question1Right = CGAffineTransformMakeTranslation(-500, 0);
            [self.choice1 setTransform: question1Right];
            [self.choice2 setTransform: question1Right];
            [self.choice3 setTransform: question1Right];
            [self.choice4 setTransform: question1Right];
        }];
    
        [UIView commitAnimations];
    }
}

/* FINISH ACTIVITY */
- (void) validateActivity:(UIButton *)button {
    if (step == 3) {
        self.nextQuestion.enabled = NO;
        
        if (rowSelected == 3) {
            goodAnswersNb ++;
        }
        
        self.finishView.hidden = false;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration: 1];
        [UIView animateWithDuration: 1 delay:0.0 options: UIViewAnimationOptionCurveLinear animations:^{
            CGAffineTransform finishAnim = CGAffineTransformMakeTranslation(0, 700);
            [self.finishView setTransform: finishAnim];
        } completion:nil];
        
        [UIView commitAnimations];
        
        nbTry ++;
        if (nbTry == 1) {
            NSString *urlSave = [NSString stringWithFormat:@"http://macbook-pro-de-leo.local:8080/app/pupil/activity/%@/%@/%d", self.myPupil._id, self.myPupil.currentChapter, goodAnswersNb];
            NSURLRequest *requestSave = [NSURLRequest requestWithURL:[NSURL URLWithString:urlSave]];
            NSURLConnection *connSave = [[NSURLConnection alloc] initWithRequest:requestSave delegate:self];
            [connSave start];
        }
        
        if (nbTry == 2) {
            NSString *url = [NSString stringWithFormat:@"http://macbook-pro-de-leo.local:8080/app/pupil/activity/try/%@/%d/%d", self.myPupil._id, [self.myPupil.currentChapter intValue], nbTry];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [conn start];
        }
       
        NSLog(@"%d", goodAnswersNb);
        if (goodAnswersNb == 6) {
            self.titleFinishView.text = @"Félicitation";
            self.textFinishView.text = @"Tu as terminé l’activité. Découvre maintenant la suite des aventures de Phileas Fogg et Passepartout ! \n Retourne ton iPad pour continuer.";
            self.reloadActivity.hidden = true;
            self.reloadActivity.enabled = NO;
            self.finishActivity.hidden = false;
            self.finishActivity.enabled = YES;
        } else {
            int error = 6 - goodAnswersNb;
            self.titleFinishView.text = @"Oh ...";
            self.textFinishView.text = [NSString stringWithFormat:@"Tu as %d erreurs, retente ta chance !", error];
            self.finishActivity.hidden = true;
            self.finishActivity.enabled = NO;
            self.reloadActivity.hidden = false;
            self.reloadActivity.enabled = YES;
        }
    }
}

- (void) chapterAfterActivity: (id)sender {
    NSLog(@"Next chapter");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration: 1];
    [UIView animateWithDuration: 1 delay:0.0 options: UIViewAnimationOptionCurveLinear animations:^{
        CGAffineTransform finishAnim = CGAffineTransformMakeTranslation(0, -700);
        [self.finishView setTransform: finishAnim];
    } completion:nil];
    [UIView commitAnimations];
    
    goodAnswersNb = 0;
    step = 1;
    activityFinish = true;
    activityStarted = false;
    if ([self.myBook.nbChapter intValue] > index) {
        index ++;
        self.myPupil->canGoingTo ++;
        [self updateCurrentChapter:index];
    }
}

- (void) reloadActivityFinish:(id)sender {
    NSLog(@"reload");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration: 1];
    [UIView animateWithDuration: 1 delay:0.0 options: UIViewAnimationOptionCurveLinear animations:^{
        CGAffineTransform finishAnim = CGAffineTransformMakeTranslation(0, -700);
        [self.finishView setTransform: finishAnim];
    } completion:nil];
    
    [UIView commitAnimations];
    [self firstActivity: 0];
    goodAnswersNb = 0;
    step = 1;
}

- (void) initFinishView {
    /* FINISH VIEW */
    self.finishView = [[UIView alloc] init];
    [self.view addSubview: self.finishView];
    CGRect finishViewFrame = self.finishView.frame;
    finishViewFrame.origin.x = 100;
    finishViewFrame.origin.y = -600;
    finishViewFrame.size.width = 800;
    finishViewFrame.size.height = 600;
    self.finishView.frame = finishViewFrame;
    self.finishView.backgroundColor = [UIColor whiteColor];
    self.finishView.hidden = true;
    
    self.titleFinishView = [[UILabel alloc] init];
    self.textFinishView = [[UILabel alloc] init];
    self.reloadActivity = [[UIButton alloc] init];
    self.finishActivity = [[UIButton alloc] init];
    
    [self.titleFinishView setFrame:CGRectMake(185, 170, 430, 75)];
    [self.textFinishView setFrame:CGRectMake(135, 240, 480, 55)];
    [self.reloadActivity setFrame:CGRectMake(358, 320, 83, 83)];
    [self.finishActivity setFrame:CGRectMake(358, 320, 83, 83)];
    
    self.titleFinishView.font = [UIFont fontWithName:@"Museo-300" size:70];
    self.titleFinishView.textColor = [UIColor colorWithRed:0.71 green:0.267 blue:0.353 alpha:1];
    self.titleFinishView.textAlignment = NSTextAlignmentCenter;
    
    self.textFinishView.font = [UIFont fontWithName:@"Museo-300" size:18];
    self.textFinishView.numberOfLines = 0;
    self.textFinishView.textColor = [UIColor colorWithRed:0.243 green:0.243 blue:0.235 alpha:1];
    self.textFinishView.textAlignment = NSTextAlignmentCenter;
    
    [self.reloadActivity setBackgroundImage:[UIImage imageNamed:@"check_bottom"] forState:UIControlStateNormal];
    [self.finishActivity setBackgroundImage:[UIImage imageNamed:@"check_bottom"] forState:UIControlStateNormal];
    
    [self.finishActivity addTarget:self action:@selector(chapterAfterActivity:) forControlEvents:UIControlEventTouchDown];
    [self.reloadActivity addTarget:self action:@selector(reloadActivityFinish:) forControlEvents:UIControlEventTouchDown];
    
    self.reloadActivity.hidden = true;
    self.reloadActivity.enabled = NO;
    self.finishActivity.hidden = true;
    self.finishActivity.enabled = NO;
    
    [self.finishView addSubview: self.titleFinishView];
    [self.finishView addSubview: self.textFinishView];
    [self.finishView addSubview: self.reloadActivity];
    [self.finishView addSubview: self.finishActivity];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error : %@", error);
}

@end
