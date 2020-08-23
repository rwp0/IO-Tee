# -*- perl -*-
#------------------------------------------------------------

# Usage of IO::Tee with IO::* classes, especially IO::Wrap.

use strict;
use English qw(-no_match_vars);

use Test::More tests => 4;

use IO::Tee;

use File::Temp qw(tmpnam);
use IO::Wrap;
use IO::File;

my $wrap_fname = tmpnam();
open (WRAPF, '>', $wrap_fname)
  or  die "Could not open $wrap_fname for writing: $ERRNO,";
my $wrap_fh = wraphandle(\*WRAPF);

my $iof_fname = tmpnam();
my $io_fh = IO::File->new($iof_fname, 'w')
    or  die "Could not open $iof_fname for writing: $ERRNO,";

my $tee = IO::Tee->new($wrap_fh, $io_fh);
ok( $tee->print('1234567890') , 'print 10 characters');
ok( $tee->close() , 'closed both files');

cmp_ok( -s $wrap_fname , '==' , 10 , 'IO::Wrap wrote 10 chars');
cmp_ok( -s $iof_fname , '==' , 10 , 'IO::File wrote 10 chars');

unlink($wrap_fname, $wrap_fh);


exit(0);
