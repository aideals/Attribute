//
//  ViewController.m
//  Attribute
//
//  Created by 鹏 刘 on 2016/12/25.
//  Copyright © 2016年 鹏 刘. All rights reserved.
//

#import "AttributeViewController.h"

@interface AttributeViewController ()
@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) UILabel *selectedLabel;
@property (nonatomic,strong) UIStepper *selectedStepper;
@property (nonatomic,strong) UIButton *colorButton;
@property (nonatomic,strong) UIButton *fontButton;
@property (nonatomic,strong) UIButton *lineButton;
@end

@implementation AttributeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTextLabel];
    [self initSelectedStepper];
    [self initSelectedLabel];
    [self initColorButton];
    [self initFontButton];
    [self initUnderLineButton];
    [self initOutlineButton];
}

- (NSArray *)wordList
{
    NSArray *wordList = [[self.textLabel.attributedText string] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([wordList count]) {
        return wordList;
    }else {
        return @[@""];
    }
}

- (NSString *)selectedWord
{
    return [self wordList][(NSInteger)self.selectedStepper.value];
}

- (IBAction)updateSelected:(id)sender
{
    self.selectedStepper.maximumValue = [self wordList].count - 1;
    
    self.selectedLabel.text = [self selectedWord];
    
    [self addLabelAttribute:@{NSBackgroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0, [self.textLabel.attributedText length])];
    [self addSelectedWordAttribute:@{NSBackgroundColorAttributeName : [UIColor yellowColor]}];
}

- (void)addLabelAttribute:(NSDictionary *)attribute range:(NSRange)range
{
    NSMutableAttributedString *copyMAT = [self.textLabel.attributedText mutableCopy];
    if (copyMAT) {
        [copyMAT addAttributes:attribute range:range];
    }
    self.textLabel.attributedText = copyMAT;
}

- (void)addSelectedWordAttribute:(NSDictionary *)attribute
{
    NSRange range = [[self.textLabel.attributedText string] rangeOfString:[self selectedWord]];
    [self addLabelAttribute:attribute range:range];
}

- (void)initTextLabel
{
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, self.view.bounds.size.width, 180)];
    self.textLabel.numberOfLines = 0;
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 4.5;
    paragraph.paragraphSpacing = 10.0;
    
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString:@"CS193p is the most awesome class at Stanford!"];
    [mas addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"helvetica" size:40] range:NSMakeRange(0, mas.length)];
    [mas addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, mas.length)];
    
    self.textLabel.attributedText = mas;
    
    
    [self.view addSubview:self.textLabel];
}

- (void)initSelectedStepper
{
    self.selectedStepper = [[UIStepper alloc] initWithFrame:CGRectMake(10, 25, 180, 25)];
    [self.selectedStepper addTarget:self action:@selector(updateSelected:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.selectedStepper];
}

- (void)initSelectedLabel
{
    self.selectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 25, 160, 25)];
    self.selectedLabel.textColor = [UIColor blackColor];
    self.selectedLabel.font = [UIFont fontWithName:@"helvetica" size:20];
    self.selectedLabel.textAlignment = NSTextAlignmentLeft;
    self.selectedLabel.text = @"selected world";
    [self.view addSubview:self.selectedLabel];
}

#define x_space 25

- (void)initColorButton
{
    NSArray *color = [[NSArray alloc] initWithObjects:[UIColor blueColor],[UIColor redColor],[UIColor greenColor],[UIColor grayColor], nil];
    NSArray *title = [[NSArray alloc] initWithObjects:@"Blue",@"Red",@"Green",@"Gray", nil];
    
    for (int i = 0; i < 4; i++) {
        self.colorButton = [[UIButton alloc] initWithFrame:CGRectMake(x_space + (55 + x_space) * i, 310, 70, 55)];
        self.colorButton.backgroundColor = [color objectAtIndex:i];
        [self.colorButton setTitle:[title objectAtIndex:i] forState:UIControlStateNormal];
        self.colorButton.titleLabel.text = [title objectAtIndex:i];
        self.colorButton.titleLabel.font = [UIFont fontWithName:@"helvetica" size:20];
        [self.colorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.colorButton addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:self.colorButton];
    }
}

