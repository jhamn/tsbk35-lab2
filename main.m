clear;

fileName = "heyhey.wav";
[y, fs] = audioread(fileName);

blocksize = 512;
n_steps = 24;

ymin = min(y);
ymax = max(y);

stepsize = (ymax-ymin) / n_steps;

y_transformed = mdct(y, blocksize);

y_quantized = y_transformed/stepsize;
y_quantized = round(y_quantized);

y_hist = hist(y_quantized(:), min(y_quantized(:)):max(y_quantized(:)));
p = y_hist/sum(y_hist);

R = huffman(p);
yhat = imdct(y_quantized*stepsize);
diff = y - yhat;
D = mean(diff.^2);
SNR = 10*log10(var(y)/D);

fprintf('block size:    %i\n', blocksize)
fprintf('step size:     %f\n', stepsize)
fprintf('nr of steps:   %i\n', n_steps)
fprintf('R:             %f\n', R)
fprintf('D:             %e\n', D)
fprintf('SNR:           %f\n', SNR)

%sound(yhat,fs)