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

#import <BlocksKit/BlocksKit.h>

const int maxTextWidth = 260;
const int cellContentMargin = 5;
const int leftRightMargin = cellContentMargin * 2;
const int topBottonMargin = cellContentMargin * 2;

const int fristCell = 0;
const int navigationSpacing = 65;

@interface RGSBaseMessageListViewController ()

@property (nonatomic, strong)UITableViewCell *referenceCell;

@property (nonatomic, strong)RGSManagedUser *currentUser;

@property (nonatomic, strong)UIView *keyboardImage;
@property (nonatomic, strong)UIView *keyboard;

@property (nonatomic)double duration;
@property (nonatomic)int option;

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
    
    UIEdgeInsets tableViewInsert = UIEdgeInsetsMake(0, 0, -CGRectGetHeight(self.messageComposerView.frame), 0);
    self.tableView.contentInset = tableViewInsert;
    
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
    
    UIPanGestureRecognizer *pangestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(displayReloadIndicator:)];
    pangestureRecognizer.minimumNumberOfTouches = 1;
    pangestureRecognizer.delegate = self;
    [self.tableView addGestureRecognizer:pangestureRecognizer];
    
    
    self.keyboardImage = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.messageComposerView.frame), 320, 253)];
//    self.keyboardImage.backgroundColor = [UIColor orangeColor];
//    [self.view insertSubview:self.keyboardImage belowSubview:self.tableView];
    [self.view addSubview:self.keyboardImage];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    

    

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}
- (void) displayReloadIndicator:(UIPanGestureRecognizer*) panGestureRecognizer {
    UIGestureRecognizerState gestureRecognizerState = panGestureRecognizer.state;
    
    CGPoint translation = [panGestureRecognizer locationInView:nil];
    if ([self.messageComposerView.messageTextView.internalTextView isFirstResponder]) {
        if (gestureRecognizerState == UIGestureRecognizerStateBegan) {
            self.keyboard = [self findKeyboard];
            NSLog(@"simple print-----keyboard.subView------{%@}", self.keyboard.subviews);
            self.keyboardImage.frame = CGRectMake(0,
                                                  CGRectGetMinY(self.messageComposerView.frame),
                                                  CGRectGetWidth(self.messageComposerView.frame),
                                                  CGRectGetHeight(self.messageComposerView.frame) + CGRectGetHeight(self.keyboard.frame));
            self.keyboardImage.backgroundColor = [UIColor orangeColor];
            UIView *messageComposerViewImage = [self.messageComposerView snapshotViewAfterScreenUpdates:NO];
            CGRect mcvif = messageComposerViewImage.frame;
            mcvif.origin = CGPointMake(0, 0);
            messageComposerViewImage.frame = mcvif;
            
            UIView *keyboardViewImage = [self.keyboard snapshotViewAfterScreenUpdates:NO];
            CGRect kvif = keyboardViewImage.frame;
            kvif.origin = CGPointMake(0, CGRectGetHeight(messageComposerViewImage.frame));
            keyboardViewImage.frame = kvif;
            
            UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetHeight(self.messageComposerView.frame) + CGRectGetHeight(self.keyboard.frame))];
            //        container.backgroundColor = [UIColor purpleColor];
            [container addSubview:messageComposerViewImage];
            [container addSubview:keyboardViewImage];
            
            
            
            [self.keyboardImage addSubview:container];
            self.keyboardImage.backgroundColor = [UIColor clearColor];
            self.keyboard.hidden = YES;
            self.messageComposerView.hidden = YES;
            self.keyboardImage.hidden = NO;
            
            NSLog(@"simple print-----keyboaudImage.frame------{%@}", NSStringFromCGRect(self.keyboardImage.frame));
        }
        
        if (gestureRecognizerState == UIGestureRecognizerStateChanged){
            
            
            //        UIView *keyboard = [self findKeyboard];
            //        self.keyboardImage.subview
            //        self.keyboardImage = [keyboard snapshotViewAfterScreenUpdates:YES];
            
            if (translation.y < self.keyboardImage.frame.origin.y) {
                self.keyboardImage.frame = CGRectMake(0, CGRectGetMinY(self.messageComposerView.frame), 320, 232);
            }
            if (translation.y >= CGRectGetMinY(self.messageComposerView.frame)) {
                self.keyboardImage.frame = CGRectMake(0, translation.y, 320, 232);
                NSLog(@"simple print-----just changing------{%f}", translation.y);
            }
            
            
            
        }
        else if  (gestureRecognizerState == UIGestureRecognizerStateEnded
                  || gestureRecognizerState == UIGestureRecognizerStateCancelled){
            NSLog(@"simple print-----ending------{%@}", NSStringFromCGPoint(translation));
            
            if (translation.y >= CGRectGetMinY(self.messageComposerView.frame)) {
                
                [self.messageComposerView.messageTextView.internalTextView resignFirstResponder];
                //            self.messageBottomSpace.constant = 0;
                [UIView animateWithDuration:self.duration delay:0
                                    options:self.option << 16
                                 animations:^{
                                     self.keyboardImage.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.messageComposerView.frame), 320, 232);
                                     //                [self.messageComposerView setNeedsUpdateConstraints];
                                     //                [self.view layoutIfNeeded];
                                     
                                 } completion:^(BOOL finished) {
                                     self.keyboardImage.hidden = YES;
                                     [self.keyboardImage.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                     //
                                     self.keyboard.hidden = NO;
                                     self.keyboard = nil;
                                     //
                                     self.messageComposerView.hidden = NO;
                                 }];
            } else {
                [self.keyboardImage.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                
                self.keyboard.hidden = NO;
                self.keyboard = nil;
                
                self.messageComposerView.hidden = NO;
            }
            
            
        }

    }
