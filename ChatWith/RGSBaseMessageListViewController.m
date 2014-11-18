//
//  RGSBaseMessageListViewController.m
//  ChatWith
//
//  Created by PC on 11/14/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSBaseMessageListViewController.h"

#import "RGSManagedUser.h"
#import "RGSMessage.h"
#import "RGSMessageCell.h"

#import "UIImage+RGSinitWithColor.h"
#import "UIColor+RGSColorWithHexString.h"
#import "UIImage+Resize.h"

#import "LocalStorageService.h"

#import "UIButton+RGSUIBackButton.h"

#import "RGSBaseViewController+RGSSeparatorExtender.h"

#import "CSGrowingTextView.h"

#import "RGSMessageComposerView.h"

const int maxTextWidth = 260;
const int cellContentMargin = 5;
const int leftRightMargin = cellContentMargin * 2;
const int topBottonMargin = cellContentMargin * 2;

const int fristCell = 0;
const int navigationSpacing = 65;

@interface RGSBaseMessageListViewController ()

@property (nonatomic, strong)UITableViewCell *referenceCell;

@property (nonatomic, strong)RGSManagedUser *currentUser;


@end

@implementation RGSBaseMessageListViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo =
    [[_fetchedResultsController sections] objectAtIndex:section];
    
    int rowCount = [sectionInfo numberOfObjects];
    return rowCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RGSMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    RGSMessage *message = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.body.text = message.body;
    
    if([message.sender isEqual:self.currentUser]){
        
        float labelWithtextHeight = [self heightWithText:message.body maxWidth:(maxTextWidth - 5)];
        cell.body.frame = CGRectMake(CGRectGetWidth(cell.frame) - maxTextWidth - 5,
                                     cellContentMargin,
                                     maxTextWidth - 5,
                                     labelWithtextHeight);
        if(labelWithtextHeight <= 24){
            [cell.body setTextAlignment:NSTextAlignmentRight];
        }
    } else {
        cell.body.frame = CGRectMake(cellContentMargin,
                                     cellContentMargin,
                                     maxTextWidth - leftRightMargin,
                                     [self heightWithText:message.body
                                                 maxWidth:(maxTextWidth - leftRightMargin)]);
    }
    if(indexPath.row == fristCell){cell.body.frame = [self add:navigationSpacing toRectY:cell.body.frame];}
    
    static NSDateFormatter *todayDateFormatter = nil;
    if (todayDateFormatter == nil) {
        todayDateFormatter = [NSDateFormatter new];
        todayDateFormatter.dateFormat = @"h:mm a";
    }
    cell.timeLabel.text = [todayDateFormatter stringFromDate:message.date];
    cell.timeLabel.hidden = YES;
    
    
    return cell;
    
}
-(CGRect)add:(float)increase toRectY:(CGRect)rect{
    return CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect) + increase, CGRectGetWidth(rect), CGRectGetHeight(rect));
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RGSMessage *message = [_fetchedResultsController objectAtIndexPath:indexPath];
    float height = [self heightWithText:message.body maxWidth:(maxTextWidth - leftRightMargin)] + topBottonMargin;
    
    if(indexPath.row == fristCell){
        return height + navigationSpacing;
    }
    return height;
}

-(CGFloat)heightWithText:(NSString *)text maxWidth:(float)maxWidth{
    
    float minBodyHeight = 16.0f;
    float maxBodyHeight = 20000.0f;
    
    CGSize constraint = CGSizeMake(maxWidth, maxBodyHeight);
    
    
    //sizeWithFont:ConstrainedToSize:lineBreakMode: deprecation solution
    //http://stackoverflow.com/questions/21654671/sizewithfont-constrainedtosize-linebreakmode-method-is-deprecated-in-ios-7#21654741
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    CGRect textRect = [text boundingRectWithSize:constraint
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSParagraphStyleAttributeName: paragraphStyle.copy,NSFontAttributeName:[UIFont systemFontOfSize:16]}
                                         context:nil];
    
    return MAX(CGRectGetHeight(textRect), minBodyHeight);
}

-(NSManagedObjectContext *)managedObjectContext{
    return [NSManagedObjectContext MR_defaultContext];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self fullyExtendTableViewCellSeparator:cell];
}
//Part-2
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self fullyExtendTableViewSeparator:self.tableView];
}

-(RGSManagedUser *)currentUser{
    if (_currentUser == nil)
    {
        _currentUser = [[LocalStorageService shared] savedUser];
    }
    return _currentUser;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(self.receiver){
        self.navigationItem.title = self.receiver.fullName;
    }
    
    UIButton *backButton = [UIButton buttonWithCustomBackButton];
    [backButton addTarget:self action:@selector(toChatListScreen:)
         forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"Chats" forState:UIControlStateNormal];
    backButton.titleLeftEdgeInset = -25;
    backButton.imageLeftEdgeInset = -35;

     UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
     
     self.navigationItem.leftBarButtonItem = barButton;
    
    [self registerForKeyboardNotifications];

    [NSFetchedResultsController deleteCacheWithName:nil];
    self.fetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"chat", self.chat];
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    } else {
        [self.tableView setNeedsDisplay];
    }
}

- (void)registerForKeyboardNotifications
{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWasShown:)
//                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHidden:)
                                                 name:UIKeyboardDidHideNotification object:nil];
    
}

-(void)keyboardWillChangeFrame:(NSNotification *)aNotification{
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    [UIView animateWithDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
//                          delay:0
//                        options:UIViewAnimationOptionCurveLinear
//                     animations:^{
//        self.messageComposerView.frame = CGRectMake(CGRectGetMinX(self.messageComposerView.frame), CGRectGetMinY(self.messageComposerView.frame) - kbSize.height, CGRectGetWidth(self.messageComposerView.frame), CGRectGetHeight(self.messageComposerView.frame));
//    }
//                     completion:^(BOOL finished) {
//        
//    }];
    
    CGRect endFrame;
    float duration = [[[aNotification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [[[aNotification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endFrame];
    endFrame = [self.view convertRect:endFrame fromView:nil];
    float y = (endFrame.origin.y > self.view.bounds.size.height ? self.view.bounds.size.height-44 : endFrame.origin.y-CGRectGetHeight(self.messageComposerView.frame));
    
    
    [UIView animateWithDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0
                        options:([[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16)
                     animations:^{
                         self.messageComposerView.frame = CGRectMake(0, y, CGRectGetWidth(self.messageComposerView.frame), CGRectGetHeight(self.messageComposerView.frame));
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    self.messageComposerView.frame = CGRectMake(CGRectGetMinX(self.messageComposerView.frame), CGRectGetMinY(self.messageComposerView.frame) - kbSize.height, CGRectGetWidth(self.messageComposerView.frame), CGRectGetHeight(self.messageComposerView.frame));
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    scrollView.contentInset = contentInsets;
//    scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardDidHidden:(NSNotification*)aNotification
{
}

-(NSFetchedResultsController *)fetchedResultsController{
    
    if (_fetchedResultsController == nil)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[RGSMessage MR_entityDescription]];
        [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO]]];
        _currentUser = [[LocalStorageService shared] savedUser];
        
        [fetchRequest setFetchBatchSize:20];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
        _fetchedResultsController.delegate = self;
        
        return _fetchedResultsController;
    }
    return _fetchedResultsController;
}

-(void)toChatListScreen:(id)sender
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass",
                                           NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end
