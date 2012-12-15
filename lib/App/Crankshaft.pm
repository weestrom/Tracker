#!/usr/bin/perl
package BlogApp::Crankshaft;
use base 'Mojolicious::Controller';

sub frontpage {
	my $self = shift;
		
		my $frontpage_rs = $self->app->schema->resultset('FrontPage');
		my $blogname = $self->app->blogname;
		my $username = $self->app->users->loggedinas($self) || '';
		$self->render(frontpage_rs => $frontpage_rs, blogname => $blogname, 'username' => $username);

}

sub writepost {
	my $self = shift;
	my $userid = $self->session->{'userid'} || '';
	$self->redirect_to('/adminlogin') unless $userid;
	my $schema = $self->app->schema;
	my $author_rs = $schema->resultset('Author')->search({idauthors => $userid});
	
	
	## TODO: Eventually move this off to a template
	my $pagetext = '<form action="submitpost" method="POST">';
	
	$pagetext = $pagetext . 'Title: <input type="text" name="title" maxlength="45" size="45" /> <br />';
	$pagetext = $pagetext . 'Body: <textarea name="text" rows="80" columns="40" ></textarea><br />';
	$pagetext = $pagetext . '<input type="submit" value="Submit" />';
	$pagetext = $pagetext . '</form>';
	$self->render(text => $pagetext);

}

sub submitpost {
	my $self = shift;
	my $idauthors = $self->session->{'userid'} || '';
	print $idauthors . '/n';
	my $title = $self->param('title');
	my $mytext = $self->param('text');
	my $post_rs = $self->app->schema->resultset('Post');
	my $post_url = $title;
	
	##########################################################
	## This should be a configurable method with some logic ##
	##########################################################
	$post_url =~ tr/ /_/;
	$post_url =~ tr/a-zA-Z0-9//c; 
	my $post_suffix = 2;
	my $previous_suffix = '';
	while ($post_rs->find(
	{
		'posturl' => $post_url
	})) {
		if ($post_suffix == 2){
			$post_url = $post_url . $post_suffix;
		}
		else {
			$post_url =~ s/$previous_suffix$/$post_suffix/;
		}
		$previous_suffix = $post_suffix;
		$post_suffix++;
	}
	##########################################################
	## This should be a configurable method with some logic ##
	##########################################################
	
		my $new_post = $post_rs->new({
		'authors_idauthors' => $idauthors,
		'text' => $mytext,
		'title' => $title,
		'posturl' => $post_url
	});
	$new_post->insert;
	$self->redirect_to('/')
	
	
}

sub article {
	my $self = shift;
	my $post_rs = $self->app->schema->resultset('Post');
	my $post_url = $self->param('urltitle');
	my $blogname = $self->app->blogname;
	my $username = $self->app->users->loggedinas($self) || '';
	my $article_row = $post_rs->search(
		{ 'posturl' => $post_url },
		{ 'prefetch' => 'authors_idauthor' })->next || '';
	if( $article_row	)
	{
		my $comments_rs = $self->app->schema->resultset('Comment')->search(
		{ 'posts_idposts' => $article_row->idposts },
		{ prefetch => 'commentors_idcommentor' });
		my $commentname = $self->app->users->commentingas($self);
	
		$self->render(article_row => $article_row, comments_rs => $comments_rs, blogname => $blogname, commentorname => $commentname, username => $username );
	}
	else
	{
		$self->render();
	}
}

sub author {
	my $self = shift;
	my $author_rs = $self->app->schema->resultset('Author');
	my $username = $self->param('username');
	my $blogname = $self->app->blogname;
	if( $author_rs->search(
	{ 'username' => $username }
	))
	{
		my $author_row = $author_rs->search(
		{ 'username' => $username }
		)->next;
		my $posts_rs = $self->app->schema->resultset('Post')->search(
		{ 'authors_idauthors' => $author_row->idauthors});
		$self->render(author_row => $author_row, posts_rs => $posts_rs, blogname => $blogname);
			
	}
}

sub commentor {
	my $self = shift;
	my $commentor_rs = $self->app->schema->resultset('Commentor');
	my $username = $self->param('username');
	my $blogname = $self->app->blogname;
	my $commentorname = $self->app->users->commentingas($self) || '';
	if( $commentor_rs->search(
	{ 'username' => $username }
	))
	{
		my $commentor_row = $commentor_rs->search(
		{ 'username' => $username }
		)->next;
		$self->render(commentor_row => $commentor_row, blogname => $blogname, commentorname => $commentorname);
	}
	
}

sub admin {
	my $self = shift;
	my $app = $self->app;
	my $userid = $self->session('userid') || '';
	if ($userid)
	{
		my $author_rs = $self->app->schema->resultset('Author')->search(
			{ 'idauthors' => $userid }
			);
		if ( $author_rs )
		{
			my $blogname = $self->app->blogname;
			$self->render(author_rs => $author_rs, blogname => $blogname);
		}
	}
	else
	{
		$self->redirect_to('/adminlogin')
	}
}

