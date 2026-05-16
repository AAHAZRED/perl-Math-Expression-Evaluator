use strict;
use warnings;

use Test::More tests => 3;

use Math::Expression::Evaluator;

note('Check fix of issue 125884');

my $expr = '(((sin((abs(-5) * 1.7 * (5 + (2 * 100))) % 5) + -7) * 1 / (20 + 5 + -(4 * abs(-1)))) + (90 * 20) + -100 + (2 ** 2 + 90 ** 2 + (2 * 2 * 90)))';

my $m = Math::Expression::Evaluator->new();

$m->set_function('abs', sub { abs($_[0]) });

my $perl_res = eval $expr;
ok(!$@, 'Perl can evaluate expression');

my $ok = eval {
    $m->parse($expr);
    1;
};

ok($ok, 'parser accepts unary minus before parenthesized expression') or diag($@);

my $mee_res = $m->val();

ok(abs($mee_res - $perl_res) < 1e-9,
   'Math::Expression::Evaluator result matches Perl eval'
  ) or diag("got $mee_res, expected $perl_res");


