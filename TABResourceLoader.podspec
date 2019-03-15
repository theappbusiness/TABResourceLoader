Pod::Spec.new do |spec|
  spec.name         = 'TABResourceLoader'
  spec.homepage     = 'https://github.com/theappbusiness/TABResourceLoader'
  spec.version      = '8.1.0'
  spec.license      = { :type => 'MIT' }
  spec.authors      = { 'Luciano Marisi' => 'luciano@techbrewers.com' }
  spec.summary      = 'Framework for loading resources from a network service'
  spec.source           = {
    :git => "https://github.com/theappbusiness/TABResourceLoader.git",
    :tag => spec.version.to_s
  }
  spec.source_files = 'Sources/**/*.swift'
  spec.ios.deployment_target = '8.0'
  spec.swift_version = '4.2'
end