sub adminlogin {
	my $self = shift;
	my $message =  $self->stash('message');
	my $username = $self->stash('username');
	$self->render(template => 'crankshaft/login', logintype => 'admin', blogname => $self->app->blogname, message => $message, username => $username )
}
	
sub loginadmin {
	my $self = shift;
	my $app = $self->app;
	my $users = $app->users;
	$users->app($app);
	my $userid = $users->check($self->param('username'), $self->param('password')) || '';
	
	 
	$self->redirect_to('/adminlogin', 'message' => 'Error: Invalid username/password comination!', 
					'username' => $self->param('username') ) unless $userid;
			 
	$self->session( userid => $userid);
	$self->redirect_to('/admin');
}

sub addadmin {
	##This is a temporary method until database init is designed
	my $self = shift;
	my $message = $self->stash('message');
	my $username = $self->stash('username');
	my $pagetext = $message . '<br /><form action="adminadd" method="POST">';
	
	$pagetext = $pagetext . 'username: <input type="text" name="username" maxlength="12" size="12" value="' . $username . '"/> <br />';
	$pagetext = $pagetext . 'password: <input type="password" name="password" maxlength="12" size="12" /> <br />';
	$pagetext = $pagetext . 'password again: <input type="password" name="password2" maxlength="12" size="12" /> <br />';
	$pagetext = $pagetext . '<input type="submit" value="Submit" />';
	$pagetext = $pagetext . '</form>';
	$self->render(text => $pagetext);
	
}

sub adminadd {
	##This is a temporary method until database init is designed
	my $self = shift;
	my $username = $self->param('username');
	my $password = $self->param('password');
	my $password2 = $self->param('password2');
	
	if ($password eq $password2)
	{
		my $digest = $self->app->digest;
		$digest->add($username . $password);
		my $password_hash = $digest->digest;
		my $author_rs = $self->app->schema->resultset('Author');
		my $new_author = $author_rs->new({
			'username' => $username,
			'passwordhash' => $password_hash
		});
		$new_author->insert;
		$self->redirect_to('/admin')
	}
	else
	{
		$self->redirect_to('/addadmin', message => 'Error: passwords do not match!')
	}
	
}

sub commentlogin {
	my $self = shift;
	my $message =  $self->stash('message');
	my $username = $self->stash('username');
	$self->render(template => 'crankshaft/login', logintype => 'comment', blogname => $self->app->blogname, message => $message, username => $username )
}
	
sub logincomment {
	my $self = shift;
	my $app = $self->app;
	my $users = $app->users;
	my $commentid = $users->check_comment($self->param('username'), $self->param('password')) || '';
	
	 
	$self->redirect_to('/commentlogin', 'message' => 'Error: Invalid username/password combination!', 
					'username' => $self->param('username') ) unless $commentid;
			 
	$self->session( 'commentid' => $commentid);
	$self->redirect_to('/');
}

sub commentregister {
	my $self = shift;
	my $message = $self->stash('message');
	my $username = $self->stash('username');
	my $pagetext = $message . '<br /><form action="registercomment" method="POST">';
	
	$pagetext = $pagetext . 'username: <input type="text" name="username" maxlength="12" size="12" value="' . $username . '"/> <br />';
	$pagetext = $pagetext . 'password: <input type="password" name="password" maxlength="12" size="12" /> <br />';
	$pagetext = $pagetext . 'password again: <input type="password" name="password2" maxlength="12" size="12" /> <br />';
	$pagetext = $pagetext . '<input type="submit" value="Submit" />';
	$pagetext = $pagetext . '</form>';
	$self->render(text => $pagetext);
}

sub registercomment {
	my $self = shift;
	my $username = $self->param('username');
	my $password = $self->param('password');
	my $password2 = $self->param('password2');
	my $commentor_dup_check = $self->app->schema->resultset('Commentor')->search({username => $username}) || '';
	
	if ($commentor_dup_check)
	{
		$self->redirect_to('/commentregister', message => 'Error: username is taken!');
	}
	elsif ($password eq $password2)
	{
		my $digest = $self->app->digest;
		$digest->add($username . $password);
		my $password_hash = $digest->digest;
		my $commentor_rs = $self->app->schema->resultset('Commentor');
		my $new_commentor = $commentor_rs->new({
			'username' => $username,
			'passwordhash' => $password_hash
		});
		$new_commentor->insert;
		$self->redirect_to('/commentlogin');
	}
	else
	{
		$self->redirect_to('/commentregister', message => 'Error: passwords do not match!');
	}
}

