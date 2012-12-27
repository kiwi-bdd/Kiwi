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

+ (KWMockDescription *)mockForClass:(Class)aClass {
	return [[[[self class] alloc] initWithNullFlag:NO name:nil mockedClass:aClass mockedProtocol:nil] autorelease];
}

+ (KWMockDescription *)mockForProtocol:(Protocol *)aProtocol {
	return [[[[self class] alloc] initWithNullFlag:NO name:nil mockedClass:nil mockedProtocol:aProtocol] autorelease];
}

+ (KWMockDescription *)mockNamed:(NSString *)aName forClass:(Class)aClass {
	return [[[[self class] alloc] initWithNullFlag:NO name:aName mockedClass:aClass mockedProtocol:nil] autorelease];
}

+ (KWMockDescription *)mockNamed:(NSString *)aName forProtocol:(Protocol *)aProtocol {
	return [[[[self class] alloc] initWithNullFlag:NO name:aName mockedClass:nil mockedProtocol:aProtocol] autorelease];
}

+ (KWMockDescription *)nullMockForClass:(Class)aClass {
	return [[[[self class] alloc] initWithNullFlag:YES name:nil mockedClass:aClass mockedProtocol:nil] autorelease];
}

+ (KWMockDescription *)nullMockForProtocol:(Protocol *)aProtocol {
	return [[[[self class] alloc] initWithNullFlag:YES name:nil mockedClass:nil mockedProtocol:aProtocol] autorelease];
}

+ (KWMockDescription *)nullMockNamed:(NSString *)aName forClass:(Class)aClass {
	return [[[[self class] alloc] initWithNullFlag:YES name:aName mockedClass:aClass mockedProtocol:nil] autorelease];
}

@end
