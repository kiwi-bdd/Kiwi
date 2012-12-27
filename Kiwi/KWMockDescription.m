#import "KWMockDescription.h"

@implementation KWMockDescription
@synthesize isNullMock;
@synthesize name;
@synthesize mockedClass;
@synthesize mockedProtocol;

- (id)initWithNullFlag:(BOOL)nullFlag name:(NSString *)aName mockedClass:(Class)aClass mockedProtocol:(Protocol *)aProtocol {
	if ((self = [super init])) {
		isNullMock = nullFlag;
		name = [aName copy];
		mockedClass = aClass;
		mockedProtocol = aProtocol;
	}
	return self;
}

- (void)dealloc {
	[name release];
	[super dealloc];
}
@end
