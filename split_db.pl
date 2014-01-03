#!/usr/bin/perl

use warnings;
use strict;
use File::Basename;
use Data::Dumper;

my $base_path = dirname(__FILE__);
my $size_limit = 50000000;
#Find large files to be split
my @files;
opendir ( DIR, $base_path ) || die "Error in opening dir $base_path\n";
while((my $filename = readdir(DIR))){
    my $file = $base_path . "/" . $filename;
    my $filesize = -s $file;    
    if ($filesize > $size_limit){
        push(@files, $filename);
    }
}
closedir(DIR);

unless (scalar(@files)){
  print "\nFound no files large enough (> $size_limit) to split";
}

foreach my $file (@files){
    print "\n\nProcessing $file";
    my $file_path = $base_path . "/" . $file;
    my $name = $file . "..";

    my $split_dir = $base_path . "/" . $name . "/";
    
    if (-e $split_dir && -d $split_dir){
        my $rm_cmd = "rm -fr $split_dir";
        print "\nRemoving existing split dir\n$rm_cmd";
        system($rm_cmd);
    }

    mkdir($split_dir);

    my $cp_cmd = "cp $file_path $split_dir";
    print "\nCopying file to split dir\n$cp_cmd";
    system($cp_cmd);

    my $new_file_path = $split_dir . $file;
    my $split_cmd = "cd $split_dir; split -a 2 -d -l 125000 $file ''";
    print "\nSplitting file\n$split_cmd";
    system($split_cmd);

    my $rm_cmd1 = "rm -f $new_file_path";
    print "\nRemoving temp copy of file\n$rm_cmd1";
    system($rm_cmd1);

    my $rm_cmd2 = "rm -f $file_path";
    print "\nRemoving large file now that split version is created\n$rm_cmd2";
    system($rm_cmd2);
}
print "\n\n";

exit;

