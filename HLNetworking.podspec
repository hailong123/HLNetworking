
#
# Be sure to run `pod lib lint HLNetworking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HLNetworking'
  s.version          = '0.1.1'
  s.summary          = '用户网络请求使用'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                        对AFNetworking进行了简单的封装
                       DESC

  s.homepage         = 'https://github.com/hailong123/HLNetworking'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'SeaDragon' => '771145867@qq.com' }
  s.source           = { :git => 'https://github.com/hailong123/HLNetworking.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  
  s.dependency 'AFNetworking'

  s.subspec 'AppContext' do |appContext|
  	appContext.source_files        = 'HLNetworking/Classes/AppContext/*'
  	appContext.public_header_files = 'HLNetworking/Classes/AppContext/*.h'

    appContext.dependency 'HLNetworking/Classes/Components/LocationManager'
  end

  s.subspec 'Categories' do |categories|
  	categories.source_files        = 'HLNetworking/Classes/Categories/*'
  	categories.public_header_files = 'HLNetworking/Classes/Categories/*.h'
  	end

  s.subspec 'Components' do |components|
  	components.subspec 'BaseAPIManager' do |baseAPIManager|
  		baseAPIManager.source_files        = 'HLNetworking/Classes/Components/BaseAPIManager/*'
  		baseAPIManager.public_header_files = 'HLNetworking/Classes/Components/BaseAPIManager/*.h'

      baseAPIManager.dependency 'HLNetworking/Classes/Components/URLResponse'
  	end

  	components.subspec 'HLApiProxy' do |hlApiProxy|
  		hlApiProxy.source_files        = 'HLNetworking/Classes/Components/HLApiProxy/*'
  		hlApiProxy.public_header_files = 'HLNetworking/Classes/Components/HLApiProxy/*.h'

      hlApiProxy.dependency 'HLNetworking/Classes/Components/URLResponse'
  	end

  	components.subspec 'LocationManager' do |locationManager|
  		locationManager.source_files        = 'HLNetworking/Classes/Components/LocationManager/*'
  		locationManager.public_header_files = 'HLNetworking/Classes/Components/LocationManager/*.h'
  	end

  	components.subspec 'Loger' do |loger|
  		loger.source_files        = 'HLNetworking/Classes/Components/Loger/*'
  		loger.public_header_files = 'HLNetworking/Classes/Components/Loger/*.h'

      loger.dependency 'HLNetworking/Classes/AppContext'
  	end

  	components.subspec 'URLResponse' do |urlResponse|
  		urlResponse.source_files        = 'HLNetworking/Classes/Components/URLResponse/*'
  		urlResponse.public_header_files = 'HLNetworking/Classes/Components/URLResponse/*.h'

      urlResponse.dependency 'HLNetworking/Classes/Generators/RequestGenerator'
  	end

  end

  s.subspec 'Generators' do |generators|
  	generators.subspec 'RequestGenerator' do |requestGenerator|
  		requestGenerator.source_files        = 'HLNetworking/Classes/Generators/RequestGenerator/*'
  		requestGenerator.public_header_files = 'HLNetworking/Classes/Generators/RequestGenerator/*.h'

      requestGenerator.dependency 'HLNetworking/Classes/AppContext'
  	end
  
  end

  s.subspec 'NetworkConfig' do |networkConfig|
  	networkConfig.source_files        = 'HLNetworking/Classes/NetworkConfig/*'
  	networkConfig.public_header_files = 'HLNetworking/Classes/NetworkConfig/*.h'
  end
  
end
