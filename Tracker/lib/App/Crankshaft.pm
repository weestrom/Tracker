#!/usr/bin/perl
package App::Crankshaft;
use base 'Mojolicious::Controller';
use Data::UUID;

sub frontpage {
	my $self = shift;
		my $pagetext = '<title> Tracker </title> <header><h1> Tracker </h1><br>';
		$pagetext = $pagetext . '<form action="/inbound/" method="GET">Open Inbound Date (YYYY-MM-DD):<input name="date" value="" type="text"><input type="submit"></form><br>';
		$pagetext = $pagetext . '<form action="/outbound/" method="GET">Open Outbound Date (YYYY-MM-DD):<input name="date" value="" type="text"><input type="submit"></form><br>';
		$self->render(text => $pagetext);

}

sub datetest {
	my $self = shift;
	my $date = shift;
	
	my @datelist = split('-',$date);
	my @numtest = split ('-',$date);
	my $numresult = 0;
	foreach my $num (@numtest)
	{
		$num =~ s/[0-9]//g;
		if (!($num eq ''))
		{
			$numresult = 1;
		}
	}
	if (scalar(@datelist) != 3 || length($datelist[0]) != 4 || length($datelist[1]) != 2 || length($datelist[2]) != 2 || $numresult == 1)
	{
		return 0;
		
	}
	else
	{
		return 1;
	}
}

sub newinbound {
	my $self = shift;
	my $pagetext = '<form action="/submitinbound" method="POST">';
	
	$pagetext = $pagetext . '<table border="0">';
	$pagetext = $pagetext . '<tr><td>Date<br />(yyyy-mm-dd)</td><td>Trac#</td><td>Trlr#</td><td>Driver</td><td>Origin</td><td>Destination</td><td>Appt<br />(yyyy-mm-dd hh:mm)</td><td>Backhaul</td></tr>';
	$pagetext = $pagetext . '<tr><td><input type="text" name="date" maxlength="10" size="10" value="' . $self->param('date') . '"/></td>';
	$pagetext = $pagetext . '<td><input type="text" name="tracnum" maxlength="6" size="6" value=""/></td>';
	$pagetext = $pagetext . '<td><input type="text" name="trlrnum" maxlength="6" size="6" value=""/></td>';
	$pagetext = $pagetext . '<td><input type="text" name="driver" maxlength="30" size="12" value=""/></td>';
	$pagetext = $pagetext . '<td><input type="text" name="origin" maxlength="30" size="12" value=""/></td>';
	$pagetext = $pagetext . '<td><input type="text" name="destination" maxlength="30" size="12" value=""/></td>';
	$pagetext = $pagetext . '<td><input type="text" name="appt" maxlength="16" size="16" value=""/></td>';
	$pagetext = $pagetext . '<td><input type="text" name="backhaul" maxlength="30" size="12" value=""/></td></tr>';
	$pagetext = $pagetext . '</table>';
	$pagetext = $pagetext . '<input type="submit" value="Submit" />';
	$pagetext = $pagetext . '</form>';
	$self->render(text => $pagetext);

}

sub submitinbound {
	my $self = shift;
	my $haul_rs = $self->app->schema->resultset('Data');
	my $ug = new Data::UUID;
	my $appt = $self->param('appt');
	$appt = $appt . ":00";
	my $date = $self->param('date');
	if ($self->datetest($date))
	{
		my $new_haul = $haul_rs->new({
		uuid => $ug->create_str(),
		recdate => $self->param('date'),
		tracnum => $self->param('tracnum'),
		trlrnum => $self->param('trlrnum'),
		driver => $self->param('driver'),
		origin => $self->param('origin'),
		destination => $self->param('destination'),
		appt => $appt,
		backhaul => $self->param('backhaul'),
		direction => 'INBOUND',
		
		});
		$new_haul->insert;
		$self->redirect_to('/inbound/' . $self->param('date'));
	}
	else
	{
		$self->render(text => 'Invalid Date Format');
		
	}

}