sub submitcomment {
	my $self = shift;
	if ($self->param('comment'))
	{
		my $comment_rs = $self->app->schema->resultset('Comment');
		my $new_comment = $comment_rs->new({
			'posts_idposts' => $self->param('idposts'),
			'commentors_idcommentors' => $self->session('commentid'),
			'comment' => $self->param('comment')
		});
		$new_comment->insert;
	}
	
	$self->redirect_to('/articles/' . $self->app->schema->resultset('Post')->search({idposts => $self->param('idposts')})->next->posturl);
}

sub config {
	my $self = shift;
	my $config = $self->app->config;
	$self->redirect_to('/adminlogin') unless $self->app->users->loggedinas($self);
	 $self->render( config => $config, blogname => $self->app->blogname );
}

sub submitconfig {
	my $self = shift;
	my $config = $self->app->config;
   	foreach my $sectionkey (keys %$config) {
    	my $sectionref = $config->{$sectionkey};
    	foreach my $itemkey (keys %$sectionref) {
    		if (!($itemkey eq 'heading')) {
    			$config->{$sectionkey}->{$itemkey}->{value} = $self->param($itemkey);
    		}
    	}
    }
    
    $self->app->xml->XMLout($config, outputfile => $self->app->rootdir . '/etc/cornhusk/cornhusk.xml', rootname => 'config');
    $self->redirect_to('/config');
}


sub posts {
	my $self = shift;
	my $posts_rs = $self->app->schema->resultset('Post')->search(
			{ 'authors_idauthors' => $self->app->schema->resultset('Author')->search(
					{ 'username' => $self->app->users->loggedinas($self)})->next->idauthors});		
	$self->render( blogname => $self->app->blogname, username => $self->app->users->loggedinas($self),
		posts_rs => $posts_rs); 
}

sub editpost {
	my $self = shift;
	my $post_row = $self->app->schema->resultset('Post')->search({idposts => $self->param('idposts')})->next;
	
		my $pagetext = '<form action="postedit" method="POST">';
	
	$pagetext = $pagetext . 'Title: <input type="text" name="title" maxlength="45" size="45" value="' . $post_row->title . '" /> <br />';
	$pagetext = $pagetext . 'Body: <textarea name="text" rows="40" cols="80">' .  $post_row->text . '</textarea><br />';
	$pagetext = $pagetext . '<input type="hidden" name="idposts" value="' . $post_row->idposts . '" />';
	$pagetext = $pagetext . '<input type="submit" value="Submit" />';
	$pagetext = $pagetext . '</form>';
	$self->render(text => $pagetext);
}

sub postedit {
	my $self = shift;
	my $post_row = $self->app->schema->resultset('Post')->search(idposts => $self->param('idposts'))->next;
	$post_row->update(
	{
		'title' => $self->param('title'),
		'text' => $self->param('text')
		
	});
	$self->redirect_to('/posts');
}

sub editprofile {
	my $self = shift;
	my $author_rs = $self->app->schema->resultset('Author');
	my $username = $self->app->users->loggedinas($self);
	my $blogname = $self->app->blogname;
	if( $author_rs->search(
	{ 'username' => $username }
	))
	{
		my $author_row = $author_rs->search(
		{ 'username' => $username }
		)->next;
		$self->render(author_row => $author_row, blogname => $blogname, username => $username);
			
	}
}

sub profileedit {
	my $self = shift;
	my $author_rs = $self->app->schema->resultset('Author');
	my $username = $self->app->users->loggedinas($self);
	if( $author_rs->search(
	{ 'username' => $username }
	))
	{
		my $author_row = $author_rs->search(
		{ 'username' => $username }
		)->next;
		$author_row->update({
			firstname => $self->param('firstname'),
			lastname => $self->param('lastname'),
			email => $self->param('email'),
			homepage => $self->param('homepage'),
			birthdate => $self->param('birthdate'),
			about => $self->param('about')
		});
	}
	$self->redirect_to('/admin');
}

sub logout {
	my $self = shift;
	$self->session(expires => 1);
	$self->redirect_to('/')
}

sub usermanage {
	my $self = shift;
	my $username = $self->app->users->loggedinas($self) || '';
	$self->redirect_to('/admin') unless $username;
	my $author_rs = $self->app->schema->resultset('Author');
	$self->render(author_rs => $author_rs, blogname => $self->app->blogname, username => $username);
}

sub commentormanage {
	my $self = shift;
	$self->redirect_to('/admin') unless $self->app->users->loggedinas($self);
	my $commentor_rs = $self->app->schema->resultset('Commentor');
	$self->render(commentor_rs => $commentor_rs, blogname => $self->app->blogname);
}

