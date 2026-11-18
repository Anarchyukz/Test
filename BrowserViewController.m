#import "BrowserViewController.h"

@interface BrowserViewController ()
@property (nonatomic, strong) UITextField *addressField;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *forwardButton;
@property (nonatomic, strong) UIButton *reloadButton;
@end

@implementation BrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildInterface];
    [self loadAddress:@"https://www.google.com"];
}

- (void)buildInterface {
    UIView *toolbar = [[UIView alloc] init];
    toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    toolbar.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    [self.view addSubview:toolbar];

    self.backButton = [self buttonWithTitle:@"‹" action:@selector(goBack)];
    self.forwardButton = [self buttonWithTitle:@"›" action:@selector(goForward)];
    self.reloadButton = [self buttonWithTitle:@"↻" action:@selector(reloadPage)];

    self.addressField = [[UITextField alloc] init];
    self.addressField.translatesAutoresizingMaskIntoConstraints = NO;
    self.addressField.borderStyle = UITextBorderStyleRoundedRect;
    self.addressField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.addressField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.addressField.keyboardType = UIKeyboardTypeURL;
    self.addressField.returnKeyType = UIReturnKeyGo;
    self.addressField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.addressField.delegate = self;
    self.addressField.placeholder = @"Search or enter website";

    [toolbar addSubview:self.backButton];
    [toolbar addSubview:self.forwardButton];
    [toolbar addSubview:self.addressField];
    [toolbar addSubview:self.reloadButton];

    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:self.webView];

    [NSLayoutConstraint activateConstraints:@[
        [toolbar.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor],
        [toolbar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [toolbar.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [toolbar.heightAnchor constraintEqualToConstant:52.0],

        [self.backButton.leadingAnchor constraintEqualToAnchor:toolbar.leadingAnchor constant:8.0],
        [self.backButton.centerYAnchor constraintEqualToAnchor:toolbar.centerYAnchor],
        [self.backButton.widthAnchor constraintEqualToConstant:36.0],
        [self.backButton.heightAnchor constraintEqualToConstant:40.0],

        [self.forwardButton.leadingAnchor constraintEqualToAnchor:self.backButton.trailingAnchor constant:2.0],
        [self.forwardButton.centerYAnchor constraintEqualToAnchor:toolbar.centerYAnchor],
        [self.forwardButton.widthAnchor constraintEqualToConstant:36.0],
        [self.forwardButton.heightAnchor constraintEqualToConstant:40.0],

        [self.addressField.leadingAnchor constraintEqualToAnchor:self.forwardButton.trailingAnchor constant:8.0],
        [self.addressField.centerYAnchor constraintEqualToAnchor:toolbar.centerYAnchor],
        [self.addressField.heightAnchor constraintEqualToConstant:36.0],

        [self.reloadButton.leadingAnchor constraintEqualToAnchor:self.addressField.trailingAnchor constant:6.0],
        [self.reloadButton.trailingAnchor constraintEqualToAnchor:toolbar.trailingAnchor constant:-8.0],
        [self.reloadButton.centerYAnchor constraintEqualToAnchor:toolbar.centerYAnchor],
        [self.reloadButton.widthAnchor constraintEqualToConstant:36.0],
        [self.reloadButton.heightAnchor constraintEqualToConstant:40.0],

        [self.webView.topAnchor constraintEqualToAnchor:toolbar.bottomAnchor],
        [self.webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.webView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

- (UIButton *)buttonWithTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:27.0];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)loadAddress:(NSString *)text {
    NSString *value = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (value.length == 0) return;

    NSURL *url = nil;
    if ([value rangeOfString:@" "].location != NSNotFound || [value rangeOfString:@"."].location == NSNotFound) {
        NSString *query = [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.google.com/search?q=%@", query]];
    } else {
        if (![value containsString:@"://"]) value = [@"https://" stringByAppendingString:value];
        url = [NSURL URLWithString:value];
    }

    if (url && url.scheme && url.host) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        [self.addressField resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self loadAddress:textField.text];
    return YES;
}

- (void)goBack {
    if (self.webView.canGoBack) [self.webView goBack];
}

- (void)goForward {
    if (self.webView.canGoForward) [self.webView goForward];
}

- (void)reloadPage {
    [self.webView reload];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.addressField.text = webView.URL.absoluteString;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.addressField.text = webView.URL.absoluteString;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.addressField.text = webView.URL.absoluteString;
}

@end
