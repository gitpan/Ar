# $Id: Ar.pm,v 1.3 1995/07/15 12:45:23 rik Exp $

package Remedy::Ar;

require Exporter;
require AutoLoader;
require DynaLoader;
@ISA = qw(Exporter AutoLoader DynaLoader);
# Items to export into callers namespace by default
# (move infrequently used names to @EXPORT_OK below)
@EXPORT = qw( 
);
# Other items we are prepared to export if requested
@EXPORT_OK = qw(
);

bootstrap Remedy::Ar;

# Preloaded methods go here.  Autoload methods go after __END__, and are
# processed by the autosplit program.

# These are offsets into the array used to store the control
# information.  This is transferred into the ARControlStruct when
# calling any AR function.

require Remedy::Ar::Server;
require Remedy::Ar::Schema;

1;
__END__
