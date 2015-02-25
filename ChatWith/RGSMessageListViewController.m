//
//  RGSBaseMessageListViewController.m
//  ChatWith
//
//  Created by PC on 11/14/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSMessageListViewController.h"

#import "RGSMessageCell.h"

#import "RGSMessageAttachmentViewController.h"

#import "RGSUser.h"
#import "RGSMessage.h"
#import "RGSImage.h"
#import "RGSMessage.h"
#import "RGSChat.h"

#import "RGSMessageComposeImage.h"
#import "RGSMessageComposerView.h"
#import "CSGrowingTextView.h"
#import "RGSBackBarButtonItem.h"

#import "RGSLogReport.h"
#import "RGSLogService.h"
#import "LocalStorageService.h"
#import "RGSChatService.h"

const int maxTextWidth = 260;
const int cellContentMargin = 5;
const int leftRightMargin = cellContentMargin * 2;
const int topBottonMargin = cellContentMargin * 2;

const int fristCell = 0;
const int navigationSpacing = 65;

struct {
    int messageComposer;
    int keyBoard;
} messageComposerWithKeyBoardHeight;

@interface RGSMessageListViewController ()

@property (nonatomic, strong)UITableViewCell *referenceCell;

@property (nonatomic, strong)RGSUser *currentUser;

@property (nonatomic, strong)UIView *messageComposerViewWithKeyboardImage;
@property (nonatomic, strong)UIView *keyboard;

@property (nonatomic)double keyboardAnimationDuration;
@property (nonatomic)int keyboardAnimationCurve;

@property(nonatomic, strong)NSMutableArray *messageComposeImages;

@property (nonatomic, assign) BOOL shouldScrollToLastRow;

@end

@implementation RGSMessageListViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.messageComposeImages = [NSMutableArray new];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:nil queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *note) {
                                                          for(NSManagedObject *object in [[note userInfo] objectForKey:NSInsertedObjectsKey]){
                                                              if([object.entity.name isEqualToString:NSStringFromClass([RGSMessage class])]){
                                                                  
                                                                  [NSFetchedResultsController deleteCacheWithName:nil];
                                                                  
                                                                  NSError *error;
                                                                  if (![[self fetchedResultsController] performFetch:&error]) {
                                                                      // Update to handle the error appropriately.
                                                                      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                                                                  } else {
                                                                      [self.tableView reloadData];
                                                                  }
                                                                  
                                                                  break;
                                                              }
                                                          }
                                                          
                                                      }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _shouldScrollToLastRow = YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(self.receiver){
        self.navigationItem.title = self.receiver.fullName;
    }
    
    RGSBackBarButtonItem *backBarButtonItem = [RGSBackBarButtonItem new];
