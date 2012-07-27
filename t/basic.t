use Statistics::BoxTest;

use strict;

use Test::More tests => 4;


my ($r, $summary) = Statistics::BoxTest::compare(
                     dataset1 => [1..100],
                     dataset2 => [5..105],
                    );

is($r, 0);
ok(ref $summary eq 'ARRAY');


($r) = Statistics::BoxTest::compare(
         dataset1 => [1..100],
         dataset2 => [10..110],
       );
is($r, -1);



($r) = Statistics::BoxTest::compare(
         dataset1 => [10..110],
         dataset2 => [1..100],
       );
is($r, 1);
