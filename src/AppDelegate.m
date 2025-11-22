#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface AppDelegate ()
@property (strong) NSWindow *window;
@property (strong) NSTextField *titleLabel;
@property (strong) NSTextField *timeLabel;
@property (strong) NSTextField *dateLabel;
@property (strong) NSTextField *lunarLabel;
@property (strong) NSView *backgroundView;
@property (strong) NSTextField *hourLabel;
@property (strong) NSTextField *minuteLabel;
@property (strong) NSTextField *secondLabel;
@property (strong) NSTextField *colon1Label;
@property (strong) NSTextField *colon2Label;
@property (strong) NSStackView *timeRow;
@property (strong) NSTimer *timer;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    NSRect frame = NSMakeRect(0, 0, 560, 220);
    self.window = [[NSWindow alloc] initWithContentRect:frame styleMask:(NSWindowStyleMaskTitled|NSWindowStyleMaskClosable|NSWindowStyleMaskMiniaturizable|NSWindowStyleMaskResizable) backing:NSBackingStoreBuffered defer:NO];
    self.window.title = @"AtTime";
    [self.window center];
    self.window.minSize = NSMakeSize(560, 220);
    self.backgroundView = [[NSView alloc] initWithFrame:self.window.contentView.bounds];
    self.backgroundView.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable;
    self.backgroundView.wantsLayer = YES;
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.backgroundView.bounds;
    gradient.colors = @[ (__bridge id)[[NSColor systemTealColor] CGColor], (__bridge id)[[NSColor systemOrangeColor] CGColor] ];
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(1.0, 1.0);
    gradient.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
    [self.backgroundView.layer addSublayer:gradient];
    [self.window.contentView addSubview:self.backgroundView];

    self.titleLabel = [self labelWithFont:[NSFont systemFontOfSize:20 weight:NSFontWeightSemibold] color:[NSColor labelColor]];
    self.titleLabel.stringValue = @"北京时间";
    self.titleLabel.alignment = NSTextAlignmentCenter;

    self.hourLabel = [self labelWithFont:[NSFont monospacedDigitSystemFontOfSize:64 weight:NSFontWeightSemibold] color:[NSColor systemRedColor]];
    self.hourLabel.alignment = NSTextAlignmentCenter;
    self.minuteLabel = [self labelWithFont:[NSFont monospacedDigitSystemFontOfSize:64 weight:NSFontWeightSemibold] color:[NSColor systemGreenColor]];
    self.minuteLabel.alignment = NSTextAlignmentCenter;
    self.secondLabel = [self labelWithFont:[NSFont monospacedDigitSystemFontOfSize:64 weight:NSFontWeightSemibold] color:[NSColor systemBlueColor]];
    self.secondLabel.alignment = NSTextAlignmentCenter;
    self.colon1Label = [self labelWithFont:[NSFont monospacedDigitSystemFontOfSize:64 weight:NSFontWeightSemibold] color:[NSColor tertiaryLabelColor]];
    self.colon1Label.alignment = NSTextAlignmentCenter;
    self.colon2Label = [self labelWithFont:[NSFont monospacedDigitSystemFontOfSize:64 weight:NSFontWeightSemibold] color:[NSColor tertiaryLabelColor]];
    self.colon2Label.alignment = NSTextAlignmentCenter;
    self.colon1Label.stringValue = @":";
    self.colon2Label.stringValue = @":";
    [self.hourLabel setContentHuggingPriority:1000 forOrientation:NSLayoutConstraintOrientationHorizontal];
    [self.minuteLabel setContentHuggingPriority:1000 forOrientation:NSLayoutConstraintOrientationHorizontal];
    [self.secondLabel setContentHuggingPriority:1000 forOrientation:NSLayoutConstraintOrientationHorizontal];
    [self.colon1Label setContentHuggingPriority:1000 forOrientation:NSLayoutConstraintOrientationHorizontal];
    [self.colon2Label setContentHuggingPriority:1000 forOrientation:NSLayoutConstraintOrientationHorizontal];

    self.timeRow = [[NSStackView alloc] initWithFrame:self.window.contentView.bounds];
    self.timeRow.orientation = NSUserInterfaceLayoutOrientationHorizontal;
    self.timeRow.alignment = NSLayoutAttributeCenterY;
    self.timeRow.spacing = 6;
    self.timeRow.distribution = NSStackViewDistributionFill;
    [self.timeRow addArrangedSubview:self.hourLabel];
    [self.timeRow addArrangedSubview:self.colon1Label];
    [self.timeRow addArrangedSubview:self.minuteLabel];
    [self.timeRow addArrangedSubview:self.colon2Label];
    [self.timeRow addArrangedSubview:self.secondLabel];
    self.dateLabel = [self labelWithFont:[NSFont monospacedDigitSystemFontOfSize:28 weight:NSFontWeightRegular] color:[NSColor secondaryLabelColor]];
    self.dateLabel.alignment = NSTextAlignmentCenter;
    self.lunarLabel = [self labelWithFont:[NSFont systemFontOfSize:18 weight:NSFontWeightRegular] color:[NSColor labelColor]];
    self.lunarLabel.alignment = NSTextAlignmentCenter;

    NSStackView *stack = [[NSStackView alloc] initWithFrame:self.window.contentView.bounds];
    stack.orientation = NSUserInterfaceLayoutOrientationVertical;
    stack.alignment = NSLayoutAttributeCenterX;
    stack.spacing = 12;
    stack.edgeInsets = NSEdgeInsetsMake(24, 24, 24, 24);
    stack.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable;
    [stack addArrangedSubview:self.titleLabel];
    [stack addArrangedSubview:self.timeRow];
    [stack addArrangedSubview:self.dateLabel];
    [stack addArrangedSubview:self.lunarLabel];
    [self.backgroundView addSubview:stack];

    [self.window makeKeyAndOrderFront:nil];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    [self updateTime];
}