//    [backBarButtonItem addTarget:self action:@selector(toChatListScreen:) forControlEvents:UIControlEventTouchUpInside];
//    [backBarButtonItem setTitle:@"Chats"];
//    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    self.tableView.contentInset = [self messageComposerViewInsert];
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(navigationSpacing, 0, CGRectGetHeight(self.messageComposerView.frame), 0);
    
    [self registerForKeyboardNotifications];
    
    [NSFetchedResultsController deleteCacheWithName:nil];
    self.fetchedResultsController.fetchRequest.predicate = [self currentChatPredicate];
    
    [self fetchedResultsControllerWithFetchBlock:^(BOOL success, NSError *error) {
        if(!error && success)[self.tableView setNeedsDisplay];
    }];
    
    [self.tableView addGestureRecognizer:[self closeKeyboardPanGestureRecognizer]];
    
    
    self.messageComposerViewWithKeyboardImage = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.messageComposerView.frame), CGRectGetWidth(self.messageComposerView.frame), CGRectGetHeight([self findKeyboard].frame))];
    [self.view addSubview:self.messageComposerViewWithKeyboardImage];
    
    [self.view bringSubviewToFront:self.messageComposerView];
    self.messageComposerView.delegate = self;
    [self.messageComposerView.sendMessagebButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self scrollToBottomWithAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSSet *unreadMessages = [self.chat.messages filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"isUnread == YES"]];
    if(unreadMessages.count > 0){
        for (RGSMessage *message in unreadMessages) {
            message.isUnread = @(NO);
        }
        [self.chat.managedObjectContext MR_saveOnlySelfAndWait];
    }
    
    [self deRegisterForKeyboardNotifications];
}
#pragma mark - UITableViewDataSource ()
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
    
    
    NSMutableAttributedString *messageWithImage = [[NSMutableAttributedString alloc] initWithString:message.body];
    
    NSRange currentImageRange = NSMakeRange(0, message.body.length);
    if (!message.images.isEmpty) {
        for (int i = 0; i < message.images.count; i++) {
            
            currentImageRange = [message.body rangeOfString:[NSString stringWithUTF8String:"\ufffc"] options:NSLiteralSearch range:currentImageRange];
            
            NSString *space = @" ";
            [messageWithImage replaceCharactersInRange:currentImageRange withString:space];
            
            currentImageRange = NSMakeRange(currentImageRange.location + space.length, message.body.length - space.length);
        }
        
    } else if (message.image){
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:[self textAttachmentWithImage:message.image.imageData]
                                                                                                Font:cell.body.font
                                                                                               Color:cell.body.textColor];
        
        [messageWithImage replaceCharactersInRange:[message.body rangeOfString:[NSString stringWithUTF8String:"\ufffc"]] withAttributedString:attrStringWithImage];
    }
    
    cell.body.attributedText = messageWithImage;
    
    
    [cell.body mas_remakeConstraints:^(MASConstraintMaker *make) {
        float labelWithtextHeight = [message.body boundingRectWithSize:CGSizeMake(287, CGFLOAT_MAX) font:[UIFont systemFontOfSize:18]].size.height;
        make.height.equalTo(@(labelWithtextHeight));
    }];
    
//    if([message.sender isEqual:self.currentUser]){
//        
//        [cell.body mas_remakeConstraints:^(MASConstraintMaker *make) {
//            float labelWithtextHeight = [message.body boundingRectWithSize:CGSizeMake(287, CGFLOAT_MAX) font:[UIFont systemFontOfSize:18]].size.height;
//            make.height.equalTo(@(labelWithtextHeight));
//        }];
//        
//        
////        cell.body.frame = CGRectMake(CGRectGetWidth(cell.frame) - maxTextWidth - 5,
////                                     cellContentMargin,
////                                     maxTextWidth - 5,
////                                     labelWithtextHeight);
//        if(message.image){
//            [cell.body setTextAlignment:NSTextAlignmentRight];
//        }
////        else {
////            if(labelWithtextHeight <= 24){
////                [cell.body setTextAlignment:NSTextAlignmentRight];
////            }
////        }
//        
//    } else {
//        [cell.body mas_remakeConstraints:^(MASConstraintMaker *make) {
//            float labelWithtextHeight = [message.body boundingRectWithSize:CGSizeMake(287, CGFLOAT_MAX) font:[UIFont systemFontOfSize:18]].size.height;
//            make.height.equalTo(@(labelWithtextHeight));
//        }];
//        
//        cell.body.frame = CGRectMake(cellContentMargin,
//                                     cellContentMargin,
//                                     maxTextWidth - leftRightMargin,
//                                     [message.body boundingRectWithSize:CGSizeMake(287, CGFLOAT_MAX) font:[UIFont systemFontOfSize:18]].size.height);
//    }
    if(indexPath.row == fristCell){cell.body.frame = [self add:navigationSpacing toRectY:cell.body.frame];}
    
    static NSDateFormatter *todayDateFormatter = nil;
    if (todayDateFormatter == nil) {
        todayDateFormatter = [NSDateFormatter new];
        todayDateFormatter.dateFormat = @"h:mm a";
    }
    cell.timeLabel.text = [todayDateFormatter stringFromDate:message.date];
    cell.timeLabel.hidden = YES;
    
    cell.contentView.layer.borderWidth = 1;
    cell.contentView.layer.borderColor = [[UIColor redColor]CGColor];
    
    cell.body.layer.borderWidth = 1;
    
    
    return cell;
    
}

