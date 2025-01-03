amp1 = -50;
amp2 = -30;
amp3 = -90:0.1:10;

gain_transducique = 20; % dB
p1dB = 15; % dBm

smo = sqrt(10); % coef de coude
recul_max = 10; % dB

% compression globale de l'ampli liée à la somme de tous les signaux
amplitude_in_total = 10*log10(10.^((amp1)/10) + ...
    10.^((amp2)/10) + ...
    10.^((amp3)/10));
amplitude_out_totale = -smo*log10(10.^(-(amplitude_in_total + gain_transducique)/smo) + ...
    10.^(-(p1dB + sqrt(smo) - 1)/smo));

% recul de chaque signal sur la compression totale
recul_amp1 = amplitude_out_totale - gain_transducique - amp1;
recul_amp2 = amplitude_out_totale - gain_transducique - amp2;
recul_amp3 = amplitude_out_totale - gain_transducique - amp3;

% loi de compression pour chaque signal
loi_de_compression_amp1 = max(0, -smo*log10(10.^(-recul_max/smo) + ...
    10.^(-recul_amp1/smo)));
loi_de_compression_amp2 = max(0, -smo*log10(10.^(-recul_max/smo) + ...
    10.^(-recul_amp2/smo)));
loi_de_compression_amp3 = max(0, -smo*log10(10.^(-recul_max/smo) + ...
    10.^(-recul_amp3/smo)));

% gain non linéaire de chaque signal
gain_non_lin_amp1 = -smo*log10(10.^(-(amplitude_in_total + gain_transducique)/smo) + ...
    10.^(-(p1dB + sqrt(smo) - 1 - loi_de_compression_amp1)/smo)) - amplitude_in_total;
gain_non_lin_amp2 = -smo*log10(10.^(-(amplitude_in_total + gain_transducique)/smo) + ...
    10.^(-(p1dB + sqrt(smo) - 1 - loi_de_compression_amp2)/smo)) - amplitude_in_total;
gain_non_lin_amp3 = -smo*log10(10.^(-(amplitude_in_total + gain_transducique)/smo) + ...
    10.^(-(p1dB + sqrt(smo) - 1 - loi_de_compression_amp3)/smo)) - amplitude_in_total;

% amplitude finale de chaque signal
amplitude_out_non_lin_amp1 = amp1 + gain_non_lin_amp1;
amplitude_out_non_lin_amp2 = amp2 + gain_non_lin_amp2;
amplitude_out_non_lin_amp3 = amp3 + gain_non_lin_amp3;

somme = 10*log10(10.^(amplitude_out_non_lin_amp1/10) + ...
    10.^(amplitude_out_non_lin_amp2/10) + ...
    10.^(amplitude_out_non_lin_amp3/10));

plot(amp3, somme, ...
    amp3, amplitude_out_non_lin_amp1, ...
    amp3, amplitude_out_non_lin_amp2, ...
    amp3, amplitude_out_non_lin_amp3);

% plot(amp3, amplitude_out_totale - amplitude_in_total, ...
%     amp3, gain_non_lin_amp1, ...
%     amp3, gain_non_lin_amp2, ...
%     amp3, gain_non_lin_amp3);

fprintf('max:%.2f dBm\n', max(somme))