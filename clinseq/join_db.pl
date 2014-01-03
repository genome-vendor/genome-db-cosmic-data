#!/usr/bin/perl

use warnings;
use strict;
use File::Basename;
use Data::Dumper;

#my @dirs = qw /cosmic.NCBI-human.ensembl.67_37l_v2.anno.. cosmic.NCBI-human.ensembl.67_37l_v2.anno.filt../;
my $base_path = dirname(__FILE__);

my @dirs;
opendir ( DIR, $base_path ) || die "Error in opening dir $base_path\n";
while((my $filename = readdir(DIR))){
    if ($filename =~ /\w+\.\.$/){
        push(@dirs, $filename);
    }
}
closedir(DIR);

foreach my $dir (@dirs){
    print "\n\nProcessing $dir";
    my $name;
    if ($dir =~ /(.*)\.\.$/){
        $name = $1;
    }else{
        die "\nCould not resolve name for dir: $dir\n";
    }
    my $path = $base_path . "/" . $dir . "/";

    unless (-e $path && -d $path){
        die "\nExpected directory of files to be joined is not valid: $path\n";
    }
    my $joined_file = $base_path . "/" . $name;
    my $join_cmd = "cat $path" . "* > $joined_file";
    print "\nJoining files in $dir\n$join_cmd";
    system($join_cmd);

    my $rm_cmd = "rm -fr $path";
    print "\nRemoving dir after join\n$rm_cmd";
    system($rm_cmd);
}
print "\n\n";

exit;

