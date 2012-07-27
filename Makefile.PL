use ExtUtils::MakeMaker;

my $preop =
    'perldoc -uT $(VERSION_FROM) | tee $(DISTVNAME)/README.pod > README.pod;' .
    'pod2text README.pod | tee $(DISTVNAME)/README > README';

WriteMakefile(
  NAME => 'Statistics::BoxTest',
  VERSION_FROM => 'lib/Statistics/BoxTest.pm',
  LIBS => [''],
  INC => '-I lib/',
  PREREQ_PM => {
    'Carp' => 0,
  },
  dist => {
    PREOP => $preop,
  },
);
