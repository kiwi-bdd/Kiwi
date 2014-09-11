Pod::Spec.new do |s|

  s.name            = 'Kiwi'
  s.version         = '2.3.0'
  s.summary         = 'A Behavior Driven Development library for iOS and OS X.'
  s.homepage        = 'https://github.com/kiwi-bdd/Kiwi'
  s.source          = { :git => 'https://github.com/kiwi-bdd/Kiwi.git', :tag => s.version.to_s }
  s.license         = { :type => 'MIT', :file => 'License.txt' }

  s.authors = {
    'Allen Ding'   => 'alding@gmail.com',
    'Luke Redpath' => 'luke@lukeredpath.co.uk',
    'Marin Usalj'  => 'mneorr@gmail.com',
    'Stepan Hruda' => 'stepan.hruda@gmail.com',
    'Brian Gesiak' => 'modocache@gmail.com',
    'Adam Sharp'   => 'adsharp@me.com',
  }

  # TODO: clean this up once Apple gets their stuff together
  s.ios.xcconfig = {
    "FRAMEWORK_SEARCH_PATHS" => %w[
      $(SDKROOT)/Developer/Library/Frameworks
      $(inherited)
      $(DEVELOPER_FRAMEWORKS_DIR)
    ].join(' '),
    "FRAMEWORK_SEARCH_PATHS[sdk=iphoneos8.0]" => %w[
      $(inherited)
      $(DEVELOPER_DIR)/Platforms/iPhoneOS.platform/Developer/Library/Frameworks
    ].join(' '),
    "FRAMEWORK_SEARCH_PATHS[sdk=iphonesimulator8.0]" => %w[
      $(inherited)
      $(DEVELOPER_DIR)/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks
    ].join(' '),
  }
  s.osx.xcconfig = {
    "FRAMEWORK_SEARCH_PATHS" => "$(DEVELOPER_FRAMEWORKS_DIR)",
    "FRAMEWORK_SEARCH_PATHS[sdk=macosx10.10]" => %w[
      $(inherited)
      $(DEVELOPER_DIR)/Platforms/MacOSX.platform/Developer/Library/Frameworks
    ].join(' '),
  }

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'

  s.framework = 'XCTest'
  s.source_files = 'Classes/**/*.{h,m}'
  s.requires_arc = true
  s.prefix_header_contents = '#import <XCTest/XCTest.h>'

end

