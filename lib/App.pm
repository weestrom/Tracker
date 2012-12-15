#!/usr/bin/perl
package BlogApp;
use lib "../";
use BlogDB::Schema;
use Digest::MD5;
use BlogApp::Users;
use XML::Simple;
use base 'Mojolicious';

__PACKAGE__->attr('digest');
__PACKAGE__->attr('users');
__PACKAGE__->attr('xml');
__PACKAGE__->attr('config');
__PACKAGE__->attr('schema');
__PACKAGE__->attr('rootdir' => '.');
__PACKAGE__->attr('dbtype' => 'mysql');
__PACKAGE__->attr('blogname');


sub startup {
	my $self = shift;
	$self->digest(Digest::MD5->new);
	$self->users(BlogApp::Users->new('app' => $self));
	$self->xml(XML::Simple->new, KeyAttr => [], ForceArray => 1);
	$self->config($self->xml->XMLin( $self->rootdir . 
		'/etc/cornhusk/cornhusk.xml'));
	my $connectstr = 'dbi:' . $self->dbtype .':host='. $self->config->{database}->{server}->{value} . 
			';database=' . $self->config->{database}->{schema}->{value};
	$self->schema(BlogDB::Schema->connect(
		$connectstr, 
		$self->config->{database}->{user}->{value}, 
		$self->config->{database}->{password}->{value}));
	$self->blogname( $self->config->{application}->{blogname}->{value});
	#routes
	my $r = $self->routes;
	
	#Default route
	$r->route('/')->to('crankshaft#frontpage');
	
	#Applicaton routes
	$r->route( '/authors/:username')->to('crankshaft#author');
	$r->route( '/commentors/:username')->to('crankshaft#commentor');
	$r->route( '/articles/:urltitle')->to('crankshaft#article');
	$r->route( '/edit/postedit')->to('crankshaft#postedit');
	$r->route( '/usermanage/deleteuser')->to('crankshaft#deleteuser');
	$r->route( '/commentormanage/deletecommentor')->to('crankshaft#deletecommentor');
	$r->route( '/editcommentor/commentoredit')->to('crankshaft#commentoredit');
	$r->route('/edit/:idposts')->to('crankshaft#editpost');
	$r->route('/deletecomment/:idcomments')->to('crankshaft#deletecomment');
	$r->route('/:action')->to('crankshaft#$action');
	}

1;