- (IBAction)changeColor:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"Blue"]) {
        [self addSelectedWordAttribute:@{NSBackgroundColorAttributeName : [UIColor blueColor]}];
    }
    else if ([sender.titleLabel.text isEqualToString:@"Red"]) {
        [self addSelectedWordAttribute:@{NSBackgroundColorAttributeName : [UIColor redColor]}];
    }
    else if ([sender.titleLabel.text isEqualToString:@"Green"]) {
        [self addSelectedWordAttribute:@{NSBackgroundColorAttributeName : [UIColor greenColor]}];
    }
    else if ([sender.titleLabel.text isEqualToString:@"Gray"]) {
        [self addSelectedWordAttribute:@{NSBackgroundColorAttributeName : [UIColor grayColor]}];
    }
}

#define font_x_space 40

- (void)initFontButton
{
    NSArray *fontName = [[NSArray alloc] initWithObjects:@"CourierNewPS-BoldMT",@"AmericanTypeWriter",@"CourierNewPS-ItalicMT", nil];
    
    for (int i = 0;i < 3;i++) {
        UIButton *fontButton = [[UIButton alloc] initWithFrame:CGRectMake(font_x_space + (55 + font_x_space) * i, 400, 70, 55)];
        fontButton.backgroundColor = [UIColor grayColor];
        fontButton.titleLabel.font = [UIFont fontWithName:[fontName objectAtIndex:i] size:15];
        [fontButton setTitle:[fontName objectAtIndex:i] forState:UIControlStateNormal];
        [fontButton addTarget:self action:@selector(changeFont:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:fontButton];
    }

}

- (IBAction)changeFont:(UIButton *)sender
{
    CGFloat fontSize = [UIFont systemFontSize];
    
    NSRange range = [self.textLabel.attributedText.string rangeOfString:[self selectedWord]];
    if (range.location != NSNotFound) {
        NSDictionary *attribute = [self.textLabel.attributedText attributesAtIndex:range.location effectiveRange:NULL];
        UIFont *existingFont = attribute[NSFontAttributeName];
        if (existingFont) fontSize = existingFont.pointSize;
    }
   
    UIFont *font = [sender.titleLabel.font fontWithSize:fontSize];
    [self addSelectedWordAttribute:@{NSFontAttributeName : font}];
}

#define under_x_space 75

- (void)initUnderLineButton
{
    NSArray *array = [[NSArray alloc] initWithObjects:@"Underline",@"NO Underline", nil];
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(under_x_space + (55 + under_x_space) * i, 510, 105, 45)];
        button.backgroundColor = [UIColor grayColor];
        button.titleLabel.font = [UIFont fontWithName:@"helvetica" size:18];
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(underLine:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:button];
    }

}

- (IBAction)underLine:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"Underline"]) {
        [self addSelectedWordAttribute:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)}];
    }
    else if ([sender.titleLabel.text isEqualToString:@"NO Underline"]) {
        [self addSelectedWordAttribute:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone)}];
    }
}

#define out_x_space 75

- (void)initOutlineButton
{
    NSArray *array = [[NSArray alloc] initWithObjects:@"Outline",@"NO Outline", nil];
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(out_x_space + (70 + out_x_space) * i, 595, 105, 45)];
        button.backgroundColor = [UIColor grayColor];
        button.titleLabel.font = [UIFont fontWithName:@"helvetica" size:18];
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(outLine:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:button];
    }
}

- (IBAction)outLine:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"Outline"]) {
        [self addSelectedWordAttribute:@{NSStrokeWidthAttributeName : @5}];
    }
    else if ([sender.titleLabel.text isEqualToString:@"NO Outline"]) {
        [self addSelectedWordAttribute:@{NSStrokeWidthAttributeName : @0}];
    }

}



@end
