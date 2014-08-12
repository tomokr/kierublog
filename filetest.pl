use File::Temp;
use File::Slurp;
use Path::Class;

my $text;
my $f = File::Temp->new();
close $f;
my $t = file($f->filename)->stat->mtime;
#system $ENV{EDITOR}, $f->filename;
system vim, $f->filename;
if ($t == file($f->filename)->stat->mtime) {
  print STDERR "No changes.";
} else {
  $text = read_file($f->filename); #外部エディタで入力したデータを読み込む
}

print $text;