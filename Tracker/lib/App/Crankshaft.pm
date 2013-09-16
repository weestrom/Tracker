#!/usr/bin/perl

#######################################################################################
#                 Copyright (c) 2013 Digitronix, Inc.                                 #
#					 All rights reserved											  #
#######################################################################################

package App::Crankshaft;
use base 'Mojolicious::Controller';
use Data::UUID;
use HTTP::Date;

sub frontpage {
	my $self = shift;
		my $pagetext = '<title> Tracker </title> <header><h1> Tracker </h1><br>';
		$pagetext = $pagetext . '<form action="/inbound/" method="GET">Open Inbound Date (MMDDYY):<input name="date" value="" type="text"><input type="submit"></form><br>';
		$pagetext = $pagetext . '<form action="/outbound/" method="GET">Open Outbound Date (MMDDYY):<input name="date" value="" type="text"><input type="submit"></form><br>';
		$self->render(text => $pagetext);

}

sub datehandler {
	my $self = shift;
	my $datestring = shift;
	my $teststring = $datestring;
	my @datelist = split("",$datestring);
	
	if (scalar(@datelist) == 4)
	{
		my ($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
		my $year = $yearOffset - 100;
		$datestring = $datestring.$year;
		@datelist = split("",$datestring);
	}
	if (scalar(@datelist) == 8)
	{
		return $datestring;
	}
	
	
	if (scalar(@datelist) != 6)
	{
		return '';
	}
	
	$teststring =~ s/[0-9]//g;
	if (!($teststring eq ''))
	{
		return '';
	}
	my $daystring = substr($datestring, 2, 2);
	my $monthstring = substr($datestring, 0, 2);
	my $yearstring = substr($datestring, 4, 2);
	return '20' . $yearstring . '-' . $monthstring . '-' . $daystring;
}

sub displaydate {
	my $self = shift;
	my $datestring = shift;
	
	return substr($datestring,5,2) . substr($datestring,8,2) . substr($datestring,2,2);
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
	$pagetext = $pagetext . '<tr><td>Date<br />(mmddyy)</td><td>Trac#</td><td>Trlr#</td><td>Driver</td><td>Origin</td><td>Destination</td><td>Appt<br />(mmddyy hh:mm)</td><td>Backhaul</td></tr>';
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
	my @apptsplit = split(' ',$appt);
	$appt = $self->datehandler($apptsplit[0]) . ' '  . $apptsplit[1];
	my $date = $self->param('date');
	my $dbdate = $self->datehandler($date);
	if ($self->datetest($dbdate))
	{
		my $new_haul = $haul_rs->new({
		uuid => $ug->create_str(),
		recdate => $dbdate,
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
	my $dbdate = $self->datehandler($date);
	my $displaydate = $self->displaydate($dbdate);
	if($self->datetest($dbdate))
	{
		my $pagetext = '<title> Tracker :: Inbound Loads </title> <header><h1>' . $displaydate .  ' Inbound Loads<br>'  . substr(time2str(str2time($dbdate)),0,3) . '</h1><br>';
		$pagetext = $pagetext . '<form action="/inbound/" method="GET">Open Date (MMDDYY):<input name="date" value="" type="text"><input type="submit"></form><br>';
		$pagetext = $pagetext . '<table border="1">';
		$pagetext = $pagetext . '<tr><td></td><td>Trac#</td><td>Trlr#</td><td>Driver</td><td>Origin</td><td>Destination</td><td>Appt</td><td>Backhaul</td></tr>';
		
		my $inbound_rs = $self->app->schema->resultset('Inbound');
		my $inbound_search = $inbound_rs->search({recdate => $dbdate});
		my $inbound_row;
		while ( $inbound_row = $inbound_search->next || '')
		{
			$pagetext = $pagetext . '<tr><td><a href="' . $self->url_for('/edit/' . $inbound_row->uuid) . '">edit</a></td>';
			$pagetext = $pagetext . '<td>' . $inbound_row->tracnum . '</td>';
			$pagetext = $pagetext . '<td>' . $inbound_row->trlrnum . '</td>';
			$pagetext = $pagetext . '<td>' . $inbound_row->driver . '</td>';
			$pagetext = $pagetext . '<td>' . $inbound_row->origin . '</td>';
			$pagetext = $pagetext . '<td>' . $inbound_row->destination . '</td>';
			my @apptsplit = split(' ',$inbound_row->appt);
			$pagetext = $pagetext . '<td>' . $self->displaydate($apptsplit[0]) . ' ' . substr($apptsplit[1],0,5) . ' ' .substr(time2str(str2time($apptsplit[0])),0,3) . '</td>';
			$pagetext = $pagetext . '<td>' . $inbound_row->backhaul . '</td></tr>';
		}
		$pagetext = $pagetext . '</table><br>';
		$pagetext = $pagetext . '<a href="' . $self->url_for('/newinbound/' . $date) . '">New Load</a><br>';
		$pagetext = $pagetext . '<a href="' . $self->url_for('/outbound/' . $date) . '">Go To Outbound Loads</a><br>';
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
	my @apptsplit = split(' ',$appt);
	$appt = $self->datehandler($apptsplit[0]) . ' '  . $apptsplit[1];
	my $date = $self->param('date');
	my $dbdate = $self->datehandler($date);
	if ($self->datetest($dbdate))
	{
		my $new_haul = $haul_rs->new({
		uuid => $ug->create_str(),
		recdate => $dbdate,
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
	my $dbdate = $self->datehandler($date);
	my $displaydate = $self->displaydate($dbdate);
	if($self->datetest($dbdate))
	{
		my $pagetext = '<title> Tracker :: Outbound Loads </title> <header><h1>' . $displaydate .  ' Outbound Loads<br>'  . substr(time2str(str2time($dbdate)),0,3) . '</h1><br>';
		$pagetext = $pagetext . '<form action="/inbound/" method="GET">Open Date (MMDDYY):<input name="date" value="" type="text"><input type="submit"></form><br>';
		$pagetext = $pagetext . '<table border="1">';
		$pagetext = $pagetext . '<tr><td></td><td>Trac#</td><td>Trlr#</td><td>Driver</td><td>Origin</td><td>Destination</td><td>Appt</td><td>Backhaul</td></tr>';
		
		my $outbound_rs = $self->app->schema->resultset('Outbound');
		my $outbound_search = $outbound_rs->search({recdate => $dbdate});
		my $outbound_row;
		while ( $outbound_row = $outbound_search->next || '')
		{
			$pagetext = $pagetext . '<tr><td><a href="' . $self->url_for('/edit/' . $outbound_row->uuid) . '">edit</a></td>';
			$pagetext = $pagetext . '<td>' . $outbound_row->tracnum . '</td>';
			$pagetext = $pagetext . '<td>' . $outbound_row->trlrnum . '</td>';
			$pagetext = $pagetext . '<td>' . $outbound_row->driver . '</td>';
			$pagetext = $pagetext . '<td>' . $outbound_row->origin . '</td>';
			$pagetext = $pagetext . '<td>' . $outbound_row->destination . '</td>';
			my @apptsplit = split(' ',$outbound_row->appt);
			$pagetext = $pagetext . '<td>' . $self->displaydate($apptsplit[0]) . ' ' . substr($apptsplit[1],0,5) . ' ' .substr(time2str(str2time($apptsplit[0])),0,3) . '</td>';
			$pagetext = $pagetext . '<td>' . $outbound_row->backhaul . '</td></tr>';
		}
		$pagetext = $pagetext . '</table><br>';
		$pagetext = $pagetext . '<a href="' . $self->url_for('/newoutbound/' . $date) . '">New Load</a><br>';
		$pagetext = $pagetext . '<a href="' . $self->url_for('/inbound/' . $date) . '">Go To Inbound Loads</a><br>';
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
		$pagetext = $pagetext . '<tr><td>Date<br />(mmddyy)</td><td>Trac#</td><td>Trlr#</td><td>Driver</td><td>Origin</td><td>Destination</td><td>Appt<br />(mmddyy hh:mm)</td><td>Backhaul</td></tr>';
		$pagetext = $pagetext . '<tr><td><input type="text" name="recdate" maxlength="10" size="10" value="' . $self->displaydate($data_row->recdate) . '"/></td>';
		$pagetext = $pagetext . '<td><input type="text" name="tracnum" maxlength="6" size="6" value="' . $data_row->tracnum . '"/></td>';
		$pagetext = $pagetext . '<td><input type="text" name="trlrnum" maxlength="6" size="6" value="' . $data_row->trlrnum . '"/></td>';
		$pagetext = $pagetext . '<td><input type="text" name="driver" maxlength="30" size="12" value="' . $data_row->driver . '"/></td>';
		$pagetext = $pagetext . '<td><input type="text" name="origin" maxlength="30" size="12" value="' . $data_row->origin . '"/></td>';
		$pagetext = $pagetext . '<td><input type="text" name="destination" maxlength="30" size="12" value="' . $data_row->destination . '"/></td>';
		$pagetext = $pagetext . '<td><input type="text" name="appt" maxlength="20" size="20" value="' . $self->displaydate(substr($data_row->appt,0,10)) . substr($data_row->appt,10,6) . '"/></td>';
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
		my @apptsplit = split(' ',$self->param('appt'));
		$data_row->update(
		{
			'recdate' => $self->datehandler($self->param('recdate')),
			'tracnum' => $self->param('tracnum'),
			'trlrnum' => $self->param('trlrnum'),
			'driver' => $self->param('driver'),
			'origin' => $self->param('origin'),
			'destination' => $self->param('destination'),
			'appt' => $self->datehandler($apptsplit[0]) . ' ' . $apptsplit[1],
			'backhaul' => $self->param('backhaul')
				
		});
	}
	my $direction = $self->param('direction');
	$direction =~ tr/A-Z/a-z/;
	$self->redirect_to('/' . $direction . '/' . $self->param('recdate'));
}



1;