sub deleteuser {
	my $self = shift;
	$self->redirect_to('/admin') unless $self->app->users->loggedinas($self);
	my $idauthors = $self->param('idauthors');
	my $post_rs = $self->app->schema->resultset('Post')->search({
		authors_idauthors => $idauthors 
	}) || '';
	
	$self->redirect_to('/usermanage') unless $post_rs;
	while (my $post_row = $post_rs->next) {
		$post_row->delete;
	}
	
	my $author_rs = $self->app->schema->resultset('Author')->search({
		idauthors => $idauthors
	}) || '';
	
	$self->redirect_to('/usermanage') unless $author_rs;
	$author_rs->next->delete;
	
	$self->redirect_to('/usermanage');
}


sub deletecommentor {
	my $self = shift;
	$self->redirect_to('/admin') unless $self->app->users->loggedinas($self);
	my $idcommentors = $self->param('idcommentors');
	my $comment_rs = $self->app->schema->resultset('Comment')->search({
		commentors_idcommentors => $idcommentors 
	}) || '';
	
	$self->redirect_to('/commentormanage') unless $comment_rs;
	while (my $comment_row = $comment_rs->next) {
		$comment_row->delete;
	}
	
	my $commentor_rs = $self->app->schema->resultset('Commentor')->search({
		idcommentors => $idcommentors
	}) || '';
	
	$self->redirect_to('/commentormanage') unless $commentor_rs;
	$commentor_rs->next->delete;
	
	$self->redirect_to('/commentormanage');
}


sub addcommentor {
	##This is a temporary method until database init is designed
	my $self = shift;
	my $message = $self->stash('message');
	my $username = $self->stash('username');
	my $pagetext = $message . '<br /><form action="commentoradd" method="POST">';
	
	$pagetext = $pagetext . 'username: <input type="text" name="username" maxlength="12" size="12" value="' . $username . '"/> <br />';
	$pagetext = $pagetext . 'password: <input type="password" name="password" maxlength="12" size="12" /> <br />';
	$pagetext = $pagetext . 'password again: <input type="password" name="password2" maxlength="12" size="12" /> <br />';
	$pagetext = $pagetext . '<input type="submit" value="Submit" />';
	$pagetext = $pagetext . '</form>';
	$self->render(text => $pagetext);
	
}

sub commentoradd {
	##This is a temporary method until database init is designed
	my $self = shift;
	my $username = $self->param('username');
	my $password = $self->param('password');
	my $password2 = $self->param('password2');
	my $commentor_row = $self->app->schema->resultset('Commentor')->search({
		username => $username
	})->next || '';
	$self->redirect_to('/addcommentor', message => 'Error: username taken!', username => $username) unless $commentor_row eq '';
	if ($password eq $password2)
	{
		my $digest = $self->app->digest;
		$digest->add($username . $password);
		my $password_hash = $digest->digest;
		my $commentor_rs = $self->app->schema->resultset('Commentor');
		my $new_commentor = $commentor_rs->new({
			'username' => $username,
			'passwordhash' => $password_hash
		});
		$new_commentor->insert;
		$self->redirect_to('/admin')
	}
	else
	{
		$self->redirect_to('/addcommentor', username => $username, message => 'Error: passwords do not match!')
	}
	
}


sub editcommentor {
	my $self = shift;
	my $commentor_rs = $self->app->schema->resultset('Commentor');
	my $username = $self->app->users->commentingas($self);
	my $blogname = $self->app->blogname;
	if( $commentor_rs->search(
	{ 'username' => $username }
	))
	{
		my $commentor_row = $commentor_rs->search(
		{ 'username' => $username }
		)->next;
		$self->render(commentor_row => $commentor_row, blogname => $blogname, username => $username);
			
	}
}

sub commentoredit {
	my $self = shift;
	my $commentor_rs = $self->app->schema->resultset('Commentor');
	my $username = $self->app->users->commentingas($self);
	if( $commentor_rs->search(
	{ 'username' => $username }
	))
	{
		my $commentor_row = $commentor_rs->search(
		{ 'username' => $username }
		)->next;
		$commentor_row->update({
			firstname => $self->param('firstname'),
			lastname => $self->param('lastname'),
			email => $self->param('email'),
			homepage => $self->param('homepage')
		});
	}
	$self->redirect_to('/commentors/' . $username);
}

sub deletecomment {
	my $self = shift;
	$self->redirect_to('/') unless $self->app->users->loggedinas($self);
	my $idcomments = $self->param('idcomments');
	my $comment_row = $self->app->schema->resultset('Comment')->search({
		'idcomments' => $idcomments
	})->next || '';
	$self->redirect_to('/') unless $comment_row;
	my $posturl = $self->app->schema->resultset('Post')->search({
		'idposts' => $comment_row->posts_idposts
	})->next->posturl;
	$comment_row->delete;
	$self->redirect_to('/articles/' . $posturl);
}

1;