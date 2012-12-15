#!/usr/bin/perl
package BlogApp::Crankshaft;
use base 'Mojolicious::Controller';

sub welcome {
	my $self = shift;
	my $app = $self->app;
	my $schema = $app->schema;
	my $frontpage_rs = $schema->resultset('FrontPage');
	my $pagetext = '<table border = "1"><tr>';
	
	my $headerrow = 1;
	my %headerhash = $schema->resultset('FrontPage')->next->get_columns;
	while ( my $frontpage_row = $frontpage_rs->next) {
		
		if ($headerrow){
			foreach my $key (keys %headerhash) {
				if ($headerrow)	{
					$pagetext = $pagetext . '<th>' . "$key" . '</th>';
				}
			}
			$headerrow = '';
			$pagetext = $pagetext . '</tr>'
		}
		
		my %frontpage_columns = $frontpage_row->get_columns;
		$pagetext = $pagetext . "<tr>";
		foreach my $key (keys %frontpage_columns)
		{
			$pagetext = $pagetext . "<td>" . $frontpage_columns{$key} . "</td>";
		}
	$pagetext = $pagetext . "</tr>";
	}
	$pagetext = $pagetext . "<caption>FrontPage table view</caption>";
	$pagetext = $pagetext . "</table>";
	$pagetext = $pagetext . '<p><a href="writepost">Write Post</a></p>';
	$self->render(text => $pagetext);
}

sub writepost {
	my $self = shift;
	my $schema = $self->app->schema;
	my $author_rs = $schema->resultset('Author');
	
	my $pagetext = '<form action="submitpost" method="POST"><select name="idauthors">';
	while ( my $author_row = $author_rs->next) {
		
		my %author_columns = $author_row->get_columns;
		$pagetext = $pagetext . '<option value="' . $author_columns{'idauthors'} . '">' . $author_columns{'username'} . '</option>';
	}
	$pagetext = $pagetext . "</select><br />";
	
	$pagetext = $pagetext . 'Title: <input type="text" name="title" maxlength="45" size="45" /> <br />';
	$pagetext = $pagetext . 'Body: <textarea name="text" rows="40" columns="80" ></textarea><br />';
	$pagetext = $pagetext . '<input type="submit" value="Submit" />';
	$pagetext = $pagetext . '</form>';
	$self->render(text => $pagetext);

}

sub submitpost {
	my $self = shift;
	my $idauthors = $self->param('idauthors');
	my $title = $self->param('title');
	my $mytext = $self->param('text');
	print $idauthors;
	print $title;
	print $mytext;
	my $post_rs = $self->app->schema->resultset('Post');
	my $new_post = $post_rs->new({
		authors_idauthors => $idauthors,
		text => $mytext,
		title => $title
	});
	$new_post->insert;
	
	
}

1;