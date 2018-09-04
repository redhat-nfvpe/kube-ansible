#!/usr/bin/perl

# [centos@kube-master-1 .ssh]$ tmate -S /tmp/tmate.sock new-session -d
# [centos@kube-master-1 .ssh]$ tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}'

$clusters =  $ENV{'CLUSTERS'};

if ($clusters < 1) {
  die("Hey, set the $CLUSTERS environment variable, and make it greater than 0");
}

# Cycle through all the clusters.
for (my $i = 1; $i < $clusters+1; $i++) {
  
  my $ssh_command = getSSHCommand($i);
  print $ssh_command."\n";
  
}

sub runSSHCommand {
  my $command = $_[0];
  my $server = $_[1];
  return runCommand(getSSHCommand())
}

sub getSSHCommand {
  my $i = $_[0];
  my $cat_inventory = "cat inventory/multi-cluster/cluster-$i.inventory";
  my $ip = runCommand("$cat_inventory | grep kube-master | head -n1 | cut -d= -f2");
  # print $ip."<---\n";
  my $key = runCommand("$cat_inventory | grep private_key | head -n1 | cut -d= -f2");
  # print $key."<---\n";
  my $ssh_common_args = runCommand("$cat_inventory | grep common_args");
  $ssh_common_args =~ s/^.+'(.+)'$/$1/;
  # print $ssh_common_args."<---\n";
  my $ssh_command = "ssh -i $key $ssh_common_args centos\@$ip";
  return $ssh_command;
}

sub runCommand {
  my $command = $_[0];
  my $result = `$command`;
  $result =~ s/\s+$//;
  return $result;
}

