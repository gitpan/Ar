# $Id: Schema.pm,v 1.2 1995/07/15 12:45:20 rik Exp $

package Remedy::Ar::Schema;

sub new
{
  my($pkg, $name, $control) = @_;
  my($self) = {};

  $self->{'name'} = $name;
  $self->{'control'} = $control || Remedy::Ar::newcontrol();
  
  bless $self;
}

sub GetInfo
{
}

sub SetInfo
{
}

sub CreateEntry
{
}

sub DeleteEntry
{
}

sub ListEntry
{
  my($me) = @_;

  Remedy::Ar::GetListEntry($me->{'control'}, $me->{'name'}, 0, 0);
}

sub Search
{
  my($me, $searchstring) = @_;
  my($qual);

  $qual = Remedy::Ar::LoadARQualifierStruct
    ($me->{'control'}, $me->{'name'}, $searchstring);
  return () if ! defined($qual);
  Remedy::Ar::GetListEntry($me->{'control'}, $me->{'name'}, $qual, 0);
}

sub MergeEntry
{
}

sub GetEntry
{
  my($me, $id) = @_;
  my(%ret);

  if (! $me->{'fieldname'}) { &setfieldname($me); };
  foreach $field (Remedy::Ar::GetEntry($me->{'control'}, $me->{'name'}, $id))
  {
    $ret{$me->{'fieldname'}->{$field->[0]}} = $field->[1];
  }
  \%ret;
}

sub CreateField
{
}

sub DeleteField
{
}

sub ListField
{
  my($me) = shift;

  Remedy::Ar::GetListField($me->{'control'}, $me->{'name'}, 0);
}

sub GetField
{
  my($me, $fieldid) = @_;
  (Remedy::Ar::GetField($me->{'control'}, $me->{'name'}, $fieldid))[0];
}

sub GetFieldName
{
  my($me, $fieldid) = @_;
  (Remedy::Ar::GetField($me->{'control'}, $me->{'name'}, $fieldid))[0]->[1] || $fieldid;
}

sub Export
{
}

sub Import
{
}

# Build an associative array mapping field Id's to field names
sub setfieldname
{
  my($me) = shift;
  my($fid);

  foreach $fid (Remedy::Ar::GetListField($me->{'control'}, $me->{'name'}, 0))
  {
    $me->{'fieldname'}->{$fid} = GetFieldName($me, $fid);
  }
}

sub DESTROY
{
}

1;
__END__