#pragma mark - UITableViewDelegate ()
//Part-1
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self fullyExtendTableViewCellSeparator:cell];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RGSMessage *message = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    
     NSMutableAttributedString *messageWithImage = [[NSMutableAttributedString alloc] initWithString:message.body];
    
    NSRange currentImageRange = NSMakeRange(0, message.body.length);
    if (!message.images.isEmpty) {
        for (int i = 0; i < message.images.count; i++) {
        
            currentImageRange = [message.body rangeOfString:[NSString stringWithUTF8String:"\ufffc"] options:NSLiteralSearch range:currentImageRange];
            
            NSString *space = @" ";
            [messageWithImage replaceCharactersInRange:currentImageRange withString:space];
            
            currentImageRange = NSMakeRange(currentImageRange.location + space.length, message.body.length - space.length);
        }

    } else if (message.image){
       
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:[self textAttachmentWithImage:message.image.imageData]
                                                                                                Font:[UIFont systemFontOfSize:20]
                                                                                               Color:[UIColor whiteColor]];
        
        [messageWithImage replaceCharactersInRange:[message.body rangeOfString:[NSString stringWithUTF8String:"\ufffc"]] withAttributedString:attrStringWithImage];
    }
    
//    float height = [self heightWithAttributedText:messageWithImage maxWidth:(maxTextWidth - leftRightMargin)] + topBottonMargin;
    
    float height = [message.body boundingRectWithSize:CGSizeMake(287, CGFLOAT_MAX) font:[UIFont systemFontOfSize:18]].size.height;
    return height + topBottonMargin + 10;
}

-(NSTextAttachment *)textAttachmentWithImage:(NSData *)imageData{
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageWithData:imageData];
    textAttachment.image = [textAttachment.image resizedImage:CGSizeMake(80,140)];
    return textAttachment;
}

-(CGFloat)heightWithAttributedText:(NSAttributedString *)text maxWidth:(float)maxWidth{
    
    float minBodyHeight = 16.0f;
    float maxBodyHeight = 20000.0f;
    
    CGSize constraint = CGSizeMake(maxWidth, maxBodyHeight);
    
    
    //sizeWithFont:ConstrainedToSize:lineBreakMode: deprecation solution
    //http://stackoverflow.com/questions/21654671/sizewithfont-constrainedtosize-linebreakmode-method-is-deprecated-in-ios-7#21654741
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    CGRect textRect = [text boundingRectWithSize:constraint
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                         context:nil];
    
    return MAX(CGRectGetHeight(textRect), minBodyHeight);

    
}

-(CGRect)add:(float)increase toRectY:(CGRect)rect{
    return CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect) + increase, CGRectGetWidth(rect), CGRectGetHeight(rect));
}


//Part-2
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self fullyExtendTableViewSeparator:self.tableView];
}

-(NSManagedObjectContext *)managedObjectContext{
    return [NSManagedObjectContext MR_defaultContext];
}

-(RGSUser *)currentUser{
    if (_currentUser == nil)
    {
        _currentUser = [[LocalStorageService shared] savedUser];
    }
    return _currentUser;
}

- (UIEdgeInsets)messageComposerViewInsert {
    UIEdgeInsets tableViewInsert = self.tableView.contentInset;
    tableViewInsert.bottom = CGRectGetHeight(self.messageComposerView.frame);
    return tableViewInsert;
}
#pragma mark - fetchedResultsController ()
-(NSFetchedResultsController *)fetchedResultsController{
    
    if (_fetchedResultsController == nil)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[RGSMessage MR_entityDescription]];
        [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES]]];
        _currentUser = [[LocalStorageService shared] savedUser];
        
        [fetchRequest setFetchBatchSize:20];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
        _fetchedResultsController.delegate = self;
        
        return _fetchedResultsController;
    }
    return _fetchedResultsController;
}