//    if (gestureRecognizerState == UIGestureRecognizerStateBegan) {
//        self.keyboard = [self findKeyboard];
//        NSLog(@"simple print-----keyboard.subView------{%@}", self.keyboard.subviews);
//        self.keyboardImage.frame = CGRectMake(0,
//                                              CGRectGetMinY(self.messageComposerView.frame),
//                                              CGRectGetWidth(self.messageComposerView.frame),
//                                              CGRectGetHeight(self.messageComposerView.frame) + CGRectGetHeight(self.keyboard.frame));
//        self.keyboardImage.backgroundColor = [UIColor orangeColor];
//        UIView *messageComposerViewImage = [self.messageComposerView snapshotViewAfterScreenUpdates:NO];
//        CGRect mcvif = messageComposerViewImage.frame;
//        mcvif.origin = CGPointMake(0, 0);
//        messageComposerViewImage.frame = mcvif;
//        
//        UIView *keyboardViewImage = [self.keyboard snapshotViewAfterScreenUpdates:NO];
//        CGRect kvif = keyboardViewImage.frame;
//        kvif.origin = CGPointMake(0, CGRectGetHeight(messageComposerViewImage.frame));
//        keyboardViewImage.frame = kvif;
//        
//        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetHeight(self.messageComposerView.frame) + CGRectGetHeight(self.keyboard.frame))];
////        container.backgroundColor = [UIColor purpleColor];
//        [container addSubview:messageComposerViewImage];
//        [container addSubview:keyboardViewImage];
//        
//        
//        
//        [self.keyboardImage addSubview:container];
//        self.keyboardImage.backgroundColor = [UIColor clearColor];
//        self.keyboard.hidden = YES;
//        self.messageComposerView.hidden = YES;
//        self.keyboardImage.hidden = NO;
//        
//        NSLog(@"simple print-----keyboaudImage.frame------{%@}", NSStringFromCGRect(self.keyboardImage.frame));
//    }
//    
//    if (gestureRecognizerState == UIGestureRecognizerStateChanged){
//       
//        
////        UIView *keyboard = [self findKeyboard];
////        self.keyboardImage.subview
////        self.keyboardImage = [keyboard snapshotViewAfterScreenUpdates:YES];
//        
//        if (translation.y < self.keyboardImage.frame.origin.y) {
//            self.keyboardImage.frame = CGRectMake(0, CGRectGetMinY(self.messageComposerView.frame), 320, 232);
//        }
//        if (translation.y >= CGRectGetMinY(self.messageComposerView.frame)) {
//             self.keyboardImage.frame = CGRectMake(0, translation.y, 320, 232);
//             NSLog(@"simple print-----just changing------{%f}", translation.y);
//        }
//       
//        
//        
//    }
//    else if  (gestureRecognizerState == UIGestureRecognizerStateEnded
//        || gestureRecognizerState == UIGestureRecognizerStateCancelled){
//        NSLog(@"simple print-----ending------{%@}", NSStringFromCGPoint(translation));
//        
//        if (translation.y >= CGRectGetMinY(self.messageComposerView.frame)) {
//            
//            [self.messageComposerView.messageTextView.internalTextView resignFirstResponder];
////            self.messageBottomSpace.constant = 0;
//            [UIView animateWithDuration:self.duration delay:0
//                                options:self.option << 16
//                             animations:^{
//                self.keyboardImage.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.messageComposerView.frame), 320, 232);
////                [self.messageComposerView setNeedsUpdateConstraints];
////                [self.view layoutIfNeeded];
//
//            } completion:^(BOOL finished) {
//                self.keyboardImage.hidden = YES;
//                [self.keyboardImage.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
////
//                self.keyboard.hidden = NO;
//                self.keyboard = nil;
////
//                self.messageComposerView.hidden = NO;
//            }];
//        } else {
//            [self.keyboardImage.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//            
//            self.keyboard.hidden = NO;
//            self.keyboard = nil;
//            
//            self.messageComposerView.hidden = NO;
//        }
//
//        
//    }
}

