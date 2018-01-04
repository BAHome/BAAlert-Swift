Pod::Spec.new do |s|
    s.name         = "BAAlert-Swift"
    s.version      = "1.2.0.3"
    s.summary      = '目前为止，最为精简的 alert 和 actionSheet 封装！BAAlert 让你的弹框不再孤单！'
    s.homepage     = 'https://github.com/BAHome/BAAlert-Swift'
    s.license      = 'MIT'
    s.authors      = { 'boa' => 'sunboyan@outlook.com' }
    s.platform     = :ios, '9.0'
    s.source       = { :git => 'https://github.com/BAHome/BAAlert-Swift.git', :tag => s.version.to_s }
    s.source_files = 'BAAlert-Swift/BAAlert-Swift/*.{swift}'
    s.requires_arc = true
    s.resource     = 'BAAlert-Swift/BAAlert-Swift/*.bundle'

end