- (void)initFetchedResultsControllerWithFetch {
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    } else {
        [self.tableView setNeedsDisplay];
    }
}

- (void)fetchedResultsControllerWithFetchBlock:(void (^)(BOOL success, NSError *error))completionBlock {
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        completionBlock(NO, error);
    } else {
        completionBlock(YES, error);
    }
}

-(NSPredicate *)currentChatPredicate{
    return [NSPredicate predicateWithFormat:@"%K = %@", @"chat", self.chat];
}

#pragma mark - gestureRecognizer ()
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (UIPanGestureRecognizer *)closeKeyboardPanGestureRecognizer {
    UIPanGestureRecognizer *pangestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboardPanGestureAction:)];
    pangestureRecognizer.minimumNumberOfTouches = 1;
    pangestureRecognizer.delegate = self;
    return pangestureRecognizer;
}

- (void)closeKeyboardPanGestureAction:(UIPanGestureRecognizer*) panGestureRecognizer {
    UIGestureRecognizerState gestureRecognizerState = panGestureRecognizer.state;
    
    CGPoint userTouchCoordinate = [panGestureRecognizer locationInView:nil];
    if ([self.messageComposerView.messageTextView.internalTextView isFirstResponder]) {
        if (gestureRecognizerState == UIGestureRecognizerStateBegan) {
            
            [self performUserScrollSetUp];
        }
        
        if (gestureRecognizerState == UIGestureRecognizerStateChanged){
            
            
            if (userTouchCoordinate.y < CGRectGetMinY(self.messageComposerViewWithKeyboardImage.frame)) {
                self.messageComposerViewWithKeyboardImage.frame = [self messageComposerViewWithKeyboardImageframeWithY:[self messgeComposerViewMinY]];
            }
            if (userTouchCoordinate.y >= [self messgeComposerViewMinY]) {
                self.messageComposerViewWithKeyboardImage.frame = [self messageComposerViewWithKeyboardImageframeWithY:userTouchCoordinate.y];
            }
        }
        else if  (gestureRecognizerState == UIGestureRecognizerStateEnded
                  || gestureRecognizerState == UIGestureRecognizerStateCancelled){
            
            if (userTouchCoordinate.y >= [self messgeComposerViewMinY]) {
                
                [self.messageComposerView.messageTextView.internalTextView resignFirstResponder];
                
                [UIView animateWithDuration:self.keyboardAnimationDuration delay:0
                                    options:self.keyboardAnimationCurve << 16
                                 animations:^{
                                     self.messageComposerViewWithKeyboardImage.frame = [self messageComposerViewWithKeyboardImageframeWithY:[self messgeComposerViewMinY]];
                                     
                                 } completion:^(BOOL finished) {
                                     [self performUserScrollTeardown];
                                 }];
            } else {
                [self performUserScrollTeardown];
            }
        }
    }
}
-(CGRect)messageComposerViewWithKeyboardImageframeWithY:(CGFloat)y{
    return CGRectMake(0, y, CGRectGetWidth(self.messageComposerView.frame), [self messageComposerViewAndKeyboardHeight]);
}

-(CGFloat)messageComposerViewAndKeyboardHeight{
    return CGRectGetHeight(self.messageComposerView.backGroundView.frame) + CGRectGetHeight(self.keyboard.frame);
}

-(CGFloat)messgeComposerViewMinY{
    return CGRectGetMinY(self.messageComposerView.frame) - (CGRectGetHeight(self.messageComposerView.backGroundView.frame) - CGRectGetHeight(self.messageComposerView.frame));
}
-(void)performUserScrollSetUp{
    self.keyboard = [self findKeyboard];
    self.messageComposerViewWithKeyboardImage.frame = [self messageComposerViewWithKeyboardImageframeWithY:[self messgeComposerViewMinY]];
    
    UIView *messageComposerViewImage = [self createMessageComposerViewImage];
    
    UIView *keyboardViewImage = [self.keyboard snapshotViewAfterScreenUpdates:NO];
    CGRect kvif = keyboardViewImage.frame;
    kvif.origin = CGPointMake(0, CGRectGetHeight(messageComposerViewImage.frame));
    keyboardViewImage.frame = kvif;
    
    UIView *container = [[UIView alloc] initWithFrame:[self messageComposerViewWithKeyboardImageframeWithY:0]];
    [container addSubview:messageComposerViewImage];
    [container addSubview:keyboardViewImage];
    
    [self.messageComposerViewWithKeyboardImage addSubview:container];
    
    self.keyboard.hidden = YES;
    self.messageComposerView.hidden = YES;
    self.messageComposerViewWithKeyboardImage.hidden = NO;
    
}