-(UIView*)findKeyboard
{
    UIView *keyboard = nil;
    Class keyboardClass = NSClassFromString(@"UIPeripheralHostView");
    
    for (UIWindow* window in [UIApplication sharedApplication].windows)
    {
//        for (UIView *possibleKeyboard in window.subviews)
//        {
//            if ([[possibleKeyboard description] hasPrefix:@"<UILayoutContainerView"])
//            {
//                
//                
//                for(UIView *keyBoard in possibleKeyboard.subviews){
//                    
//                    if ([[keyBoard description] hasPrefix:@"<UIInputSetHostView"]){
//                        keyboard = keyBoard;
//                        break;
//                    }
//                }
//            }
//        }
        if ([NSStringFromClass([window class]) isEqualToString:@"UITextEffectsWindow"])
        {
//            _keyboardWindow = window;
            for (UIView *possibleKeyboard in window.subviews)
            {
                if ([[possibleKeyboard description] hasPrefix:@"<UIPeripheralHost"] == YES) {
                    keyboard = possibleKeyboard;
                    break;
                }
                else if ([[possibleKeyboard description] hasPrefix:@"<UIInputSetContainerView"] == YES){
                    
                    for(UIView *hostkeyboard in possibleKeyboard.subviews)
                    {
                        if([[hostkeyboard description] hasPrefix:@"<UIInputSetHost"] == YES){
                            keyboard = hostkeyboard;
                            break;
                        }
                    }
                }
            }
        }
    }
    
    return keyboard;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self deregisterForKeyboardNotifications];
}

- (void)registerForKeyboardNotifications
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHidden:)
                                                 name:UIKeyboardDidHideNotification object:nil];
    
}
- (void)deregisterForKeyboardNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [center removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

-(void)keyboardWillChangeFrame:(NSNotification *)aNotification{
    
    NSDictionary* info = [aNotification userInfo];
    CGRect endFrame;
    [[info valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endFrame];
    endFrame = [self.view convertRect:endFrame fromView:self.view];

    self.messageBottomSpace.constant = CGRectGetHeight(self.view.frame) - endFrame.origin.y;
    
    
    [UIView animateWithDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0
                        options:(([[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16) | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{

                         [self.messageComposerView setNeedsUpdateConstraints];
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
    
    self.duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.option =[[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];


}

- (void)keyboardDidHidden:(NSNotification*)aNotification
{
}

- (void)dealloc {
    [self deregisterForKeyboardNotifications];
}


@end
