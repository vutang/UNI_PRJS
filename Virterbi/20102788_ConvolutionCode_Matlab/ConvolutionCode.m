N = 10000;

eb_no = [1:1:10];
le = length(eb_no);

input_bits = rand(1,N);
	input_bits(input_bits >= 0.5) = 1;
	input_bits(input_bits < 0.5) = 0;
input_bits;

G1 = 7;
G2 = 5;
trellis = poly2trellis(3, [G1 G2]);
tblen = 15;

%encode input bits stream by Convolution code
encoded_bits = convenc([input_bits 0 0], trellis);

%chanel coding use Poli NRZ
chanel_bits = encoded_bits;
	chanel_bits(chanel_bits >= 1) = 1;
	chanel_bits(chanel_bits <= 0) = -1;
chanel_bits;

ltx = length(chanel_bits);

%mesure no - noise index
eb_no;
es_no = eb_no + 10*log10(1/2);
no = 1./(10.^(es_no./10));

for i = 1:le
	i;
	
	%add AWGN noise in chanel
	%no(i);
	noise = sqrt(no(i) * 0.5) * randn(1,ltx);
	received_bit = chanel_bits + noise(1:ltx);

		%convert from chanel coding bits to digital signal
		received_bit(received_bit<=0) = 0;
		received_bit(received_bit >0) = 1;

	decoded_bits = vitdec(received_bit,trellis,tblen,'term','hard');

	check_err = [input_bits 0 0] - decoded_bits;
	ber(:,i) = sum(abs(check_err))/N;
end 

figure(1)
semilogy(eb_no, ber, 'r^-','linewidth',2);
xlabel('eb/no');
ylabel('BER - Bit Error Rate');
%legend('uncoded bpsk');
%legend('code rate = 1/2 or 1/3, m = 2 or 6, hard or soft decision(standard or tested)');
grid