-(void)performUserScrollTeardown{
    self.messageComposerViewWithKeyboardImage.hidden = YES;
    [self.messageComposerViewWithKeyboardImage.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.keyboard.hidden = NO;
    self.keyboard = nil;
    
    self.messageComposerView.hidden = NO;
}
-(UIView *)createMessageComposerViewImage{
    UIView *messageComposerViewImage = [self.messageComposerView.backGroundView snapshotViewAfterScreenUpdates:NO];
    CGRect mcvif = messageComposerViewImage.frame;
    mcvif.origin = CGPointMake(0, 1);
    messageComposerViewImage.frame = mcvif;
    
    [self addViewAsImage:self.messageComposerView.messageTextView ToView:messageComposerViewImage withYinsert:4];
    [self addViewAsImage:self.messageComposerView.addImageButton ToView:messageComposerViewImage withYinsertFromBottom:2];
    [self addViewAsImage:self.messageComposerView.sendMessagebButton ToView:messageComposerViewImage withYinsertFromBottom:1];
    
    return messageComposerViewImage;
}

-(void)addKeyboardAsImageToView:(UIView *)toView withYInsert:(int)yInsert{
    UIView *keyboardViewImage = [self.keyboard snapshotViewAfterScreenUpdates:NO];
    CGRect kvif = keyboardViewImage.frame;
    kvif.origin = CGPointMake(0, yInsert);
    keyboardViewImage.frame = kvif;
    [toView addSubview:keyboardViewImage];
}

-(void)addmessageViewFromMessageComposerViewAsImageTo:(UIView *)toView{
    UIView *messageImage = [self.messageComposerView.messageTextView snapshotViewAfterScreenUpdates:NO];
    CGRect meif = self.messageComposerView.messageTextView.frame;
    meif.origin = CGPointMake(CGRectGetMinX(self.messageComposerView.messageTextView.frame), 4);
    messageImage.frame = meif;
    [toView addSubview:messageImage];
}


-(void)addViewAsImage:(UIView *)view ToView:(UIView *)toView withYinsert:(int)yInsert{
    UIView *messageImage = [view snapshotViewAfterScreenUpdates:NO];
    CGRect meif = view.frame;
    meif.origin = CGPointMake(CGRectGetMinX(view.frame), yInsert);
    messageImage.frame = meif;
    [toView addSubview:messageImage];
    
}

-(void)addViewAsImage:(UIView *)view  ToView:(UIView *)toView withYinsertFromBottom:(int)yInsert{
    UIView *messageImage = [view snapshotViewAfterScreenUpdates:NO];
    CGRect meif = view.frame;
    meif.origin = CGPointMake(CGRectGetMinX(view.frame), CGRectGetMaxY(toView.frame) - CGRectGetMaxY(view.frame) - yInsert);
    messageImage.frame = meif;
    [toView addSubview:messageImage];
    
}

#pragma mark - Segue ()
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.destinationViewController isKindOfClass:[RGSMessageAttachmentViewController class]]) {
        RGSMessageAttachmentViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.delegate = self;
    }
}

-(void)toChatListScreen:(id)sender{
    [self performSegueWithIdentifier:@"unwindToChatLis" sender:self];
}

