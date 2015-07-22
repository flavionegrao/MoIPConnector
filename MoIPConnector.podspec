Pod::Spec.new do |s|
  s.name             = "MoIPConnector"
  s.version          = "0.1"
  s.summary          = "Easy way to integrate MoIP payments to your iOS APP"
  s.homepage         = "https://github.com/flavionegrao/MoIPConnector"
  s.license          = 'MIT'
  s.author           = { "Flavio Negrao Torres" => "flavio@apetis.com" }

  s.source           = { :git => "https://github.com/flavionegrao/MoIPConnector.git", :tag => "#{s.version}" }
  s.source_files     = "MoIPConnector/**/*.{h,m}"

  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.frameworks = 'Foundation'

end

