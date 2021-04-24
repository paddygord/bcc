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

tools = [
  'biolatency',
  'biopattern',
  'biosnoop',
  'biostacks',
  'bitesize',
  'cachestat',
  'cpudist',
  'cpufreq',
  'drsnoop',
  'execsnoop',
  'ext4dist',
  'filelife',
  'funclatency',
  'hardirqs',
  'llcstat',
  'numamove',
  'opensnoop',
  'readahead',
  'runqlat',
  'runqlen',
  'runqslower',
  'softirqs',
  'syscount',
  'tcpconnect',
  'tcpconnlat',
  'vfsstat',
  'xfsslower',

  'bootstrap',
  'minimal',
  'fentry',
  'kprobe',
  'uprobe',
]

strip = find_program('llvm-strip')
bpftool = find_program('bpftool')

deps = [
  dependency('libbpf'),
  dependency('libelf'),
  dependency('zlib'),
]

vmlinux = custom_target(
  'vmlinux',
  output: 'vmlinux.h',
  capture: true,
  command: [
    bpftool, 'btf', 'dump', 'file', '/sys/kernel/btf/vmlinux', 'format', 'c',
  ],
)

foreach tool: tools
  bpfobj = static_library(
    tool + '.bpf',
    [
      'libbpf-tools/' + tool + '.bpf.c',
      vmlinux,
    ],
    c_args: [
      '-target', 'bpf',
      '-D__TARGET_ARCH_x86',
    ],
  ).extract_objects('libbpf-tools/' + tool + '.bpf.c')
  stripped = custom_target(
    tool + '.bpf.o',
    input: bpfobj,
    output: tool + '.bpf.o',
    command: [
      strip,
      '-g',
      '@INPUT@',
      '-o', '@OUTPUT@',
    ]
  )
  skel = custom_target(
    tool + '.bpf.h',
    input: stripped,
    output: tool + '.skel.h',
    capture: true,
    command: [
      bpftool,
      'gen', 'skeleton',
      '@INPUT@',
    ],
  )
  executable(
    tool,
    [
      'libbpf-tools/' + tool + '.c',
      skel,
      'libbpf-tools/trace_helpers.c',
      'libbpf-tools/syscall_helpers.c',
      'libbpf-tools/errno_helpers.c',
      'libbpf-tools/map_helpers.c',
      'libbpf-tools/uprobe_helpers.c',
    ],
    dependencies: deps,
    install: true,
  )
endforeach

executable(
  'bps',
  [
    'libbpf-tools/bps.c',
  ],
  dependencies: deps,
  install: true,
)
