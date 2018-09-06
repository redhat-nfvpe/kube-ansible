#!/usr/bin/perl

# Exist if there's no cluster environment variable set.
$clusters =  $ENV{'CLUSTERS'};
if ($clusters < 1) {
  die("Hey, set the $CLUSTERS environment variable, and make it greater than 0");
}

# Initialize a markdown table.
$output = qq!
| Table Number | Primary SSH | -   | Backup SSH |
| ------------ | ----------- | --- | ---------- |
!;

# Cycle through all the clusters.
for (my $i = 1; $i < $clusters+1; $i++) {
  
  # Run the .tmate.sh on each host
  my $command = "/home/centos/.tmate.sh";
  $tmate_ssh_result = runSSHCommand($command,$i);
  # print $tmate_ssh_result."\n";

  # Split up the lines and add to markdown table.
  my @lines = split(/\n/,$tmate_ssh_result);

  $output .= "|".$i."|".$lines[0]."| <--> |".$lines[1]."|\n";
  
}

# print $output;

# Write the results to a file.
# my $outputfile = '/tmp/ssh.markdown';
# open(my $fh, '>', $outputfile) or die "Could not open file '$outputfile' $!";
# print $fh urlencode($output);
# print "Wrote output to $outputfile\n";

# encode it
my $encoded = urlencode($output);
my $curl_command = "curl -H \"Accept: application/json\" -X POST --data \"text=$encoded\" https://markdownshare.com/create/";
# print "curl_command: $curl_command\n";

# Failed github anonymous attempt.
# $curl_command = 'curl --request POST --data {"description":"SSH access for ONS tutorial!","public":"true","files":{"README.md":{"content":"$output"}} https://api.github.com/gists';

$curl_result = `$curl_command`;
print "$curl_result\n";

# Run a command via SSH.
sub runSSHCommand {
  my $command = $_[0];
  my $clusternumber = $_[1];
  my $full_command = getSSHCommand($clusternumber)." '".$command."'";
  # print $full_command."\n";
  return runCommand($full_command);
}

# Handler to create SSH commands.
sub getSSHCommand {
  my $i = $_[0];
  # Get the master & private key
  my $cat_inventory = "cat inventory/multi-cluster/cluster-$i.inventory";
  my $ip = runCommand("$cat_inventory | grep kube-master | head -n1 | cut -d= -f2");
  my $key = runCommand("$cat_inventory | grep private_key | head -n1 | cut -d= -f2");

  # Massage the ssh common args.
  my $ssh_common_args = runCommand("$cat_inventory | grep common_args");
  $ssh_common_args =~ s/^.+'(.+)'$/$1/;
  $ssh_common_args =~ s/ root/ -o LogLevel=ERROR root/;
  
  # Create the ssh command.
  my $ssh_command = "ssh -i $key $ssh_common_args -o StrictHostKeyChecking=no -o LogLevel=ERROR centos\@$ip";
  return $ssh_command;
}

# Run a command.
sub runCommand {
  my $command = $_[0];
  my $result = `$command`;
  $result =~ s/\s+$//;
  return $result;
}

sub urlencode {
    my $s = shift;
    $s =~ s/ /+/g;
    $s =~ s/([^A-Za-z0-9\+-])/sprintf("%%%02X", ord($1))/seg;
    return $s;
}

