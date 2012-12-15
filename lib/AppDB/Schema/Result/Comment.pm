package BlogDB::Schema::Result::Comment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

BlogDB::Schema::Result::Comment

=cut

__PACKAGE__->table("Comments");

=head1 ACCESSORS

=head2 idcomments

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 datecommentposted

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0

=head2 comment

  data_type: 'longtext'
  is_nullable: 0

=head2 commentors_idcommentors

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 posts_idposts

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "idcomments",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "datecommentposted",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
  },
  "comment",
  { data_type => "longtext", is_nullable => 0 },
  "commentors_idcommentors",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "posts_idposts",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("idcomments", "commentors_idcommentors", "posts_idposts");

=head1 RELATIONS

=head2 commentors_idcommentor

Type: belongs_to

Related object: L<BlogDB::Schema::Result::Commentor>

=cut

__PACKAGE__->belongs_to(
  "commentors_idcommentor",
  "BlogDB::Schema::Result::Commentor",
  { idcommentors => "commentors_idcommentors" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 posts_idpost

Type: belongs_to

Related object: L<BlogDB::Schema::Result::Post>

=cut

__PACKAGE__->belongs_to(
  "posts_idpost",
  "BlogDB::Schema::Result::Post",
  { idposts => "posts_idposts" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-12-15 21:21:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:LrVvGNVjsKcl2ygMb7oOTg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
