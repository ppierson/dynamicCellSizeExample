//
//  DynamicCellSizeTableViewController.m
//  dynamicCellSizeExample
//
//  Created by Patrick Pierson on 3/27/13.
//  Copyright (c) 2013 PPierson. All rights reserved.
//

#import "DynamicCellSizeTableViewController.h"

#define kLabelWidth 203
#define kLabelHeight 21
#define kCellHeight 44

@interface DynamicCellSizeTableViewController (){
    NSArray * _labelTextArray;
    NSIndexPath * _expandedIndexPath;
    
    UIFont* _labelFont;
}

@end

@implementation DynamicCellSizeTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _expandedIndexPath = nil;
    _labelFont = [UIFont systemFontOfSize:17.0];
    
    _labelTextArray = @[
                       @"Nulla facilisi. In vel sem. Morbi id urna in diam dignissim feugiat. Proin molestie tortor eu velit. Aliquam erat volutpat. Nullam ultrices, diam tempus vulputate egestas, eros pede varius leo, sed imperdiet lectus est ornare odio. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin consectetuer velit in dui. Phasellus wisi purus, interdum vitae, rutrum accumsan, viverra in, velit. Sed enim risus, congue non, tristique in, commodo eu, metus. Aenean tortor mi, imperdiet id, gravida eu, posuere eu, felis. Mauris sollicitudin, turpis in hendrerit sodales, lectus ipsum pellentesque ligula, sit amet scelerisque urna nibh ut arcu. Aliquam in lacus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla placerat aliquam wisi. Mauris viverra odio. Quisque fermentum pulvinar odio. Proin posuere est vitae ligula. Etiam euismod. Cras a eros.",
                       @"Vivamus auctor leo vel dui. Aliquam erat volutpat. Phasellus nibh. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Cras tempor. Morbi egestas, urna non consequat tempus, nunc arcu mollis enim, eu aliquam erat nulla non nibh. Duis consectetuer malesuada velit. Nam ante nulla, interdum vel, tristique ac, condimentum non, tellus. Proin ornare feugiat nisl. Suspendisse dolor nisl, ultrices at, eleifend vel, consequat at, dolor.",
                       @"Nulla facilisi. In vel sem. Morbi id urna in diam dignissim feugiat. Proin molestie tortor eu velit. Aliquam erat volutpat. Nullam ultrices, diam tempus vulputate egestas, eros pede varius leo, sed imperdiet lectus est ornare odio. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin consectetuer velit in dui. Phasellus wisi purus, interdum vitae, rutrum accumsan, viverra in, velit. Sed enim risus, congue non, tristique in, commodo eu, metus. Aenean tortor mi, imperdiet id, gravida eu, posuere eu, felis. Mauris sollicitudin, turpis in hendrerit sodales, lectus ipsum pellentesque ligula, sit amet scelerisque urna nibh ut arcu. Aliquam in lacus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla placerat aliquam wisi. Mauris viverra odio. Quisque fermentum pulvinar odio. Proin posuere est vitae ligula. Etiam euismod. Cras a eros."];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)getFullSizeOfLabelForText:(NSString*)labelText{
    //up to infinite height
    CGSize maxSize = CGSizeMake(kLabelWidth, FLT_MAX);
    CGSize expectedSize = [labelText sizeWithFont:_labelFont constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
    
    if (expectedSize.width < kLabelWidth) expectedSize.width = kLabelWidth;
    return expectedSize;
}

- (IBAction)expandButtonSelected:(id)sender{
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cell.center];
    NSIndexPath* oldPath = _expandedIndexPath;
    if(_expandedIndexPath && [_expandedIndexPath isEqual: indexPath]) {
        _expandedIndexPath = nil;
    }else{
        _expandedIndexPath = indexPath;
    }
    
    NSMutableArray* indexPaths = [NSMutableArray array];
    if(_expandedIndexPath) [indexPaths addObject:_expandedIndexPath];
    if(oldPath) [indexPaths addObject:oldPath];
    if([indexPaths count] > 0) [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat additionalHeight = 0;
    if(_expandedIndexPath && indexPath.row == _expandedIndexPath.row){
        CGSize newSize = [self getFullSizeOfLabelForText:[_labelTextArray objectAtIndex:indexPath.row]];
        additionalHeight = newSize.height - kLabelHeight;
    }
    
    return kCellHeight + additionalHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_labelTextArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"dynamicSizeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    UILabel* textLabel = (UILabel*)[cell viewWithTag:101];
    UIButton* expandButton = (UIButton*)[cell viewWithTag:102];
    
    [textLabel setText:[_labelTextArray objectAtIndex:indexPath.row]];
    textLabel.frame = CGRectMake(textLabel.frame.origin.x, textLabel.frame.origin.y, kLabelWidth, kLabelHeight);

    if(_expandedIndexPath != nil && _expandedIndexPath.row == indexPath.row){
        //resize label
        CGSize expectedSize = [self getFullSizeOfLabelForText:[_labelTextArray objectAtIndex:indexPath.row]];
        textLabel.frame = CGRectMake(textLabel.frame.origin.x, textLabel.frame.origin.y, expectedSize.width, expectedSize.height);
        [expandButton setTitle:@"Shrink" forState:UIControlStateNormal];
    }else{
        [expandButton setTitle:@"Expand" forState:UIControlStateNormal];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
