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

static NSString *stringBetween(const char *begin, const char *end) {
    return [[[NSString alloc] initWithBytes:begin length:(end-begin) encoding:NSUTF8StringEncoding] autorelease];
}

+ (KWMockDescription *)mockForTypeEncoding:(const char*)encoding {
    Class aClass = nil;
    Protocol *aProtocol = nil;

    if (encoding[0] == '@' && encoding[1] == '"' && encoding[2] == '<') {
        const char *begin = encoding+3;
        const char *end = strchr(begin, '>');

        aProtocol = NSProtocolFromString(stringBetween(begin, end));
    }
    else if (encoding[0] == '@' && encoding[1] == '"') {
        const char *begin = encoding+2;
        const char *end = strchr(begin, '"');

        aClass = NSClassFromString(stringBetween(begin, end));
    }
    else if (encoding[0] == '@') {
        aClass = [NSObject class];
    }
    else {
        NSString *reason = [NSString stringWithFormat:@"do not know how to mock type encoded as \"%s\"", encoding];
        @throw [NSException exceptionWithName:@"KWMockException" reason:reason userInfo:nil];
    }

	return [[[[self class] alloc] initWithNullFlag:NO name:nil mockedClass:aClass mockedProtocol:aProtocol] autorelease];
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

+ (KWMockDescription *)nullMockNamed:(NSString *)aName forProtocol:(Protocol *)aProtocol {
	return [[[[self class] alloc] initWithNullFlag:YES name:aName mockedClass:nil mockedProtocol:aProtocol] autorelease];
}

- (BOOL)isEqual:(KWMockDescription *)other {
    if (![other isKindOfClass:[KWMockDescription class]])
        return NO;

    if (isNullMock != other.isNullMock)
        return NO;
    if (name != other.name && ![name isEqualToString:other.name])
        return NO;
    if (mockedClass != other.mockedClass)
        return NO;
    if (mockedProtocol != other.mockedProtocol)
        return NO;

    return YES;
}

- (NSUInteger)hash {
    return (isNullMock * 31) ^
           [name hash] ^
           [mockedClass hash] ^
           [mockedProtocol hash];
}

@end
