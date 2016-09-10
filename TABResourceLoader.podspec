Pod::Spec.new do |spec|
  spec.name         = 'TABResourceLoader'
  spec.homepage     = 'https://github.com/theappbusiness/TABResourceLoader'
  spec.version      = '1.0.0'
  spec.license      = { :type => 'MIT' }
  spec.authors      = { 'Luciano Marisi' => 'luciano@techbrewers.com' }
  spec.summary      = 'Framework for loading resources from a network service'
  spec.source       = { :path => '.' }
  spec.source_files = 'Sources/**/*.swift'
  spec.ios.deployment_target = '9.0'
end
