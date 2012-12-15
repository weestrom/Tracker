package BlogDB::Schema::Result::Author;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

BlogDB::Schema::Result::Author

=cut

__PACKAGE__->table("Authors");

=head1 ACCESSORS

=head2 idauthors

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

=head2 about

  data_type: 'longtext'
  is_nullable: 1

=head2 birthdate

  data_type: 'date'
  is_nullable: 1

=head2 homepage

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 dateregistered

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0

=head2 isadmin

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=head2 passwordhash

  data_type: 'binary'
  is_nullable: 0
  size: 16

=cut

__PACKAGE__->add_columns(
  "idauthors",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "firstname",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "lastname",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "username",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "email",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "about",
  { data_type => "longtext", is_nullable => 1 },
  "birthdate",
  { data_type => "date", is_nullable => 1 },
  "homepage",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "dateregistered",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
  },
  "isadmin",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "passwordhash",
  { data_type => "binary", is_nullable => 0, size => 16 },
);
__PACKAGE__->set_primary_key("idauthors");

=head1 RELATIONS

=head2 posts

Type: has_many

Related object: L<BlogDB::Schema::Result::Post>

=cut

__PACKAGE__->has_many(
  "posts",
  "BlogDB::Schema::Result::Post",
  { "foreign.authors_idauthors" => "self.idauthors" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-12-18 15:52:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ju+nn8F3sb9V+25a67LTig


# You can replace this text with custom content, and it will be preserved on regeneration
1;
