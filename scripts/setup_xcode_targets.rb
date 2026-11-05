#!/usr/bin/env ruby
# Idempotently configures ios/Runner.xcodeproj for Red Panda:
#  - Runner: iOS 18, bundle id, entitlements, shared Swift sources
#  - RedPandaControls widget extension (Controls + Live Activity), embedded in Runner
# Already applied to the committed project; re-run after `flutter create .` or if the
# project gets regenerated:  gem install xcodeproj && ruby scripts/setup_xcode_targets.rb
require 'xcodeproj'

ROOT = File.expand_path('../ios', __dir__)
project = Xcodeproj::Project.open(File.join(ROOT, 'Runner.xcodeproj'))

BUNDLE_ID = 'ch.masdatos.redpanda'
EXT_NAME = 'RedPandaControls'
IOS = '18.0'

runner = project.targets.find { |t| t.name == 'Runner' }
project.build_configurations.each { |c| c.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = IOS }
runner.build_configurations.each do |c|
  s = c.build_settings
  s['IPHONEOS_DEPLOYMENT_TARGET'] = IOS
  s['PRODUCT_BUNDLE_IDENTIFIER'] = BUNDLE_ID
  s['CODE_SIGN_ENTITLEMENTS'] = 'Runner/Runner.entitlements'
  s['CODE_SIGN_STYLE'] = 'Automatic'
  s['TARGETED_DEVICE_FAMILY'] = '1'
end
project.targets.select { |t| t.name == 'RunnerTests' }.each do |t|
  t.build_configurations.each do |c|
    c.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = IOS
    c.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = "#{BUNDLE_ID}.RunnerTests"
  end
end

def group_for(project, path, name)
  project.main_group.groups.find { |g| g.path == path } || project.main_group.new_group(name, path)
end

def add_sources(group, target, files)
  files.each do |f|
    ref = group.files.find { |r| r.path == f } || group.new_reference(f)
    next if target.source_build_phase.files_references.include?(ref)
    target.source_build_phase.add_file_reference(ref)
  end
end

runner_group = project.main_group.groups.find { |g| g.path == 'Runner' }
add_sources(runner_group, runner, ['RedPandaShortcuts.swift'])
unless runner_group.files.any? { |r| r.path == 'Runner.entitlements' }
  runner_group.new_reference('Runner.entitlements')
end

shared = group_for(project, 'Shared', 'Shared')
shared_files = Dir.children(File.join(ROOT, 'Shared')).select { |f| f.end_with?('.swift') }.sort
add_sources(shared, runner, shared_files)

# Widget extension
ext = project.targets.find { |t| t.name == EXT_NAME }
unless ext
  ext = project.new_target(:app_extension, EXT_NAME, :ios, IOS)
end
ext_group = group_for(project, EXT_NAME, EXT_NAME)
ext_sources = Dir.children(File.join(ROOT, EXT_NAME)).select { |f| f.end_with?('.swift') }.sort
add_sources(ext_group, ext, ext_sources)
add_sources(shared, ext, shared_files)
%w[Info.plist RedPandaControls.entitlements RedPandaControls.xcconfig].each do |f|
  ext_group.new_reference(f) unless ext_group.files.any? { |r| r.path == f }
end
xcconfig_ref = ext_group.files.find { |r| r.path == 'RedPandaControls.xcconfig' }

ext.build_configurations.each do |c|
  c.base_configuration_reference = xcconfig_ref
  s = c.build_settings
  s['PRODUCT_BUNDLE_IDENTIFIER'] = "#{BUNDLE_ID}.controls"
  s['PRODUCT_NAME'] = '$(TARGET_NAME)'
  s['INFOPLIST_FILE'] = "#{EXT_NAME}/Info.plist"
  s['GENERATE_INFOPLIST_FILE'] = 'YES'
  s['CODE_SIGN_ENTITLEMENTS'] = "#{EXT_NAME}/#{EXT_NAME}.entitlements"
  s['CODE_SIGN_STYLE'] = 'Automatic'
  s['IPHONEOS_DEPLOYMENT_TARGET'] = IOS
  s['SWIFT_VERSION'] = '5.0'
  s['TARGETED_DEVICE_FAMILY'] = '1'
  s['SKIP_INSTALL'] = 'YES'
  s['APPLICATION_EXTENSION_API_ONLY'] = 'YES'
  s['LD_RUNPATH_SEARCH_PATHS'] = ['$(inherited)', '@executable_path/Frameworks', '@executable_path/../../Frameworks']
  s['MARKETING_VERSION'] = '$(FLUTTER_BUILD_NAME)'
  s['CURRENT_PROJECT_VERSION'] = '$(FLUTTER_BUILD_NUMBER)'
  s.delete('INFOPLIST_KEY_CFBundleDisplayName')
end

runner.add_dependency(ext) unless runner.dependencies.any? { |d| d.target == ext }

embed = runner.copy_files_build_phases.find { |p| p.name == 'Embed Foundation Extensions' }
unless embed
  embed = runner.new_copy_files_build_phase('Embed Foundation Extensions')
  embed.dst_subfolder_spec = '13' # PlugIns
end
unless embed.files_references.include?(ext.product_reference)
  bf = embed.add_file_reference(ext.product_reference)
  bf.settings = { 'ATTRIBUTES' => ['RemoveHeadersOnCopy'] }
end
# Flutter's "Thin Binary" script must run after embedding, or Xcode reports a build cycle.
thin = runner.build_phases.find { |p| p.respond_to?(:name) && p.name == 'Thin Binary' }
if thin
  runner.build_phases.delete(embed)
  runner.build_phases.insert(runner.build_phases.index(thin), embed)
end

project.save
puts "Configured Runner + #{EXT_NAME} (iOS #{IOS}, #{BUNDLE_ID})"
