#!/usr/bin/perl
package App;
use lib "../";
use AppDB::Schema;
use Digest::MD5;
use XML::Simple;
use base 'Mojolicious';

__PACKAGE__->attr('digest');
__PACKAGE__->attr('xml');
__PACKAGE__->attr('config');
__PACKAGE__->attr('schema');
__PACKAGE__->attr('rootdir' => '.');
__PACKAGE__->attr('dbtype' => 'mysql');


sub startup {
	my $self = shift;
	$self->digest(Digest::MD5->new);
	$self->xml(XML::Simple->new, KeyAttr => [], ForceArray => 1);
	$self->config($self->xml->XMLin( $self->rootdir . 
		'/etc/tracker/tracker.xml'));
	my $connectstr = 'dbi:' . $self->dbtype .':host='. $self->config->{database}->{server}->{value} . 
			';database=' . $self->config->{database}->{schema}->{value};
	$self->schema(AppDB::Schema->connect(
		$connectstr, 
		$self->config->{database}->{user}->{value}, 
		$self->config->{database}->{password}->{value}));
	#routes
	my $r = $self->routes;
	
	#Default route
	$r->route('/')->to('crankshaft#frontpage');
	
	#Applicaton routes
	$r->route( '/inbound/')->to('crankshaft#inbound');
	$r->route( '/outbound/')->to('crankshaft#outbound');
	$r->route( '/inbound/*date')->to('crankshaft#inbound');
	$r->route( '/outbound/*date')->to('crankshaft#outbound');
	$r->route( '/newinbound/submitinbound/')->to('crankshaft#submitinbound');
	$r->route( '/newoutbound/submitoutbound/')->to('crankshaft#submitoutbound');
	$r->route( '/newinbound/*date')->to('crankshaft#newinbound');
	$r->route( '/newoutbound/*date')->to('crankshaft#newoutbound');
	$r->route( '/submitinbound/')->to('crankshaft#submitinbound');
	$r->route( '/submitoutbound/')->to('crankshaft#submitoutbound');
	$r->route( '/edit/uuidedit')->to('crankshaft#uuidedit');
	$r->route( '/edit/:uuid')->to('crankshaft#edit');
	}

1;
