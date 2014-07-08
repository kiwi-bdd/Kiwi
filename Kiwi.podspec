Pod::Spec.new do |s|

  s.name            = 'Kiwi'
  s.version         = '2.2.4'
  s.summary         = 'A Behavior Driven Development library for iOS and OS X.'
  s.homepage        = 'https://github.com/kiwi-bdd/Kiwi'
  s.source          = { :git => 'https://github.com/kiwi-bdd/Kiwi.git', :tag => s.version.to_s }
  s.license         = { :type => 'MIT', :file => 'License.txt' }

  s.authors = {
    'Allen Ding' => 'alding@gmail.com',
    'Luke Redpath' => 'luke@lukeredpath.co.uk',
    'Marin Usalj' => 'mneorr@gmail.com',
    'Stepan Hruda' => 'stepan.hruda@gmail.com',
    'Brian Gesiak' => 'modocache@gmail.com',
    'Adam Sharp' => 'adsharp@me.com',
  }

  s.ios.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '"$(SDKROOT)/Developer/Library/Frameworks" $(inherited) "$(DEVELOPER_FRAMEWORKS_DIR)" "$(DEVELOPER_DIR)/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks"' }
  s.osx.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '"$(SDKROOT)/Developer/Library/Frameworks" $(inherited) "$(DEVELOPER_FRAMEWORKS_DIR)" "$(DEVELOPER_DIR)/Platforms/MacOSX.platform/Developer/Library/Frameworks"' }
  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'

  s.framework = 'XCTest'
  s.requires_arc = true

  s.subspec 'Core' do |core|
    s.source_files = 'Classes/**/*.{h,m}'
    s.prefix_header_contents = '#import <XCTest/XCTest.h>'
    s.dependency 'Kiwi/MAFuture'
  end

  s.subspec 'MAFuture' do |mafuture|
    mafuture.source_files = 'MAFuture/**/*.{h,m}'
    mafuture.exclude_files = 'MAFuture/tester.m'
    mafuture.compiler_flags = '-fno-objc-arc'
    mafuture.requires_arc = false
  end

end
