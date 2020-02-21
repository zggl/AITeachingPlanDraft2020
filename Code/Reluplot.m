height = 12;
width = 12;
channels = 32;
observations = 1;
X = randn(height,observations);
dlX = dlarray(X);
dlY = leakyrelu(dlX,0.05);
subplot(2,2,1)
plot(double(dlX),double(dlY))