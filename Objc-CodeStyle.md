## 前言
* 本指南目的在于规范Objc代码的编写方式，为工程代码的统一，可读，优秀提供基础。
* 本指南脱胎与[《objc-zen-book》](https://github.com/objc-zen/objc-zen-book),此处只简明明示`Preferred`和`Not preferred`,详细说明可参看原文。

## 条件语句
条件语句体总是被大括号包围。

Preferred:
```
if (!error) {
    return success;
}
```
Not preferred:
```
if (!error)
    return success;

//or

if (!error) return success;
```

### 尤达表达式
不要使用尤达表达式（倒序，用常量去和变量比较）

Preferred:
```
if ([myValue isEqual:@42]) { ...
```

Not preferred:
```
if ([@42 isEqual:myValue]) { ...
```

### `nil`和`BOOL`检查
Preferred:
```
if  (nil == myValue){...

//or

if(!nil){...

```

### 黄金大道
Preferred:
```
- (void)someMethod {
  if (![someOther boolValue]) {
      return;
  }

  //Do something important
}
```
Not preferred:
```
- (void)someMethod {
  if ([someOther boolValue]) {
    //Do something important
  }
}
```
### 复杂表达式
提取复杂`if`子句赋给一个`BOOL`变量，让逻辑更清楚。
```
BOOL nameContainsSwift  = [sessionName containsString:@"Swift"];
BOOL isCurrentYear      = [sessionDateCompontents year] == 2014;
BOOL isSwiftSession     = nameContainsSwift && isCurrentYear;

if (isSwiftSession) {
    // Do something very cool
}
```
### 三元运算符
一个条件语句的所有变量应该都已经被求值。

Preferred:
```
result = a > b ? x : y;
```
Not preferred:
```
result = a > b ? x = c > d ? c : d : y;
```

当三元运算符的第二个参数和检查语句的对象一样时，可省略第二参：

Preferred:
```
result = object ? : [self createObject];
```
Not preferred:
```
result = object ? object : [self createObject];
```

### 错误处理
使用通过参数返回`error`的引用的方法，应检查方法的返回值。

Preferred:
```
NSError *error = nil;
if (![self trySomethingWithError:&error]) {
    // Handle Error
}
```

## `Case`语句

* `case`子句不包含{}，除非一个`case`包含多行；
* 可多个`case`执行统一代码，移除不必要的`break`;
* switch枚举变量时，不要使用`default`(可触发编译器警告，便于排查代码逻辑遗漏).

```
//1
switch (condition) {
    case 1:
        // ...
        break;
    case 2: {
        // ...
        // Multi-line example using braces
        break;
       } 
    default: 
        // ...
        break;
}

//2
switch (condition) {
    case 1:
    case 2:
        // code executed for values 1 and 2
        break;
    default: 
        // ...
        break;
}

//3
switch (menuType) {
    case ZOCEnumNone:
        // ...
        break;
    case ZOCEnumValue1:
        // ...
        break;
    case ZOCEnumValue2:
        // ...
        break;
}

```

#### 枚举类型
```
typedef NS_ENUM(NSUInteger, ZOCMachineState) {
    ZOCMachineStateNone,
    ZOCMachineStateIdle,
    ZOCMachineStateRunning,
    ZOCMachineStatePaused
};
```

## 命名
遵守Apple命名约定，使用完整的，描述性的方法和变量名。

Preferred:
```
UIButton *settingsButton;
```
Not Preferred:
```
UIButton *setBut;
```


### 常量
驼峰命名法，相关类名为前缀。非必要不要使用宏。

Preferred:
```
static const NSTimeInterval ZOCSignInViewControllerFadeOutAnimationDuration = 0.4;
```
Not Preferred:
```
static const NSTimeInterval fadeOutTime = 0.4;

#define CompanyName @"Apple Inc."

#define magicNumber 42
```

### 方法
方法类型符号与方法名之间加空格，方法段之间加空格。参数前带描述性关键词。

Preferred:
```
- (void)setExampleText:(NSString *)text image:(UIImage *)image;
- (void)sendAction:(SEL)aSelector to:(id)anObject forAllCells:(BOOL)flag;
- (id)viewWithTag:(NSInteger)tag;
- (instancetype)initWithWidth:(CGFloat)width height:(CGFloat)height;
```
Not Preferred:
```
- (void)setT:(NSString *)text i:(UIImage *)image;
- (void)sendAction:(SEL)aSelector :(id)anObject :(BOOL)flag;
- (id)taggedView:(NSInteger)tag;
- (instancetype)initWithWidth:(CGFloat)width andHeight:(CGFloat)height;
- (instancetype)initWith:(int)width and:(int)height;  // Never do this.
```

### 字面值

Preferred:
```
NSArray *names = @[@"Brian", @"Matt", @"Chris", @"Alex", @"Steve", @"Paul"];
NSDictionary *productManagers = @{@"iPhone" : @"Kate", @"iPad" : @"Kamal", @"Mobile Web" : @"Bill"};
NSNumber *shouldUseLiterals = @YES;
NSNumber *buildingZIPCode = @10018;
```
Not Preferred:
```
NSArray *names = [NSArray arrayWithObjects:@"Brian", @"Matt", @"Chris", @"Alex", @"Steve", @"Paul", nil];
NSDictionary *productManagers = [NSDictionary dictionaryWithObjectsAndKeys: @"Kate", @"iPhone", @"Kamal", @"iPad", @"Bill", @"Mobile Web", nil];
NSNumber *shouldUseLiterals = [NSNumber numberWithBool:YES];
NSNumber *buildingZIPCode = [NSNumber numberWithInteger:10018];
```
####
对于可变类型的集合，不要创建类似下面的代码：

Not Preferred:
```
NSMutableArray *aMutableArray = [@[] mutableCopy];
```

## 类
类名需有工程前缀，子类名描述位于前缀于父类名之间。

### `initializer`和`dealloc`
* 如果要实现`dealloc`方法，必须和`init`方法成对出现。
* 如果有多个初始化方法，指定初始化方法（designated initializer）应放在最前面，间接初始化方法（secondary initializer）跟在后面。

```
- (instancetype)init
{
    self = [super init]; // call the designated initializer
    if (self) {
        // Custom initialization
    }
    return self;
}
```

alloc,负责创建对象，分配内存保持对象，写入`isa`指针，初始化引用计数。
init, 负责初始化对象，使对象处于可用状态。

`NS_DESIGNATED_INITIALIZER`
```
@interface ZOCNewsViewController : UIViewController

- (instancetype)initWithNews:(ZOCNews *)news NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ZOC_UNAVAILABLE_INSTEAD(initWithNews:);
- (instancetype)init ZOC_UNAVAILABLE_INSTEAD(initWithNews:);
@end
```

`instancetype`

允许编译器进行类型检查
```
@interface ZOCPerson
+ (instancetype)personWithName:(NSString *)name;
@end
```

#### 单例

```
+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}
```
`dispatch_once()`相比`@synchronize`更快，应用生命周期内只被调用一次。

### 属性
描述性命名，避免缩写，小写驼峰命名。

Preferred:
```
NSString *text;
```

Not Preferred:
```
NSString* text;
NSString * text;
```

* 不要手动`@synthesize`属性；
* 总是使用`setter`和`getter`方法访问属性，除了`init`和`dealloc`;
* 永远不要在`init`和`dealloc`中使用`setter`和`getter`,应该直接访问实例变量。
* 使用点(·)语法,便于阅读，区分方法和属性。

#### 属性定义格式

原子性，读写性，内存管理。
```
@property (nonatomic, readwrite, copy) NSString *name;
```

描述BOOL类型的属性
```
@property (assign, getter=isEditable) BOOL editable;
```

私有属性
```
@interface ZOCViewController ()
@property (nonatomic, strong) UIView *bannerView;
@end
```

可变对象
子类为可变类型，则此类型的内存管理类型必须是`copy`的。
* NSString
* NSArray
* NSDictionary
* NSURLRequest
* NSData

懒加载
对于耗资源，或配置一次就要调用许多相关配置方法。

不要滥用。
```
- (NSDateFormatter *)dateFormatter {
  if (!_dateFormatter) {
    _dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:enUSPOSIXLocale];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSS"];
  }
  return _dateFormatter;
}
```

### 方法
* 参数断言，要求传入的参数满足特定条件
* 不要使用_前缀，这个前缀是Apple保留的

### 相等性

实现相等性，要同时实现`isEqual`和`hash`方法。如果两个对象被`isEqual`认为是相等的，他们的`hash`方法需要返回一样的值。

## Category
为自定义扩展的方法加前缀。

Example:
```
@interface NSDate (ZOCTimeExtensions)
- (NSString *)zoc_timeAgoShort;
@end
```
Not:
```
@interface NSDate (ZOCTimeExtensions)
- (NSString *)timeAgoShort;
@end
```

## Protocols
面向协议编程，而不是具体实现
```
@protocol ZOCFeedParserProtocol <NSObject>

@property (nonatomic, weak) id <ZOCFeedParserDelegate> delegate;
@property (nonatomic, strong) NSURL *url;

- (BOOL)start;
- (void)stop;

@end

@protocol ZOCFeedParserDelegate <NSObject>
@optional
- (void)feedParserDidStart:(id<ZOCFeedParserProtocol>)parser;
- (void)feedParser:(id<ZOCFeedParserProtocol>)parser didParseFeedInfo:(ZOCFeedInfoDTO *)info;
- (void)feedParser:(id<ZOCFeedParserProtocol>)parser didParseFeedItem:(ZOCFeedItemDTO *)item;
- (void)feedParserDidFinish:(id<ZOCFeedParserProtocol>)parser;
- (void)feedParser:(id<ZOCFeedParserProtocol>)parser didFailWithError:(NSError *)error;
@end
```

## NSNotification
```
// Foo.h
extern NSString * const ZOCFooDidBecomeBarNotification

// Foo.m
NSString * const ZOCFooDidBecomeBarNotification = @"ZOCFooDidBecomeBarNotification";
```

## 美化代码
### 空格
* 缩进使用4个空格
* 方法以及其他大括号总是同一行还是，新起一行结束。

Preferred:
```
if (user.isHappy) {
    //Do something
}
else {
    //Do something else
}
```
Not Preferred:
```
if (user.isHappy)
{
  //Do something
} else {
  //Do something else
}
```

## 代码组织
清晰的组织代码，规范的进行定义，是对自己和他人的尊重。

### 利用代码块
代码块在闭合的圆括号内的话，会返回最后一句的值。
```
NSURL *url = ({
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", baseURLString, endpoint];
    [NSURL URLWithString:urlString];
});
```

### Pragma
`#Pramgma makr -`用于在类内部组织代码帮助分组方法。
* 不同功能组的方法
* protocols的实现
* 对父类方法的重写

```
- (void)dealloc { /* ... */ }
- (instancetype)init { /* ... */ }

#pragma mark - View Lifecycle

- (void)viewDidLoad { /* ... */ }
- (void)viewWillAppear:(BOOL)animated { /* ... */ }
- (void)didReceiveMemoryWarning { /* ... */ }

#pragma mark - Custom Accessors

- (void)setCustomProperty:(id)value { /* ... */ }
- (id)customProperty { /* ... */ }

#pragma mark - IBActions

- (IBAction)submitData:(id)sender { /* ... */ }

#pragma mark - Public

- (void)publicMethod { /* ... */ }

#pragma mark - Private

- (void)zoc_privateMethod { /* ... */ }

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { /* ... */ }

#pragma mark - ZOCSuperclass

// ... overridden methods from ZOCSuperclass

#pragma mark - NSObject

- (NSString *)description { /* ... */ }
```
 
### 注释
除非必要，不要注释，命名中实践`见名知其意`即可。


## 对象间的通讯

### Blocks

```
- (void)downloadObjectsAtPath:(NSString *)path
                   completion:(void(^)(NSArray *objects, NSError *error))completion;

```

若如上方法中含义`block`类型参数，最好只含有一个`block`且在最后.
* 通常处理成功和失败会共享一些代码；
* 遵从Apple代码规范；
* block通常会有多行代码，若不作为最后一个参数，会打破调用点；
* 多个block会增加复杂性，显得笨拙。

### 深入Block
* block是在栈上创建的；
* block可以复制到堆上；
* block会捕获栈上的变量（或指针），将其复制为自己私有的const
* 如果在Block中修改block块外部的变量和指针，需将这些变量和指针声明为`__block`.
 