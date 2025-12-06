use strict;
use warnings;
use List::Util 'reduce';

sub read_input {
    open(my $f, '<', "./day-6-input");
    my @table = ();

    while (my $line = <$f>){
        chomp($line);
        my @tokens = split(' ', $line);
        push(@table, \@tokens);
    }

    close $f;

    return @table;
}

sub solve2 {
    open(my $f, '<', "./day-6-input");
    my @lines = <$f>;
    close $f;
    my $operator_string = $lines[$#lines];
    chomp $operator_string;
    my @column_start = ();
    my @operators = split(' ', $operator_string);

    for (my $i = 0; $i < length($operator_string); $i++) {
        if (substr($operator_string, $i, 1) ne " ") {
            push @column_start, $i;
        }
    }

    my @columns = ();
    my @true_columns = ();

    for my $i (0..$#column_start) {
        my @col = ();
        my @true_col = ();
        push @columns, \@col;
        push @true_columns, \@true_col;
    }

    for my $i (0..$#lines - 1) {
        my $ln = $lines[$i];
        chomp $ln;

        for my $j (0..$#column_start) {
            my $start = $column_start[$j];
            my $num;


            if ($j == $#column_start) {
                $num = substr($ln, $start);
            } else {
                my $end = $column_start[$j + 1] - $column_start[$j] - 1;
                $num = substr($ln, $start, $end);
            }

            my $length = length($num);

            push @{$columns[$j]}, $num;
        }

    }

    for my $i (0..$#columns) {
        my @col = @{$columns[$i]};
        my $len = length($col[0]);

        while ($len > 0) {
            my $num = '';

            foreach my $j (@col) {
                $num = $num . substr($j, -1, 1);
                substr($j, -1, 1) = "";
            }

            push @{$true_columns[$i]}, $num;
            $len -= 1;
        }
    }

    my $total = 0;

    for my $i (0..$#true_columns) {
        my $op = @operators[$i];
        my @col = @{$true_columns[$i]};
        $total += op_arr($op, @col);
    }

    print "total: $total \n"
}

sub op_arr {
    my ($op, @arr) = @_;

    if ($op eq "+") {
        return reduce {$a + $b} @arr;
    } elsif ($op eq "*") {
        return reduce {$a * $b} @arr;
    }
}


sub solve1 {
    my @table = read_input();
    my $op_row_ref = $table[$#table];
    my $total = 0;

    for my $i (0..$#$op_row_ref) {
        my $col_total = $table[0]->[$i];
        my $op = $op_row_ref->[$i];

        for my $j (1..$#table - 1) {
            my $el = $table[$j]->[$i];
            if ($op eq "+") {
                $col_total += $el;
            } elsif ($op eq "*") {
                $col_total = $col_total * $el;
            }
        }

        $total += $col_total;
    }

    print "total: $total \n";
}

solve1();
solve2();
