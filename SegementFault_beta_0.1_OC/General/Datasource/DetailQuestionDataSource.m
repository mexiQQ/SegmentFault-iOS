//
//  DetailQuestionDataSource.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/4.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "DetailQuestionDataSource.h"
#import "DetailQuestionStore.h"

@interface DetailQuestionDataSource ()
@property(nonatomic, assign) NSInteger *sectionsNumber;
@property(nonatomic, copy) NSString *cellIdentifier;
@property(nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;

@end

@implementation DetailQuestionDataSource
- (id)init {
  return [super init];
}

- (id)initWithItems:(NSInteger *)sectionsNumber
        cellIdentifier:(NSString *)aCellIdentifier
    configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock {
  self = [super init];
  if (self) {
    self.sectionsNumber = sectionsNumber;
    self.cellIdentifier = aCellIdentifier;
    self.configureCellBlock = [aConfigureCellBlock copy];
  }
  return self;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return (int)self.sectionsNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [[UITableViewCell alloc] init];
}
@end
