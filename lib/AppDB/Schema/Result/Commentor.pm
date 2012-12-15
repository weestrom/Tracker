package BlogDB::Schema::Result::Commentor;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

BlogDB::Schema::Result::Commentor

=cut

__PACKAGE__->table("Commentors");

=head1 ACCESSORS

=head2 idcommentors

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 firstname

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 lastname

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 username

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 email

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 homepage

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 dateregistered

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0

=head2 passwordhash

  data_type: 'binary'
  is_nullable: 0
  size: 16

=cut

__PACKAGE__->add_columns(
  "idcommentors",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "firstname",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "lastname",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "username",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "email",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "homepage",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "dateregistered",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
  },
  "passwordhash",
  { data_type => "binary", is_nullable => 0, size => 16 },
);
__PACKAGE__->set_primary_key("idcommentors");

=head1 RELATIONS

=head2 comments

Type: has_many

Related object: L<BlogDB::Schema::Result::Comment>

=cut

__PACKAGE__->has_many(
  "comments",
  "BlogDB::Schema::Result::Comment",
  { "foreign.commentors_idcommentors" => "self.idcommentors" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-12-18 15:52:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5CQoRRmI2QgwS59bqQkZYw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
