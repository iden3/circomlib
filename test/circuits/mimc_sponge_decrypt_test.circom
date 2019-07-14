include "../../circuits/mimcsponge.circom"

template Main() {
	signal input xL_in;
	signal input xR_in;
	signal input k;
	signal output xL_out;
	signal output xR_out;

	component encrypt = MiMCFeistelEncrypt(220);
	component decrypt = MiMCFeistelDecrypt(220);

	encrypt.xL_in <== xL_in;
	encrypt.xR_in <== xR_in;
	encrypt.k <== k;

	decrypt.xL_in <== encrypt.xL_out;
	decrypt.xR_in <== encrypt.xR_out;
	decrypt.k <== k;

	decrypt.xL_out ==> xL_out;
	decrypt.xR_out ==> xR_out;
}

component main = Main();
