Pod::Spec.new do |s|
s.name = 'TianYi_Demo'
s.version = '1.0'
s.license = 'MIT'
s.summary = 'A Text in iOS.'
s.homepage = 'https://github.com/Lidadakia/test.git'
s.authors = { '954788' => 'lily@eb-tech.cn' }
s.source = { :git => "https://github.com/Lidadakia/test.git", :tag => "1.0"}
s.requires_arc = true
s.ios.deployment_target = '10.0'
s.source_files = "TianYi_Demo", "*.{h,m}"
end

