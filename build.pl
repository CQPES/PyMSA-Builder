#!/usr/bin/env perl
use feature qw(say);

$pymsa_dir = `pwd`;
chomp $pymsa_dir;

# repo
$dependence = "MSA-2.0";
$url = "https://github.com/mizu-bai/MSA-2.0.git";

# clone repo MSA-2.0
if (-d $dependence) {
    say "MSA-2.0 already exists!";
} else {
    `git clone $url`;
}

# build msa
say "Building excutable `msa`...";
chdir "$dependence/src/emsa";
`make clean && make all`;
say "Done!";

# copy files
`cp msa $pymsa_dir && cp ../*.pl $pymsa_dir `;
chdir $pymsa_dir;

# input max degree of PIP and molecule configuration
print "Do you want to build Python module with max degree of PIP and molecule configuration? [Y/n] ";
$in = <STDIN>;
chomp $in;
die "Goodbye!\n" unless $in =~ m/y/i or not $in;

$which_f2py = `which f2py`;
chomp $which_f2py;

die "`Error: f2py` not found, building failed!\n" unless $which_f2py;

print "Clean up after building? [Y/n] ";
$in = <STDIN>;
chomp($in);

print "max degree of PIP: ";
$degree = <STDIN>;
chomp $degree;

print "molecule configuration: ";
$molecule = <STDIN>;
chomp $molecule;

say "Generating PIP basis...";
`./msa $degree $molecule`;

say "Generating Fortran files...";
`perl postemsa.pl $degree $molecule`;
`perl derivative.pl $degree $molecule`;
`gsed -i 's/real/real*8/g' *.f90`;

say "Building Python module `msa`...";
`f2py basis.f90 gradient.f90 -m msa -h msa.pyf --overwrite-signature`;
`f2py -c basis.f90 gradient.f90 msa.pyf`;

say "Done!";
say "Testing... Running command `from msa import basis, gradient; print(basis.__doc__); print(gradient.__doc__)`";
say `python -c "from msa import basis, gradient; print(basis.__doc__); print(gradient.__doc__)"`;
say "Please check the output if any error exists!";

`rm -rf *f90 *pyf MOL*` if $in =~ m/y/i or not $in;
