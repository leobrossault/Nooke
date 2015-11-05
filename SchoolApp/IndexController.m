//
//  ViewController.m
//  SchoolApp
//
//  Created by Léo Brossault on 25/03/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import "IndexController.h"
#import "VideoHomeViewController.h"
#import "AppDelegate.h"
#import <RestKit/RestKit.h>

@interface IndexController ()


/* OBJECT */
@property (nonatomic, strong) NSArray *pupil;
@property (nonatomic, strong) NSArray *book;
@property (nonatomic, strong) NSArray *pupilsTeam;
@property (nonatomic, strong) NSManagedObject *thePupil;
@property (nonatomic, strong) NSMutableArray *team;

/* RESTKIT */
@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) NSString *urlConnectionBook;
@property (nonatomic, strong) NSString *urlConnectionTeam;
@property (nonatomic, strong) NSArray *map;
@property (nonatomic, strong) RKObjectManager *objectManager;
@property (nonatomic, strong) RKObjectMapping *pupilMapping;
@property (nonatomic, strong) RKObjectMapping *bookMapping;
@property (nonatomic, strong) RKObjectMapping *pupilsTeamMapping;

/* STORYBOARD */
@property (weak, nonatomic) IBOutlet UITextField *passwordForm;

@end

@implementation IndexController


- (void)viewDidLoad {
    [super viewDidLoad];
    /* INIT TEAM ARRAY */
    self.team = [NSMutableArray array];
    for(int l = 0; l<6; l++) [self.team addObject: [NSNull null]];
    
    self.baseURL = [NSURL URLWithString:@"http://macbook-pro-de-leo.local:8080"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Configure RestKit frameworks, pathPatter must be equal to getObjectsAtPath
- (void)configureRestKit {
    NSString *urlConnection;
    urlConnection = [NSString stringWithFormat:@"/app/pupils/%@", self.passwordForm.text];
    
    // initialize AFNetworking HTTPClient
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:self.baseURL];
    // initialize RestKit
    self.objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    // setup object mappings
    self.pupilMapping = [RKObjectMapping mappingForClass:[Pupils class]];
    [self.pupilMapping addAttributeMappingsFromArray:@[@"_id", @"firstName", @"lastName", @"passwordApp", @"grade", @"classroom", @"teacher", @"currentChapter", @"team", @"readTime", @"wordsBag"]];
    
    self.pupilsTeamMapping = [RKObjectMapping mappingForClass:[PupilsTeam class]];
    [self.pupilsTeamMapping addAttributeMappingsFromArray:@[@"_id", @"firstName", @"lastName", @"currentChapter"]];
    
    self.bookMapping = [RKObjectMapping mappingForClass:[Book class]];
    [self.bookMapping addAttributeMappingsFromArray:@[@"_id", @"title", @"author", @"nbChapter", @"chapter"]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"connected"]){
        VideoHomeViewController *controller = (VideoHomeViewController *)segue.destinationViewController;
        controller.myPupil = self.myPupilExport;
        controller.myBook = self.myBookExport;
        controller.team = self.team;
    }
}

