//
//  EditTagsTableViewController.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/9.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "EditTagsTableViewController.h"
#import "EditTagTableViewCell.h"
#import "TagStore.h"
@interface EditTagsTableViewController ()
@property(nonatomic, strong) NSMutableArray *tags;
@property(nonatomic, strong) TagStore *store;
@end

@implementation EditTagsTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.dataSource = self;
  self.store = [TagStore sharedStore];
  self.tags = (NSMutableArray *)@[
    @"iOS",
    @"Android",
    @"node.js",
    @"php",
    @"javascript",
    @"python",
    @"ruby",
    @"go",
    @"html5",
    @"CSS3",
    @"jquery",
    @"chrome",
    @"mongodb",
    @"mysql",
    @"redis",
    @"vim",
    @"django"
  ];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return self.tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  EditTagTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"tagCell"
                                      forIndexPath:indexPath];
  if (cell == nil) {
    cell =
        [[EditTagTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:@"tagCell"];
  }
  cell.tagTitle.text = [self.tags objectAtIndex:indexPath.row];
  cell.tagImage.image = [UIImage
      imageNamed:[NSString
                     stringWithFormat:@"%@.png",
                                      [self.tags objectAtIndex:indexPath.row]]];
  [cell.tagSwitch setTag:indexPath.row];
  [cell.tagSwitch addTarget:self
                     action:@selector(switchAction:)
           forControlEvents:UIControlEventValueChanged];

  NSMutableArray *currentTags = [self.store getCurrentTags];
  if ([currentTags containsObject:[self.tags objectAtIndex:indexPath.row]]) {
    cell.tagSwitch.on = YES;
  } else {
    cell.tagSwitch.on = NO;
  }
  return cell;
}

- (IBAction)switchAction:(id)sender {
  UISwitch *temp = (UISwitch *)sender;
  BOOL isOn = [temp isOn];
  NSInteger tag = temp.tag;
  NSMutableArray *currentTags = [self.store getCurrentTags];
  if (isOn) {
    [currentTags addObject:[self.tags objectAtIndex:tag]];
  } else {
    [currentTags removeObject:[self.tags objectAtIndex:tag]];
  }
  [self.store setCurrentTags:currentTags];
}

- (IBAction)successEditMenu:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}
@end