sub inbound {
	my $self = shift;
	my $date = $self->param('date');
	if($self->datetest($date))
	{
		my $pagetext = '<title> Tracker :: Inbound Loads </title> <header><h1>' . $date .  ' Inbound Loads</h1><br>';
		$pagetext = $pagetext . '<form action="/inbound/" method="GET">Open Date (YYYY-MM-DD):<input name="date" value="" type="text"><input type="submit"></form><br>';
		$pagetext = $pagetext . '<table border="1">';
		$pagetext = $pagetext . '<tr><td></td><td>Trac#</td><td>Trlr#</td><td>Driver</td><td>Origin</td><td>Destination</td><td>Appt</td><td>Backhaul</td></tr>';
		
		my $inbound_rs = $self->app->schema->resultset('Inbound');
		my $inbound_search = $inbound_rs->search( recdate => $date );
		my $inbound_row;
		while ( $inbound_row = $inbound_search->next || '')
		{
			$pagetext = $pagetext . '<tr><td><a href="' . $self->url_for('/edit/' . $inbound_row->uuid) . '">edit</a></td>';
			$pagetext = $pagetext . '<td>' . $inbound_row->tracnum . '</td>';
			$pagetext = $pagetext . '<td>' . $inbound_row->trlrnum . '</td>';
			$pagetext = $pagetext . '<td>' . $inbound_row->driver . '</td>';
			$pagetext = $pagetext . '<td>' . $inbound_row->origin . '</td>';
			$pagetext = $pagetext . '<td>' . $inbound_row->destination . '</td>';
			$pagetext = $pagetext . '<td>' . $inbound_row->appt . '</td>';
			$pagetext = $pagetext . '<td>' . $inbound_row->backhaul . '</td></tr>';
		}
		$pagetext = $pagetext . '</table><br>';
		$pagetext = $pagetext . '<a href="' . $self->url_for('/newinbound/' . $date) . '">New Load</a>';
		
		$self->render(text => $pagetext);
		
	}
	else
	{
		$self->render(text =>'Invalid Date Format');
	}
	
}

sub newoutbound {
	my $self = shift;
	my $pagetext = '<form action="/submitoutbound" method="POST">';
	
	$pagetext = $pagetext . '<table border="0">';
	$pagetext = $pagetext . '<tr><td>Date<br />(yyyy-mm-dd)</td><td>Trac#</td><td>Trlr#</td><td>Driver</td><td>Origin</td><td>Destination</td><td>Appt<br />(yyyy-mm-dd hh:mm)</td><td>Backhaul</td></tr>';
	$pagetext = $pagetext . '<tr><td><input type="text" name="date" maxlength="10" size="10" value="' . $self->param('date') . '"/></td>';
	$pagetext = $pagetext . '<td><input type="text" name="tracnum" maxlength="6" size="6" value=""/></td>';
	$pagetext = $pagetext . '<td><input type="text" name="trlrnum" maxlength="6" size="6" value=""/></td>';
	$pagetext = $pagetext . '<td><input type="text" name="driver" maxlength="30" size="12" value=""/></td>';
	$pagetext = $pagetext . '<td><input type="text" name="origin" maxlength="30" size="12" value=""/></td>';
	$pagetext = $pagetext . '<td><input type="text" name="destination" maxlength="30" size="12" value=""/></td>';
	$pagetext = $pagetext . '<td><input type="text" name="appt" maxlength="16" size="16" value=""/></td>';
	$pagetext = $pagetext . '<td><input type="text" name="backhaul" maxlength="30" size="12" value=""/></td></tr>';
	$pagetext = $pagetext . '</table>';
	$pagetext = $pagetext . '<input type="submit" value="Submit" />';
	$pagetext = $pagetext . '</form>';
	$self->render(text => $pagetext);

}

sub submitoutbound {
	my $self = shift;
	my $haul_rs = $self->app->schema->resultset('Data');
	my $ug = new Data::UUID;
	my $appt = $self->param('appt');
	$appt = $appt . ":00";
	my $date = $self->param('date');
	if ($self->datetest($date))
	{
		my $new_haul = $haul_rs->new({
		uuid => $ug->create_str(),
		recdate => $self->param('date'),
		tracnum => $self->param('tracnum'),
		trlrnum => $self->param('trlrnum'),
		driver => $self->param('driver'),
		origin => $self->param('origin'),
		destination => $self->param('destination'),
		appt => $appt,
		backhaul => $self->param('backhaul'),
		direction => 'OUTBOUND',
		
		});
		$new_haul->insert;
		$self->redirect_to('/outbound/' . $self->param('date'));
	}
	else
	{
		$self->render(text => 'Invalid Date Format');
		
	}

}

