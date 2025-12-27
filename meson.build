project('io.github.ellie_commons.cherrypick', 
'c', 'vala', 
version: '2.3.0')

subdir('src')
subdir('data')
subdir('po')

glib_dep = dependency('glib-2.0')
gtk_dep = dependency('gtk4')
granite_dep = dependency('granite-7')
portal_dep = dependency('libportal')

picker_dependencies = [glib_dep, gtk_dep, granite_dep, portal_dep, meson.get_compiler('c').find_library('m', required: true)]

config_data = configuration_data()
config_data.set('version', meson.project_version())
config_data.set_quoted('LOCALEDIR', get_option('prefix') / get_option('localedir'))
config_data.set_quoted('GETTEXT_PACKAGE', meson.project_name())
config_file = configure_file(
    input: 'src/Config.vala.in',
    output: '@BASENAME@',
    configuration: config_data
)

gresource = gnome.compile_resources(
    'gresource',
    'data' / 'cherrypick.gresource.xml',
    source_dir: 'data'
)

executable(
    meson.project_name(),
    gresource,
    config_file,
    sources: [picker_source_files],
    dependencies: picker_dependencies,
    install: true
)

gnome.post_install(
  glib_compile_schemas: true,
  gtk_update_icon_cache: true,
  update_desktop_database: true
  )