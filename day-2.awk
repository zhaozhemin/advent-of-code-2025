function isInvalid (numstr, _length) {
    _length = length(numstr)

    if (_length % 2 != 0) {
        return 0
    }

    return substr(numstr, 1, _length / 2) == substr(numstr, _length / 2 + 1, _length / 2)
}

# This is brute force, thank god the input file is small. After a bit
# of research, I now know that you could double the string, remove the
# first and the last letter, and check if the original string is
# within. It's much faster.
function isInvalid2 (numstr, _divisor, _groups, _matches, _copy) {
    for (i = 1; i < int(length(numstr) / 2) + 1; i++) {
        if (length(numstr) % i == 0) {
            _divisor[i] = i
        }
    }

    for (d in _divisor) {
        _copy = numstr
        _groups = length(numstr) / d
        _matches = gsub(substr(numstr, 1, d), "&", _copy)

        if (_matches == _groups) {
            return 1
        }
    }

    return 0
}

BEGIN { RS = ","; FS = "-"}
{
    for ( j = $1; j <= $2; j++) {
        if (isInvalid2(j)) {
            sum += j
        }
    }
}
END {
    print sum
}
