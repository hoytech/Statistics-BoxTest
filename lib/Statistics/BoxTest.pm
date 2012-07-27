package Statistics::BoxTest;

use strict;

our $VERSION = '0.20';

use Carp qw/croak/;


sub compare {
  my (%args) = @_;

  croak "need an array ref arg for dataset1" unless ref $args{dataset1} eq 'ARRAY';
  croak "need an array ref arg for dataset2" unless ref $args{dataset2} eq 'ARRAY';

  my $percentile_low = 0;
  $percentile_low = $args{percentile_low} if defined $args{percentile_low};
  croak "bad value for percentile_low" unless $percentile_low >= 0 && $percentile_low <= 100;

  my $percentile_high = 5;
  $percentile_high = $args{percentile_high} if defined $args{percentile_high};
  croak "bad value for percentile_high" unless $percentile_high >= 0 && $percentile_high <= 100;

  my @dataset1 = sort { $a <=> $b } @{ $args{dataset1} };
  my @dataset2 = sort { $a <=> $b } @{ $args{dataset2} };

  my @box1 = @dataset1[int(@dataset1 * $percentile_low / 100.0) .. int(@dataset1 * $percentile_high / 100.0)-1];
  my @box2 = @dataset2[int(@dataset2 * $percentile_low / 100.0) .. int(@dataset2 * $percentile_high / 100.0)-1];

  croak "too few measurements in both datasets" if @box1 < 2 && @box2 < 2;
  croak "too few measurements in dataset1" if @box1 < 2;
  croak "too few measurements in dataset2" if @box2 < 2;

  my $ret;

  if ($box1[$#box1] < $box2[0]) {
    $ret = -1;
  } elsif ($box2[$#box2] < $box1[0]) {
    $ret = 1;
  } else {
    $ret = 0;
  }

  my $summary = [
                  [ $box1[0], $box1[-1], ],
                  [ $box2[0], $box2[-1], ],
                ];

  return ($ret, $summary);
}


1;



=encoding utf-8

=head1 NAME

Statistics::BoxTest - Simple timing measurement stats test


=head1 SYNOPSIS

    use Statistics::BoxTest;

    my ($r, $summary) = Statistics::BoxTest::compare(
                          dataset1 => $dataset1,
                          dataset2 => $dataset2,
                        );

    ## $r is -1, 0, or 1



=head1 DESCRIPTION

This module is a component of an attempt to replicate some experiments described in the paper "Opportunities and Limits of Remote Timing Attacks" by Scott Crosby, Dan Wallach, and Rudolf Riedi.

The box test works on the principle that network latency measurements tend to have a bimodal distribution. The first mode is a large, tight cluster of measurements in the bottom of the range representing the best-case where there is no significant network congestion and no interfering interrupts or page faults on the measuring or measured machines. The second mode is a higher-valued aggregate of all the sources of "jitter" that contribute to latency measurements. In other words, measurements with lower values tend to contain less noise than higher values (read the paper for a much more in-depth explanation).



=head1 USAGE

This module contains a single function C<compare> (not exported by default). It must be passed at least two arrayrefs, C<dataset1> and C<dataset2>.

You can optionally also pass C<percentile_low> and C<percentile_high> (called I<i> and I<j> in the paper). The defaults are 0 and 5 respectively. According to the paper, optimal values were less than 6.

In C<$r>, C<compare> will return -1 if it thinks that C<dataset1> is lower than C<dataset2>, 1 if it thinks C<dataset1> is higher than C<dataset2>, and 0 if it didn't detect any difference.

C<compare> also returns C<$summary> which is an arrayref of arrayrefs representing the bounds of the boxes of the two datasets.

C<compare> will croak if the data-sets don't contain enough samples for your specified percentiles.



=head1 NOTES

In order to minimise jitter added by your measurment machine, normally you would collect the measurements using a program written in C, and then use this module to analyze the measurements after the fact. Collecting timing data using perl is problematic because of the unpredictability of the perl run-time environment.





=head1 SEE ALSO

There are many other statistics-related modules on CPAN, although see the paper for some insights into why tests like the Student's t-test that seem like they would be applicable have some issues with remote timing side-channels.

L<Opportunities and Limits of Remote Timing Attacks|http://www.cs.rice.edu/~dwallach/pub/crosby-timing2009.pdf> - The very interesting paper that inspired this module

L<Time is on my Side|http://events.ccc.de/congress/2011/Fahrplan/events/4640.en.html> - Exploiting Timing Side Channel Vulnerabilities on the Web

L<Exploiting OpenBSD|http://sota.gen.nz/hawkes_openbsd.pdf> - Interesting weaknesses of ASLR and stack canaries in the presence of timing side-channels




=head1 AUTHOR

Doug Hoyte, C<< <doug@hcsw.org> >>



=head1 COPYRIGHT & LICENSE

Copyright 2012 Doug Hoyte.

This module is licensed under the same terms as perl itself.

=cut
