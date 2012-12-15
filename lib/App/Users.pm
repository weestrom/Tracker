#!/usr/bin/env perl
package BlogApp::Users;

use base 'Mojo::Base';

__PACKAGE__->attr('app');
    
sub check {
	my ($self, $username, $password) = @_;
	my $app = $self->app;
	my $author_rs = $app->schema->resultset('Author');
	my $author_row = $author_rs->search({ 'username' => $username})->next;
	my $password_hash = $author_row->passwordhash;
	if ( $password_hash )
	{
		my $digest = $app->digest;
		$digest->add( $username . $password );
		if(  $password_hash eq $digest->digest )
		{
			my $userid = $author_row->idauthors;
			return $userid;
		}

	} 

	return ''; 
}

sub check_comment {
	my ($self, $username, $password) = @_;
	my $app = $self->app;
	my $commentor_rs = $app->schema->resultset('Commentor');
	my $commentor_row = $commentor_rs->search({ 'username' => $username})->next || '';
	if ($commentor_row){
		my $password_hash = $commentor_row->passwordhash;
		if ( $password_hash )
		{
			my $digest = $app->digest;
			$digest->add( $username . $password );
			if(  $password_hash eq $digest->digest )
			{
				my $commentid = $commentor_row->idcommentors;
				return $commentid;
			}

		} 
		
	}
	return '';
}

sub loggedinas {
	my ($self, $controller) = @_;
	my $userid = $controller->session->{'userid'} || '';
	return '' unless $userid;
	my $username = $self->app->schema->resultset('Author')->search(
					{'idauthors' => $userid})->next->username || '';
	return $username unless !$username;
}

sub commentingas {
	my ($self, $controller) = @_;
	my $commentid = $controller->session->{'commentid'} || '';
	return '' unless $commentid;
	my $commentname = $self->app->schema->resultset('Commentor')->search(
					{'idcommentors' => $commentid})->next->username || '';
	return $commentname unless !$commentname;
	
	
}

1;