#pragma mark - UIKeyboard ()
-(void)keyboardWillChangeFrame:(NSNotification *)aNotification{
    
    NSDictionary* info = [aNotification userInfo];
    CGRect endFrame;
    [[info valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endFrame];
    endFrame = [self.view convertRect:endFrame fromView:self.view];

    self.messageBottomSpace.constant = CGRectGetHeight(self.view.frame) - endFrame.origin.y;
    
    messageComposerWithKeyBoardHeight.messageComposer = CGRectGetHeight(self.messageComposerView.backGroundView.frame);
    messageComposerWithKeyBoardHeight.keyBoard = self.messageBottomSpace.constant;
                                                                        
    
    UIEdgeInsets tableViewInsert = self.tableView.contentInset;
    tableViewInsert.bottom = messageComposerWithKeyBoardHeight.messageComposer + messageComposerWithKeyBoardHeight.keyBoard;
    self.tableView.contentInset = tableViewInsert;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(navigationSpacing, 0, tableViewInsert.bottom, 0);
    
    [self scrollToBottom];
    
    [UIView animateWithDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0
                        options:(([[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16) | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{

                         [self.messageComposerView setNeedsUpdateConstraints];
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
    
    self.keyboardAnimationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.keyboardAnimationCurve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
}

- (void)keyboardDidHidden:(NSNotification*)aNotification
{
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

- (void)deRegisterForKeyboardNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [center removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}


-(UIView*)findKeyboard
{
    UIView *keyboard = nil;
    for (UIWindow* window in [UIApplication sharedApplication].windows)
    {
        if ([NSStringFromClass([window class]) isEqualToString:@"UITextEffectsWindow"])
        {
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
#pragma mark - RGSMessageComposerViewDelegate ()
- (BOOL)messageComposerView:(RGSMessageComposerView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    RGSMessageComposeImage *mark;
    for(RGSMessageComposeImage *storedImage in self.messageComposeImages){
        if(range.length == 1 && [text isEqualToString:@""]){
            if(storedImage.location == range.location){
                mark = storedImage;
            } else if (storedImage.location > range.location){
                if(!mark){
                    storedImage.location--;
                }
                
            }
        } else if (storedImage.location >= range.location){
            storedImage.location++;
        }
    }
    if(mark){
        for(RGSMessageComposeImage *storedImage in self.messageComposeImages){
            if(storedImage.location > mark.location){
                storedImage.location--;
                storedImage.index--;
            }
        }
        [self.messageComposeImages removeObject:mark];
    }
    
    return YES;
}

- (void)messageComposerView:(RGSMessageComposerView *)textView willChangeHeight:(CGFloat)height{
    
    messageComposerWithKeyBoardHeight.messageComposer = height;
    
    UIEdgeInsets tableViewInsert = self.tableView.contentInset;
    tableViewInsert.bottom = messageComposerWithKeyBoardHeight.messageComposer + messageComposerWithKeyBoardHeight.keyBoard;
    self.tableView.contentInset = tableViewInsert;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(navigationSpacing, 0, tableViewInsert.bottom, 0);
    
    [self scrollToBottom];
}

#pragma mark - RGSMessageAttachmentViewControllerDelegate ()
-(void)RGSMessageAttachmentViewController:(RGSMessageAttachmentViewController *)messageAttachmentViewController imageAttachment:(UIImage *)imageAttachment{
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = imageAttachment;
    textAttachment.image = [textAttachment.image resizedImage:CGSizeMake(80,140)];
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment
                                                                                            Font:self.messageComposerView.messageTextView.internalTextView.font
                                                                                           Color:self.messageComposerView.messageTextView.internalTextView.textColor];
    
    NSMutableAttributedString *imageWithNewLine = [[NSMutableAttributedString alloc] initWithString:@"I" attributes:@{NSFontAttributeName : self.messageComposerView.messageTextView.internalTextView.font}];
    
    [imageWithNewLine replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:attrStringWithImage];
    
    NSRange currentRange = self.messageComposerView.messageTextView.internalTextView.selectedRange;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.messageComposerView.messageTextView.internalTextView.attributedText];
    
    [attributedString replaceCharactersInRange:currentRange withAttributedString:imageWithNewLine];
    self.messageComposerView.messageTextView.internalTextView.attributedText = attributedString;
    
    
    RGSMessageComposeImage *currentImage = [RGSMessageComposeImage new];
    currentImage.image = imageAttachment;
    currentImage.location = currentRange.location;
    if(self.messageComposeImages.count == 0){
        currentImage.index = 0;
    } else {
        for(RGSMessageComposeImage *storedImage in self.messageComposeImages){
            if(storedImage.location >= currentImage.location){
                currentImage.index = storedImage.index;
                
                storedImage.location++;
                storedImage.index++;
            } else {
                currentImage.index = storedImage.index + 1;
            }
        }
    }
    [self.messageComposeImages addObject:currentImage];
    
    
    [self.messageComposerView.messageTextView updateLayout];
    
    [self.messageComposerView.messageTextView.internalTextView setSelectedRange:NSMakeRange(currentRange.location + 1, currentRange.length)];
}



-(void)sendMessage:(id)sender{    
    RGSMessage *message = [RGSMessage MR_createEntity];
    message.sender = self.currentUser;
    message.receiver = self.receiver;
    message.chat = self.chat;
    message.body = self.messageComposerView.messageTextView.internalTextView.text;
//    message.sendStatus = SendStatusSending;
    
    message.date = [NSDate date];
    
    NSMutableArray *messageImages = [NSMutableArray new];
    for(RGSMessageComposeImage *sortedImage in self.messageComposeImages){
        RGSImage *image = [RGSImage MR_createEntity];
        image.imageData = UIImageJPEGRepresentation(sortedImage.image,0.0);
        image.index = [NSNumber numberWithInteger:sortedImage.index];
        image.message = message;
        
        [message addImagesObject:image];
        
        RGSMessage *messageImage = [RGSMessage MR_createEntity];
        messageImage.sender = self.currentUser;
        messageImage.receiver = self.receiver;
        messageImage.chat = self.chat;
        messageImage.body = [NSString stringWithUTF8String:"\ufffc"];
        messageImage.image = image;
        
        image.messageImage = messageImage;
        
        [messageImages addObject:messageImages];
    }
    
    __block RGSLogReport *logReport;
                #warning Refactor error handle to new standard
//    [message.managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
//        if(success){
//            self.messageComposerView.messageTextView.internalTextView.text = nil;
//            [self.messageComposeImages removeAllObjects];
//            
//            if([[RGSChatService shared] canReach]){
////                [[RGSChatService shared] sendMessage:message];
//
//            } else {
//                message.sendStatus = SendStatusError;
//                
//                logReport = [self logReportWithFailureReason:@"QBSystem is not reachable"];
//                [logReport.managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
//                    if(success)[RGSLogService sendLog:logReport successBlock:nil];
//
//                }];
//              }
//            
//            
//        } else if (error){
//            #warning need implementation. Show message "an error has occured, please report for a quick fix" to user. 
//            logReport = [self logReportWithFailureReason:[error localizedFailureReason]];
//            [logReport.managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
//                if(success)[RGSLogService sendLog:logReport successBlock:nil];
//                
//            }];
//        }
//    }];
    
    
    
}

//-(RGSLogReport *)logReportWithFailureReason:(NSString *)reason{
//    RGSLogReport *logReport = [RGSLogReport MR_createEntity];
//    logReport.systemVersionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    logReport.userRequest = UserRequestSendMessage;
//    logReport.failureReason = reason;
//    return logReport;
//}

- (void)dealloc {
    [self deRegisterForKeyboardNotifications];
}
#pragma mark - Helpers ()
- (void)scrollToBottom {
    
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -CGRectGetHeight(self.tableView.frame) + self.tableView.contentInset.bottom) animated:NO];
}
- (void)scrollToBottomWithAnimation {
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -CGRectGetHeight(self.tableView.frame) + self.tableView.contentInset.bottom) animated:YES];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView reloadData];
    
    [self scrollToBottomWithAnimation];
}

@end
