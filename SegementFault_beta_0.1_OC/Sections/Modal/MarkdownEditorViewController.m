//
//  MarkdownEditorViewController.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/20.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "MarkdownEditorViewController.h"
#import "MXKeyboardToolbar.h"

@interface MarkdownEditorViewController ()
@property(nonatomic, strong) UITextView *textView;
@end

@implementation MarkdownEditorViewController
@synthesize leftBarItemBlock = _leftBarItemBlock;
@synthesize rightBarItemBlock = _rightBarItemBlock;
- (instancetype)init {
  UIStoryboard *mainStoryboard =
      [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  MarkdownEditorViewController *main =
      [mainStoryboard instantiateViewControllerWithIdentifier:@"markdownEdit"];

  return main;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.navigationController.navigationBar
      setBarTintColor:[UIColor colorWithRed:34 / 255.0
                                      green:72 / 255.0
                                       blue:57 / 255.0
                                      alpha:1.0]];

  self.textView = [[UITextView alloc]
      initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
  self.textView.inputAccessoryView =
      [MXKeyboardToolbar toolbarViewWithTextView:self.textView];
  self.textView.delegate = self;
  self.textView.textColor = [UIColor lightGrayColor];
  self.textView.text = @"撰写评论：";
  self.textView.backgroundColor = [UIColor clearColor];
  self.textView.font = [UIFont fontWithName:@"Arial" size:16];
  [self.view addSubview:self.textView];

  dispatch_time_t popTime =
      dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));

  dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
    [self.textView becomeFirstResponder];
  });

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(keyboardWasShown:)
             name:UIKeyboardDidShowNotification
           object:nil];
}

- (void)setHandler:(BarItemBlock)cancelHandler
       PullHandler:(BarItemBlock)pullHandler {
  _rightBarItemBlock = pullHandler;
  _leftBarItemBlock = cancelHandler;
}

- (IBAction)cancelAction:(id)sender {
  [self.textView resignFirstResponder];
  _leftBarItemBlock(@"cancel");
}

- (IBAction)submitAction:(id)sender {
  [self.textView resignFirstResponder];
  _rightBarItemBlock(self.textView.text);
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
  if ([textView.text isEqualToString:@"撰写评论："]) {
    textView.text = @"";
    textView.textColor = [UIColor blackColor]; // optional
  }
  [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
  if ([textView.text isEqualToString:@""]) {
    textView.text = self.title;
    textView.textColor = [UIColor lightGrayColor]; // optional
  }
  [textView resignFirstResponder];
}

- (void)keyboardWasShown:(NSNotification *)notification {
  CGSize keyboardSize =
      [[[notification userInfo]
           objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
  float height = [self.view bounds].size.height - self.textView.frame.origin.y -
                 keyboardSize.height;
  self.textView.frame = CGRectMake(
      self.textView.frame.origin.x, self.textView.frame.origin.y,
      CGRectGetWidth([[UIApplication sharedApplication] keyWindow].frame),
      height);
}
@end
