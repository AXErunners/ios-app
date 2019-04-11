Pod::Spec.new do |s|
  s.name             = 'ios-app'
  s.version          = '0.0.3'
  s.summary          = 'AXE Platform Protocol'

  s.description      = <<-DESC
The iOS implementation of the Axe Platform Protocol
                       DESC

  s.homepage         = 'https://github.com/axerunners/ios-app'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Andrew Podkovyrin' => 'podkovyrin@gmail.com' }
  s.source           = { :git => 'https://github.com/axerunners/ios-app.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/axerunners'

  s.ios.deployment_target = '10.0'

  s.source_files = 'ios-app/Classes/**/*'

  # s.resource_bundles = {
  #  'ios-app' => ['ios-app/Assets/**/*.json']
  # }

  s.module_name = 'APP'

  # s.dependency 'DSJSONSchemaValidation', '2.0.5'
  s.dependency 'TinyCborObjc', '0.4.1'
end
