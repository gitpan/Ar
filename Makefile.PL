# $Id: Makefile.PL,v 1.3 1995/11/18 05:10:47 rik Exp $
use ExtUtils::MakeMaker;

WriteMakefile(
	'LIBS' => '-L/opt/net/ar/api/lib -lar',
	'INC' => '-I/opt/net/ar/api/include',
	'DISTNAME' => 'Ar',
	'NAME' => 'Remedy::Ar',
	'VERSION' => '0.2alpha',
	'PMLIBDIRS' => [ 'Ar' ]
);
