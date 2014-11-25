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
#import "RGSChatService.h"

#import "UIButton+RGSUIBackButton.h"

#import "RGSBaseViewController+RGSSeparatorExtender.h"

#import "CSGrowingTextView.h"

#import "RGSMessageComposerView.h"

#import <BlocksKit/BlocksKit.h>

#import "NSAttributedString+RGSAttributedStringWithExtras.h"

#import "RGSMessageAttachmentViewController.h"

#import "RGSMessage.h"

#import "RGSImage.h"

#import "UITextView+RGSSelectedRange.h"


const int maxTextWidth = 260;
const int cellContentMargin = 5;
const int leftRightMargin = cellContentMargin * 2;
const int topBottonMargin = cellContentMargin * 2;

const int fristCell = 0;
const int navigationSpacing = 65;

@interface RGSBaseMessageListViewController ()

@property (nonatomic, strong)UITableViewCell *referenceCell;

@property (nonatomic, strong)RGSManagedUser *currentUser;

@property (nonatomic, strong)UIView *messageComposerViewWithKeyboardImage;
@property (nonatomic, strong)UIView *keyboard;

@property (nonatomic)double keyboardAnimationDuration;
@property (nonatomic)int keyboardAnimationCurve;

@property(nonatomic, strong)NSMutableArray *messageComposeTempImages;

@end

@implementation RGSBaseMessageListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(self.receiver){
        self.navigationItem.title = self.receiver.fullName;
    }
    
    self.navigationItem.leftBarButtonItem = [self customBarBackButton];
    
    self.tableView.contentInset = [self messageComposerViewInsert];
    
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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


#pragma mark - UITableViewDelegate ()
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self fullyExtendTableViewCellSeparator:cell];
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
//Part-2
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self fullyExtendTableViewSeparator:self.tableView];
}

-(NSManagedObjectContext *)managedObjectContext{
    return [NSManagedObjectContext MR_defaultContext];
}

-(RGSManagedUser *)currentUser{
    if (_currentUser == nil)
    {
        _currentUser = [[LocalStorageService shared] savedUser];
    }
    return _currentUser;
}

- (UIBarButtonItem *)customBarBackButton {
    UIButton *backButton = [UIButton buttonAsCustomBackButton];
    [backButton addTarget:self action:@selector(toChatListScreen:)
         forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"Chats" forState:UIControlStateNormal];
    backButton.titleLeftEdgeInset = -25;
    backButton.imageLeftEdgeInset = -35;
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return barButton;
}

- (UIEdgeInsets)messageComposerViewInsert {
    UIEdgeInsets tableViewInsert = UIEdgeInsetsMake(0, 0, -CGRectGetHeight(self.messageComposerView.frame), 0);
    return tableViewInsert;
}
#pragma mark - fetchedResultsController ()
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

-(void)toChatListScreen:(id)sender
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass",
                                           NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark - UIKeyboard ()
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
    
    self.keyboardAnimationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.keyboardAnimationCurve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
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

- (void)keyboardDidHidden:(NSNotification*)aNotification
{
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
    
    
    return YES;
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
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.messageComposerView.messageTextView.internalTextView.attributedText];
    
    [attributedString insertAttributedString:imageWithNewLine atIndex:self.messageComposerView.messageTextView.internalTextView.selectedRange.location];
    self.messageComposerView.messageTextView.internalTextView.attributedText = attributedString;
    
    
    
    [self.messageComposerView.messageTextView updateLayout];
    
}

-(void)sendMessage:(id)sender{
    NSLog(@"simple print-----textViewCursor.location------{%@}", NSStringFromRange(self.messageComposerView.messageTextView.internalTextView.selectedRange));
    
//    RGSMessage *message = [RGSMessage MR_createEntity];
//    message.sender = self.currentUser;
//    message.receiver = self.receiver;
//    message.chat = self.chat;
//    message.body = self.messageComposerView.messageTextView.internalTextView.text;
//    
//    [self.messageComposeTempImages
//     enumerateObjectsUsingBlock:
//     ^(UIImage *uiImage, NSUInteger index, BOOL *stop)
//     {
//         RGSImage *image = [RGSImage MR_createEntity];
//         image.index = [NSNumber numberWithInteger:index];
//         image.imageData = UIImageJPEGRepresentation(uiImage,0.0);
//         
//         [message addImagesObject:image];
//     }];
//    
//    [[RGSChatService shared] sendMessage:message];
}

- (void)dealloc {
    [self deRegisterForKeyboardNotifications];
}

@end
