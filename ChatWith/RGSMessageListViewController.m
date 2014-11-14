//
//  RGSMessageListViewController.m
//  ChatWith
//
//  Created by PC on 11/1/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSMessageListViewController.h"

#import "RGSManagedUser.h"
#import "RGSMessage.h"
#import "RGSMessageCell.h"

#import "UIImage+RGSinitWithColor.h"
#import "UIColor+RGSColorWithHexString.h"
#import "UIImage+Resize.h"

#import "LocalStorageService.h"

const int maxTextWidth = 260;
const int cellContentMargin = 5;
const int leftRightMargin = cellContentMargin * 2;
const int topBottonMargin = cellContentMargin * 2;

const int fristCell = 0;
const int navigationSpacing = 65;


@interface RGSMessageListViewController ()
@property (nonatomic, strong)UITableViewCell *referenceCell;

@property (nonatomic, strong)RGSManagedUser *currentUser;

@end


@implementation RGSMessageListViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(self.receiver){
        self.navigationItem.title = self.receiver.fullName;
    }
    
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
     UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(toChatListScreen:)
     forControlEvents:UIControlEventTouchUpInside];
     [button setFrame:CGRectMake(0, 20, 80, 32)];
     
     [button setTitle:@"Chats" forState:UIControlStateNormal];
     [button setTitleColor:[UIColor whiteColor]
                  forState:UIControlStateNormal];
     [button setTitleColor:[UIColor lightGrayColor]
                  forState:UIControlStateHighlighted];
    button.titleEdgeInsets = UIEdgeInsetsMake(2, -25, 2, 0);
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
    
    UIImage *image = [UIImage imageNamed:@"backButton"];
    [button setImage:[image resizedImage:CGSizeMake(20, 20)]
            forState:UIControlStateNormal];
    
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -35, 2, 0);

     UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
     
     self.navigationItem.leftBarButtonItem = barButton;
    
    _fetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"chat", self.chat];
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    self.tableView.showsVerticalScrollIndicator = YES;
}

-(void)toChatListScreen:(id)sender{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count]- 3)] animated:NO];
}
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

-(NSFetchedResultsController *)fetchedResultsController{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[RGSMessage MR_entityDescription]];
    [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO]]];
    
    
    [fetchRequest setFetchBatchSize:20];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

-(NSManagedObjectContext *)managedObjectContext{
    return [NSManagedObjectContext MR_defaultContext];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
//Part-2
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}


-(RGSManagedUser *)currentUser{
    if (_currentUser == nil)
    {
        _currentUser = [[LocalStorageService shared] savedUser];
    }
    return _currentUser;
}


//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    
//    
//
//}

@end
