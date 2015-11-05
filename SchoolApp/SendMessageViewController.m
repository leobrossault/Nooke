//
//  SendMessageViewController.m
//  SchoolApp
//
//  Created by Léo Brossault on 19/04/2015.
//  Copyright (c) 2015 Léo Brossault. All rights reserved.
//

#import "Message.h"
#import "SendMessageViewController.h"
#import "BookReaderController.h"
#import "TeamViewController.h"
#import <RestKit/RestKit.h>

@interface SendMessageViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleMessage;
@property (weak, nonatomic) IBOutlet UITextField *objectMessage;
@property (weak, nonatomic) IBOutlet UITextView *textMessage;

@end

@implementation SendMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"goToTeamFromMessage"]){
        SendMessageViewController *controller = (SendMessageViewController *)segue.destinationViewController;
        controller.myPupil = self.myPupil;
        controller.myBook = self.myBook;
        controller.team = self.team;
    } else if([segue.identifier isEqualToString:@"goToReadFromMsg"]){
        BookReaderController *controller = (BookReaderController *)segue.destinationViewController;
        controller.myPupil = self.myPupil;
        controller.myBook = self.myBook;
        controller.team = self.team;
    }
}

- (IBAction)sendMessage:(id)sender {
    if ([self.titleMessage.text length] != 0 && [self.objectMessage.text length] != 0 && [self.textMessage.text length] != 0) {
        Message *message = [Message new];
        message.author = self.myPupil._id;
        message.authorName = self.myPupil.firstName;
        message.title = self.titleMessage.text;
        message.object = self.objectMessage.text;
        message.text = self.textMessage.text;
        message.team = self.myPupil.team;
        
        RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[Message class]];
        [responseMapping addAttributeMappingsFromArray:@[@"author", @"authorName", @"title", @"object", @"text", @"team"]];
        NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
        
        RKResponseDescriptor *messageDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodAny pathPattern:@"/app/send/message" keyPath:@"message" statusCodes:statusCodes];
        
        RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
        [requestMapping addAttributeMappingsFromArray:@[@"author", @"authorName", @"title", @"object", @"text", @"team"]];
        
        RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[Message class] rootKeyPath:@"message" method:RKRequestMethodAny];
        
        RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://macbook-pro-de-leo.local:8080"]];
        
        [manager addRequestDescriptor:requestDescriptor];
        [manager addResponseDescriptor:messageDescriptor];

        [manager postObject:message path:@"/app/send/message" parameters:nil success:nil failure:nil];
        
        [self performSegueWithIdentifier:@"goToTeamFromMessage" sender:sender];
    } else {
        NSLog(@"fail");
    }
}

- (IBAction)backToTeam:(id)sender {
    if ([self.fromBook isEqualToString: @"true"]) {
        [self performSegueWithIdentifier:@"goToReadFromMsg" sender:sender];
    } else {
        [self performSegueWithIdentifier:@"goToTeamFromMessage" sender:sender];
    }
}

//- (BOOL)shouldAutorotate {
//    return NO;
//}


@end
