pragma circom 2.1.0;
spec_tags {binary} in{
	0 <= in <= 1
} 

spec_tags {maxbit} in{
	0 <= in <= 2**in.maxbit-1
} 

spec_tags {max} in{
	0 <= in <= in.max
}

spec_tags {max_abs} in{
     -in.max_abs <= in <= in.max_abs
}


spec_tags {maxbit_abs} in{
     - 2**in.maxbit_abs <= in <= 2 ** in.maxbit_abs
}
