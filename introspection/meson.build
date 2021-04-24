project(
  'libbpf-tools',
  'c',
  default_options: [
    'prefix=' + join_paths(meson.source_root(), 'packaged'),
    'buildtype=debugoptimized',
    'warning_level=2',
    'werror=true',
    'c_std=gnu17',
  ]
)

add_global_arguments(
  '-Wno-unused-variable',
  '-Wno-unused-function',
  '-Wno-unused-parameter',
  '-Wno-sign-compare',
  '-Wno-missing-field-initializers',
  language: 'c'
)

deps = [
  dependency('libbpf'),
  dependency('libelf'),
  dependency('zlib'),
]

executable(
  'bps',
  [
    'bps.c',
  ],
  dependencies: deps,
  install: true,
)