- (IBAction)connectionPupil:(id)sender {
//   AppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = [appDelegate managedObjectContext];
//
//    self.thePupil = [NSEntityDescription insertNewObjectForEntityForName:@"Pupil" inManagedObjectContext:context];
    
    NSString *urlConnection;
    
    urlConnection = [NSString stringWithFormat:@"/app/pupils/%@", self.passwordForm.text];
    
    [self configureRestKit];
    
    RKResponseDescriptor *responseDescriptorPupil =
    [RKResponseDescriptor responseDescriptorWithMapping:self.pupilMapping
                                                 method:RKRequestMethodGET
                                            pathPattern: urlConnection
                                                keyPath: nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptor:responseDescriptorPupil];
    
    self.map = [NSArray arrayWithObjects: responseDescriptorPupil, nil];
    
    if ([self.passwordForm.text length] == 0) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Champs vide"
                                                          message:@"Veuillez remplir le champs mot de passe."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    } else {
        [[RKObjectManager sharedManager] getObjectsAtPath:urlConnection parameters:nil
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                self.pupil = mappingResult.array;
                                                      
                for (i = 0; i < [self.pupil count]; i++) {
                    Pupils *myPupil = [self.pupil objectAtIndex:i];
                    self.myPupilExport = myPupil;
                    
//                    [self.thePupil setValue: myPupil.firstName forKey:@"firstName"];
//                    [self.thePupil setValue: myPupil.lastName forKey:@"lastName"];
//                    [self.thePupil setValue: myPupil.grade forKey:@"grade"];
//                    [self.thePupil setValue: myPupil.teacher forKey:@"teacher"];
//                    [self.thePupil setValue: myPupil._id forKey:@"id"];
//                    NSError *error;
//                    [context save:&error];
                }
               
               self.urlConnectionBook = [NSString stringWithFormat:@"/app/book/%@", self.myPupilExport.teacher];
               
               self.urlConnectionTeam = [NSString stringWithFormat:@"/app/team/%@", self.myPupilExport._id];

               RKResponseDescriptor *responseDescriptorBook =
               [RKResponseDescriptor responseDescriptorWithMapping:self.bookMapping
                                                            method:RKRequestMethodGET
                                                       pathPattern: self.urlConnectionBook
                                                           keyPath: nil
                                                       statusCodes:[NSIndexSet indexSetWithIndex:200]];
               
               RKResponseDescriptor *responseDescriptorTeam =
               [RKResponseDescriptor responseDescriptorWithMapping:self.pupilsTeamMapping
                                                            method:RKRequestMethodGET
                                                       pathPattern: self.urlConnectionTeam
                                                           keyPath: nil
                                                       statusCodes:[NSIndexSet indexSetWithIndex:200]];
               
               [self.objectManager addResponseDescriptor:responseDescriptorBook];
               [self.objectManager addResponseDescriptor:responseDescriptorTeam];
               self.map = [NSArray arrayWithObjects: responseDescriptorPupil, responseDescriptorBook, responseDescriptorTeam, nil];
               [self.objectManager addResponseDescriptorsFromArray: self.map];

                [[RKObjectManager sharedManager] getObjectsAtPath:self.urlConnectionBook parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                           self.book = mappingResult.array;
                                                             
                           for (i = 0; i < [self.book count]; i++) {
                               Book *myBook = [self.book objectAtIndex:i];
                               self.myBookExport = myBook;
                           }
                          
                          [[RKObjectManager sharedManager] getObjectsAtPath:self.urlConnectionTeam parameters:nil
                                success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                    self.pupilsTeam = mappingResult.array;
                                                                        
                                    for (k = 0; k < [self.pupilsTeam count]; k++) {
                                        PupilsTeam *myTeam = [self.pupilsTeam objectAtIndex:k];
                                        self.myTeam = myTeam;
                                        [self.team replaceObjectAtIndex: k withObject:myTeam];
                                    }
                                                                        
                                    /* DELETE ELEM NULL (SEE INIT) */
                                    for (int m = 0; m < [self.team count]; m++) {
                                        if ([self.team objectAtIndex: m] == [NSNull null]) {
                                           [self.team removeObjectAtIndex:m];
                                        }
                                    }
                                                                        
                                    [self performSegueWithIdentifier:@"connected" sender:sender];
                                  }
                                  failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                     NSLog(@"%@", error);
                                  }
                           ];

                       }
                       failure:^(RKObjectRequestOperation *operation, NSError *error) {
                            NSLog(@"%@", error);
                       }
                ];
            }
            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                NSLog(@"%@", error);
            }
         ];
    }
}

//- (BOOL)shouldAutorotate {
//    return NO;
//}


@end
