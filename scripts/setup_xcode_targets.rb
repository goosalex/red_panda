#!/usr/bin/env ruby
# Idempotently configures ios/Runner.xcodeproj for Red Panda:
#  - Runner: iOS 18, bundle id, entitlements, shared Swift sources
#  - RedPandaControls widget extension (Controls, Live Activity, Lock/Home Screen
#    widget + its Assets.xcassets), embedded in Runner
#  - RedPandaShare share extension (text/links -> to-dos), embedded in Runner
# Already applied to the committed project; re-run after `flutter create .` or if the
# project gets regenerated:  gem install xcodeproj && ruby scripts/setup_xcode_targets.rb
require 'xcodeproj'

ROOT = File.expand_path('../ios', __dir__)
project = Xcodeproj::Project.open(File.join(ROOT, 'Runner.xcodeproj'))

BUNDLE_ID = 'ch.masdatos.redpanda'
EXT_NAME = 'RedPandaControls'
SHARE_NAME = 'RedPandaShare'
TEAM = '92CR5QLW8P' # Mas Datos GmbH; Xcode Cloud needs it in the project
IOS = '18.0'

runner = project.targets.find { |t| t.name == 'Runner' }
project.build_configurations.each { |c| c.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = IOS }
runner.build_configurations.each do |c|
  s = c.build_settings
  s['IPHONEOS_DEPLOYMENT_TARGET'] = IOS
  s['PRODUCT_BUNDLE_IDENTIFIER'] = BUNDLE_ID
  s['CODE_SIGN_ENTITLEMENTS'] = 'Runner/Runner.entitlements'
  s['CODE_SIGN_STYLE'] = 'Automatic'
  s['DEVELOPMENT_TEAM'] = TEAM
  s['TARGETED_DEVICE_FAMILY'] = '1,2' # iPhone and iPad
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
add_sources(runner_group, runner, %w[RedPandaShortcuts.swift Reminders.swift Motion.swift LeaveBasket.swift])
unless runner_group.files.any? { |r| r.path == 'Runner.entitlements' }
  runner_group.new_reference('Runner.entitlements')
end
# Privacy manifest: no tracking, no collected data, the reasons for UserDefaults and file dates.
privacy = runner_group.files.find { |r| r.path == 'PrivacyInfo.xcprivacy' } || runner_group.new_reference('PrivacyInfo.xcprivacy')
runner.resources_build_phase.add_file_reference(privacy) unless runner.resources_build_phase.files_references.include?(privacy)

shared = group_for(project, 'Shared', 'Shared')
shared_files = Dir.children(File.join(ROOT, 'Shared')).select { |f| f.end_with?('.swift') }.sort
add_sources(shared, runner, shared_files)

# Embeds an app extension in Runner (same "Embed Foundation Extensions" phase for all).
def embed_extension(runner, ext)
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
  if thin && runner.build_phases.index(embed) > runner.build_phases.index(thin)
    runner.build_phases.delete(embed)
    runner.build_phases.insert(runner.build_phases.index(thin), embed)
  end
end

# Creates/configures an app extension target from ios/<name>/ (Info.plist,
# <name>.entitlements, <name>.xcconfig + its Swift files) plus the given shared files.
def configure_extension(project, runner, shared, name:, bundle_id:, shared_files:, resources: [])
  ext = project.targets.find { |t| t.name == name } ||
        project.new_target(:app_extension, name, :ios, IOS)
  group = group_for(project, name, name)
  sources = Dir.children(File.join(ROOT, name)).select { |f| f.end_with?('.swift') }.sort
  add_sources(group, ext, sources)
  add_sources(shared, ext, shared_files)
  ['Info.plist', "#{name}.entitlements", "#{name}.xcconfig"].each do |f|
    group.new_reference(f) unless group.files.any? { |r| r.path == f }
  end
  resources.each do |f|
    ref = group.files.find { |r| r.path == f } || group.new_reference(f)
    ext.resources_build_phase.add_file_reference(ref) unless ext.resources_build_phase.files_references.include?(ref)
  end
  xcconfig_ref = group.files.find { |r| r.path == "#{name}.xcconfig" }

  ext.build_configurations.each do |c|
    c.base_configuration_reference = xcconfig_ref
    s = c.build_settings
    s['PRODUCT_BUNDLE_IDENTIFIER'] = bundle_id
    s['PRODUCT_NAME'] = '$(TARGET_NAME)'
    s['INFOPLIST_FILE'] = "#{name}/Info.plist"
    s['GENERATE_INFOPLIST_FILE'] = 'YES'
    s['CODE_SIGN_ENTITLEMENTS'] = "#{name}/#{name}.entitlements"
    s['CODE_SIGN_STYLE'] = 'Automatic'
    s['DEVELOPMENT_TEAM'] = TEAM
    s['IPHONEOS_DEPLOYMENT_TARGET'] = IOS
    s['SWIFT_VERSION'] = '5.0'
    s['TARGETED_DEVICE_FAMILY'] = '1,2' # iPhone and iPad
    s['SKIP_INSTALL'] = 'YES'
    s['APPLICATION_EXTENSION_API_ONLY'] = 'YES'
    s['LD_RUNPATH_SEARCH_PATHS'] = ['$(inherited)', '@executable_path/Frameworks', '@executable_path/../../Frameworks']
    # From pubspec.yaml via Flutter's Generated.xcconfig (Xcode Cloud: CI_BUILD_NUMBER).
    s['MARKETING_VERSION'] = '$(FLUTTER_BUILD_NAME)'
    s['CURRENT_PROJECT_VERSION'] = '$(FLUTTER_BUILD_NUMBER)'
    s.delete('INFOPLIST_KEY_CFBundleDisplayName')
  end
  embed_extension(runner, ext)
  ext
end

# Widget extension: Controls, Live Activity, Lock/Home Screen widget. Panda mood artwork
# (PandaSad/PandaSleeping/PandaCurious/PandaExcited) in its Assets.xcassets.
configure_extension(project, runner, shared, name: EXT_NAME, bundle_id: "#{BUNDLE_ID}.controls",
                    shared_files: shared_files, resources: ['Assets.xcassets', 'PrivacyInfo.xcprivacy'])

# Share extension: shared text/links -> to-dos. Only extension-safe shared code
# (VoiceRecorder & co. use APIs unavailable in share extensions).
configure_extension(project, runner, shared, name: SHARE_NAME, bundle_id: "#{BUNDLE_ID}.share",
                    shared_files: %w[NoteStore.swift SharedText.swift], resources: ['PrivacyInfo.xcprivacy'])

project.save
puts "Configured Runner + #{EXT_NAME} + #{SHARE_NAME} (iOS #{IOS}, #{BUNDLE_ID})"
