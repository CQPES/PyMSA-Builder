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
`cp msa $pymsa_dir;
chdir $pymsa_dir;

# Python module?
print "Do you want to build Python module? [Y/n] ";
$py_mod = <STDIN>;
chomp $py_mod;
say "Only Fortran codes basis.f90 & gradient.f90 will be generated!" unless $py_mod =~ m/y/i or not $py_mod;

# generate C source code?
print "Do you want to generate C source files? [Y/n] ";
$c_file = <STDIN>;
chomp $c_file;
say "C source files basis.c & gradient.c will be generated!" if $c_file =~ m/y/i or not $c_file;

# cleanup?
print "Clean up after building? [Y/n] ";
$cleanup = <STDIN>;
chomp $cleanup;

# parameters for PIP
print "max degree of PIP: ";
$degree = <STDIN>;
chomp $degree;

print "molecule configuration: ";
$molecule = <STDIN>;
chomp $molecule;

print "range parameter for Morse-like variables (default 2.0d0): ";
$alpha = <STDIN>;
chomp $alpha;

# basis
say "Generating PIP basis...";
`./msa $degree $molecule`;

# Fortran files
say "Generating Fortran files...";
`perl postemsa.pl $degree $molecule`;
`perl derivative.pl $degree $molecule`;
`perl -pi -e "s/real/real\*8/g" *.f90`;
`perl -pi -e "s/a = 2.0d0/a = $alpha/g" gradient.f90` if $alpha;

# Python module
if ($py_mod =~ m/y/i or not $py_mod) {
    $which_f2py = `which f2py`;
    chomp $which_f2py;
    if ($which_f2py) {
        say "Building Python module `msa`...";
        `f2py basis.f90 gradient.f90 -m msa -h msa.pyf --overwrite-signature` or die "Building Error!\n";
        `f2py -c basis.f90 gradient.f90 msa.pyf` or die "Building Error!\n";
        say "Done!";
        say "To test Python module `msa`, run command:";
        say "\$ python3 -c \"from msa import basis, gradient; print(basis.__doc__); print(gradient.__doc__)\"";
        say "Please check the output if any error exists!";
    } else {
        say "`Error: f2py` not found, building failed!" unless $which_f2py;
    }
}

# C files
if ($c_file =~ m/y/i or not $c_file) {
    `perl postemsa_c.pl $degree $molecule`;
}

# cleanup
`rm -rf *pyf MOL*` if $in =~ m/y/i or not $cleanup;

# Done
say "Done!"