- (NSTextField *)labelWithFont:(NSFont *)font color:(NSColor *)color {
    NSTextField *label = [[NSTextField alloc] initWithFrame:NSZeroRect];
    label.bezeled = NO;
    label.drawsBackground = NO;
    label.editable = NO;
    label.selectable = NO;
    label.textColor = color;
    label.font = font;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

- (void)updateTime {
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    dateFmt.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    dateFmt.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    dateFmt.dateFormat = @"yyyy-MM-dd";
    self.dateLabel.stringValue = [dateFmt stringFromDate:now];

    NSDateFormatter *timeFmtH = [[NSDateFormatter alloc] init];
    timeFmtH.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    timeFmtH.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    timeFmtH.dateFormat = @"HH";
    NSDateFormatter *timeFmtM = [[NSDateFormatter alloc] init];
    timeFmtM.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    timeFmtM.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    timeFmtM.dateFormat = @"mm";
    NSDateFormatter *timeFmtS = [[NSDateFormatter alloc] init];
    timeFmtS.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    timeFmtS.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    timeFmtS.dateFormat = @"ss";
    self.hourLabel.stringValue = [timeFmtH stringFromDate:now];
    self.minuteLabel.stringValue = [timeFmtM stringFromDate:now];
    self.secondLabel.stringValue = [timeFmtS stringFromDate:now];

    NSString *lunar = [self lunarStringForDate:now];
    NSString *season = [self solarTermStringForDate:now];
    if (season.length > 0) {
        self.lunarLabel.stringValue = [NSString stringWithFormat:@"%@ %@", lunar, season];
    } else {
        self.lunarLabel.stringValue = lunar;
    }
}

- (NSString *)lunarStringForDate:(NSDate *)date {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    cal.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    cal.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDateComponents *comp = [cal components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
    NSArray *monthNames = @[ @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"冬月", @"腊月" ];
    NSArray *dayNames = @[ @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                           @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                           @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十" ];
    NSArray *stems = @[ @"甲", @"乙", @"丙", @"丁", @"戊", @"己", @"庚", @"辛", @"壬", @"癸" ];
    NSArray *branches = @[ @"子", @"丑", @"寅", @"卯", @"辰", @"巳", @"午", @"未", @"申", @"酉", @"戌", @"亥" ];
    NSInteger m = comp.month;
    NSInteger d = comp.day;
    BOOL leap = comp.isLeapMonth;
    NSInteger cyc = comp.year;
    NSInteger stemIdx = (cyc - 1) % 10;
    NSInteger branchIdx = (cyc - 1) % 12;
    NSString *yearName = [NSString stringWithFormat:@"%@%@年", stems[stemIdx], branches[branchIdx]];
    NSString *mName = (m >= 1 && m <= 12) ? monthNames[m - 1] : @"";
    NSString *dName = (d >= 1 && d <= 30) ? dayNames[d - 1] : @"";
    if (leap) {
        mName = [@"闰" stringByAppendingString:mName];
    }
    return [NSString stringWithFormat:@"%@ %@%@", yearName, mName, dName];
}

- (NSString *)solarTermStringForDate:(NSDate *)date {
    NSCalendar *greg = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    greg.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDateComponents *c = [greg components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
    NSInteger year = c.year;
    NSInteger month = c.month;
    NSInteger day = c.day;

    double D = 0.2422;
    double C[24] = {3.87,18.73,5.63,20.646,4.81,20.1,5.52,21.04,5.678,21.37,7.108,22.83,7.5,23.13,7.646,23.042,8.318,23.438,7.438,22.36,7.18,21.94,5.4055,20.12};
    NSString *names[24] = {@"立春",@"雨水",@"惊蛰",@"春分",@"清明",@"谷雨",@"立夏",@"小满",@"芒种",@"夏至",@"小暑",@"大暑",@"立秋",@"处暑",@"白露",@"秋分",@"寒露",@"霜降",@"立冬",@"小雪",@"大雪",@"冬至",@"小寒",@"大寒"};
    int termMonth[24] = {2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,1,1};

    int Y = (int)(year - 1900);
    int days[24];
    for (int i=0;i<24;i++) {
        days[i] = (int)floor(Y * D + C[i]) - (int)floor(Y / 4.0);
        if (year >= 2000) { /* 粗略修正 */
            if (i == 21) days[i] -= 1; /* 冬至 */
        }
    }

    int idx1=-1, idx2=-1;
    for (int i=0;i<24;i++) {
        if (termMonth[i] == month) {
            if (idx1 == -1) idx1 = i; else { idx2 = i; break; }
        }
    }
    if (idx1 == -1) return @"";

    int d1 = days[idx1];
    int d2 = (idx2!=-1)?days[idx2]:d1+15;
    NSString *n1 = names[idx1];
    NSString *n2 = (idx2!=-1)?names[idx2]:@"";

    if (day == d1) return [NSString stringWithFormat:@"今日%@", n1];
    if (idx2!=-1 && day == d2) return [NSString stringWithFormat:@"今日%@", n2];

    for (int i=0;i<24;i++) {
        if (termMonth[i] == month) {
            int di = days[i];
            int diff = (int)labs(day - di);
            if (diff <= 1) {
                return [NSString stringWithFormat:@"今日%@", names[i]];
            }
        }
    }

    int idxLC = 0;   // 立春
    int idxLSum = 6; // 立夏
    int idxLAut = 12;// 立秋
    int idxLWin = 18;// 立冬

    NSDateComponents *dcToday = [[NSDateComponents alloc] init];
    dcToday.year = year; dcToday.month = month; dcToday.day = day; dcToday.timeZone = greg.timeZone;
    NSDate *today = [greg dateFromComponents:dcToday];

    NSDateComponents *dcLC = [[NSDateComponents alloc] init];
    dcLC.year = year; dcLC.month = termMonth[idxLC]; dcLC.day = days[idxLC]; dcLC.timeZone = greg.timeZone;
    NSDate *dateLC = [greg dateFromComponents:dcLC];

    NSDateComponents *dcLSum = [[NSDateComponents alloc] init];
    dcLSum.year = year; dcLSum.month = termMonth[idxLSum]; dcLSum.day = days[idxLSum]; dcLSum.timeZone = greg.timeZone;
    NSDate *dateLSum = [greg dateFromComponents:dcLSum];

    NSDateComponents *dcLAut = [[NSDateComponents alloc] init];
    dcLAut.year = year; dcLAut.month = termMonth[idxLAut]; dcLAut.day = days[idxLAut]; dcLAut.timeZone = greg.timeZone;
    NSDate *dateLAut = [greg dateFromComponents:dcLAut];

    NSDateComponents *dcLWin = [[NSDateComponents alloc] init];
    dcLWin.year = year; dcLWin.month = termMonth[idxLWin]; dcLWin.day = days[idxLWin]; dcLWin.timeZone = greg.timeZone;
    NSDate *dateLWin = [greg dateFromComponents:dcLWin];

    if ([today compare:dateLC] != NSOrderedAscending && [today compare:dateLSum] == NSOrderedAscending) return @"春季";
    if ([today compare:dateLSum] != NSOrderedAscending && [today compare:dateLAut] == NSOrderedAscending) return @"夏季";
    if ([today compare:dateLAut] != NSOrderedAscending && [today compare:dateLWin] == NSOrderedAscending) return @"秋季";
    return @"冬季";
}

@end