sub outbound {
	my $self = shift;
	my $date = $self->param('date');
	if($self->datetest($date))
	{
		my $pagetext = '<title> Tracker :: Outbound Loads </title> <header><h1>' . $date .  ' Outbound Loads</h1><br>';
		$pagetext = $pagetext . '<form action="/inbound/" method="GET">Open Date (YYYY-MM-DD):<input name="date" value="" type="text"><input type="submit"></form><br>';
		$pagetext = $pagetext . '<table border="1">';
		$pagetext = $pagetext . '<tr><td></td><td>Trac#</td><td>Trlr#</td><td>Driver</td><td>Origin</td><td>Destination</td><td>Appt</td><td>Backhaul</td></tr>';
		
		my $outbound_rs = $self->app->schema->resultset('Outbound');
		my $outbound_search = $outbound_rs->search( recdate => $date );
		my $outbound_row;
		while ( $outbound_row = $outbound_search->next || '')
		{
			$pagetext = $pagetext . '<tr><td><a href="' . $self->url_for('/edit/' . $outbound_row->uuid) . '">edit</a></td>';
			$pagetext = $pagetext . '<td>' . $outbound_row->tracnum . '</td>';
			$pagetext = $pagetext . '<td>' . $outbound_row->trlrnum . '</td>';
			$pagetext = $pagetext . '<td>' . $outbound_row->driver . '</td>';
			$pagetext = $pagetext . '<td>' . $outbound_row->origin . '</td>';
			$pagetext = $pagetext . '<td>' . $outbound_row->destination . '</td>';
			$pagetext = $pagetext . '<td>' . $outbound_row->appt . '</td>';
			$pagetext = $pagetext . '<td>' . $outbound_row->backhaul . '</td></tr>';
		}
		$pagetext = $pagetext . '</table><br>';
		$pagetext = $pagetext . '<a href="' . $self->url_for('/newoutbound/' . $date) . '">New Load</a>';
		
		$self->render(text => $pagetext);
		
	}
	else
	{
		$self->render(text =>'Invalid Date Format');
	}
	
}

sub edit {
	my $self = shift;
	my $uuid = $self->param('uuid');
	my $data_row = $self->app->schema->resultset('Data')->search({uuid => $uuid})->next || '';
	if ($data_row)
	{
		my $pagetext = '<form action="uuidedit" method="POST"><input type="hidden" name="uuid" value="' . $uuid . '"/>';
		$pagetext = $pagetext . '<input type="hidden" name="direction" value="' . $data_row->direction . '"/>';
		$pagetext = $pagetext . '<table border="0">';
		$pagetext = $pagetext . '<tr><td>Date<br />(yyyy-mm-dd)</td><td>Trac#</td><td>Trlr#</td><td>Driver</td><td>Origin</td><td>Destination</td><td>Appt<br />(yyyy-mm-dd hh:mm)</td><td>Backhaul</td></tr>';
		$pagetext = $pagetext . '<tr><td><input type="text" name="recdate" maxlength="10" size="10" value="' . $data_row->recdate . '"/></td>';
		$pagetext = $pagetext . '<td><input type="text" name="tracnum" maxlength="6" size="6" value="' . $data_row->tracnum . '"/></td>';
		$pagetext = $pagetext . '<td><input type="text" name="trlrnum" maxlength="6" size="6" value="' . $data_row->trlrnum . '"/></td>';
		$pagetext = $pagetext . '<td><input type="text" name="driver" maxlength="30" size="12" value="' . $data_row->driver . '"/></td>';
		$pagetext = $pagetext . '<td><input type="text" name="origin" maxlength="30" size="12" value="' . $data_row->origin . '"/></td>';
		$pagetext = $pagetext . '<td><input type="text" name="destination" maxlength="30" size="12" value="' . $data_row->destination . '"/></td>';
		$pagetext = $pagetext . '<td><input type="text" name="appt" maxlength="20" size="20" value="' . $data_row->appt . '"/></td>';
		$pagetext = $pagetext . '<td><input type="text" name="backhaul" maxlength="30" size="12" value="' . $data_row->backhaul . '"/></td></tr>';
		$pagetext = $pagetext . '</table>';
		$pagetext = $pagetext . '<input type="submit" value="Submit" />';
		$pagetext = $pagetext . '</form>';
		$self->render(text => $pagetext);
	}
	else
	{
		$self->redirect_to('/');
	}
}

sub uuidedit {
	my $self = shift;
	my $data_row = $self->app->schema->resultset('Data')->search({uuid => $self->param('uuid')})->next || '';
	if ($data_row)
	{
		$data_row->update(
		{
			'recdate' => $self->param('recdate'),
			'tracnum' => $self->param('tracnum'),
			'trlrnum' => $self->param('trlrnum'),
			'driver' => $self->param('driver'),
			'origin' => $self->param('origin'),
			'destination' => $self->param('destination'),
			'appt' => $self->param('appt'),
			'backhaul' => $self->param('backhaul')
				
		});
	}
	my $direction = $self->param('direction');
	$direction =~ tr/A-Z/a-z/;
	$self->redirect_to('/' . $direction . '/' . $self->param('recdate'));
}



1;