# $Id: Server.pm,v 1.2 1995/07/15 12:45:20 rik Exp $

require Remedy::Ar;

package Remedy::Ar::Server;

sub new
{
  my($pkg, $name) = @_;

  $self->{'control'} = Remedy::Ar::newcontrol();
  Remedy::Ar::setserver($self->{'control'}, $name);
  
  bless $self;
}

sub setuser
{
  my($me) = shift;

  Remedy::Ar::setuser($me->{'control'}, shift, shift);
}

sub GetInfo
{
}

sub SetInfo
{
}

# ----------------------------------------------------------------------------
# Schema Functions
# ----------------------------------------------------------------------------

sub CreateSchema
{
  my($me, $name) = @_;

  Remedy::Ar::CreateSchema($me->{'control'}, $name);
  return Remedy::Ar::Schema->new($name, $me->{'control'});
}

sub DeleteSchema
{
  my($me) = shift;

  Remedy::Ar::DeleteSchema($me->{'control'});
}

sub ListSchema
{
  my($me) = shift;

  Remedy::Ar::GetListSchema($me->{'control'}, 0);
}

sub GetSchema
{
  my($me, $name) = @_;

  Remedy::Ar::Schema->new($name, $me->{'control'});
}

# ----------------------------------------------------------------------------
# CharMenu Functions
# ----------------------------------------------------------------------------

sub CreateCharMenu
{
  my($me) = shift;
  my($name) = @_;

  Remedy::Ar::CreateCharMenu($me->{'control'}, $name);
  return Remedy::Ar::CharMenu->new($name, $me->{'control'});
}

sub DeleteCharMenu
{
  my($me) = shift;

  Remedy::Ar::DeleteCharMenu($me->{'control'});
}

sub ListCharMenu
{
  my($me) = shift;

  Remedy::Ar::GetListCharMenu($$me->{'control'});
}

# ----------------------------------------------------------------------------
# Filter Functions
# ----------------------------------------------------------------------------

sub CreateFilter
{
  my($me) = shift;
  my($name) = @_;

  Remedy::Ar::CreateFilter($me->{'control'}, $name);
  return Remedy::Ar::Filter->new($name, $me->{'control'});
}

sub DeleteFilter
{
  my($me) = shift;

  Remedy::Ar::DeleteFilter($me->{'control'});
}

sub ListFilter
{
  my($me) = shift;

  Remedy::Ar::GetListFilter($me->{'control'});
}

# ----------------------------------------------------------------------------
# ActiveLink Functions
# ----------------------------------------------------------------------------

sub CreateActiveLink
{
  my($me) = shift;
  my($name) = @_;

  Remedy::Ar::CreateActiveLink($me->{'control'}, $name);
  return Remedy::Ar::ActiveLink->new($name, $me->{'control'});
}

sub DeleteActiveLink
{
  my($me) = shift;

  Remedy::Ar::DeleteActiveLink($me->{'control'});
}

sub ListActiveLink
{
  my($me) = shift;

  Remedy::Ar::GetListActiveLink($me->{'control'});
}

# ----------------------------------------------------------------------------
# AdminExt Functions
# ----------------------------------------------------------------------------

sub CreateAdminExt
{
  my($me) = shift;
  my($name) = @_;

  Remedy::Ar::CreateAdminExt($me->{'control'}, $name);
  return Remedy::Ar::AdminExt->new($name, $me->{'control'});
}

sub DeleteAdminExt
{
  my($me) = shift;

  Remedy::Ar::DeleteAdminExt($me->{'control'});
}

sub ListAdminExt
{
  my($me) = shift;

  Remedy::Ar::GetListAdminExt($me->{'control'});
}

sub DESTROY
{
}

1;
__END__
