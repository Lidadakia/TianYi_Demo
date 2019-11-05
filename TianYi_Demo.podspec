Pod::Spec.new do |s|
s.name = 'DFTextStyle'
s.version = '1.0.2'
s.license = 'MIT'
s.summary = 'A Text in iOS.'
s.homepage = 'https://github.com/954788/DFTextStyle'
s.authors = { '954788' => '569676974@qq.com' }
s.source = { :git => "https://github.com/954788/DFTextStyle.git", :tag => "1.0.2"}
s.requires_arc = true
s.ios.deployment_target = '8.0'
s.source_files = "DFTextStyle", "*.{h,m}"
end
