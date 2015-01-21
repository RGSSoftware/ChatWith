//
//  RGSPlaygroundViewController.m
//  ChatWith
//
//  Created by PC on 12/28/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSPlaygroundViewController.h"

#import "RGSMessage.h"

#import "RGSChatService.h"

@interface RGSPlaygroundViewController ()

@end

@implementation RGSPlaygroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithSqliteStoreNamed:[MagicalRecord defaultStoreName]];
    
//    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextWithStoreCoordinator:coordinator];
    
//    RGSMessage *message = [RGSMessage MR_createInContext:[NSManagedObjectContext MR_contextWithStoreCoordinator:coordinator]];
//    message.body = @"message in secondary context";
//    [message.managedObjectContext MR_saveOnlySelfAndWait];
//    [context MR_saveOnlySelfWithCompletion:nil];
//    [context MR_saveOnlySelfAndWait];
    
    
    NSLog(@"------%@",[QBSettings serverChatDomain]);
    BOOL bl = [[RGSChatService shared] canReach];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
   
    NSString *qbsetting = [[QBApplication sharedApplication] restAPIVersion];
    
    
//    {
//        for(int i = 0; i > 10; i++){
//            RGSMessage *message = [RGSMessage MR_createEntity];
//            message.body = @"message in main context";
//        }
//    
//    }
//    
//    NSManagedObjectContext *context2 = [NSManagedObjectContext MR_contextWithStoreCoordinator:coordinator];
//    NSArray *allMessage = [RGSMessage MR_findAllInContext:context2];
//    RGSMessage *firstMessage = [allMessage firstObject];
//    NSLog(@"%@", firstMessage.body);
    
    
    
    
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    return YES;
//}

- (IBAction)search:(id)sender {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    filters[@"filter"] = @[[NSString stringWithFormat:@"string login le %@", self.textField.text]];
    
    [QBRequest usersWithExtendedRequest:filters page:[QBGeneralResponsePage responsePageWithCurrentPage:1 perPage:10] successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *users) {
        NSLog(@"all good");
        self.resultLabel.text = @"";
        [users enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop)
        {
            if (idx == 0) {
                 self.resultLabel.text = [self.resultLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", ((QBUUser *)item).login]];
            } else {
                self.resultLabel.text = [self.resultLabel.text stringByAppendingString:[NSString stringWithFormat:@", %@", ((QBUUser *)item).login]];
            }
         }];
        
    } errorBlock:^(QBResponse *response) {
        NSLog(@"ERORR");
    }];
    
//    [QBRequest userWithLogin:self.textField.text successBlock:^(QBResponse *response, QBUUser *user) {
//        NSLog(@"all good");
//    } errorBlock:^(QBResponse *response) {
//        NSLog(@"ERORR");
//    }];
    
}
- (IBAction)convert:(id)sender {
    self.resultLabel.text = NSStringFromCGRect([self.redView convertRect:self.greenView.frame toView:self.view]);
    
}
@end
