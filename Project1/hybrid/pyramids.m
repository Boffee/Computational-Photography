function pyramids(im12, N)

[h w b] = size(im12);

if b == 1
    im = im2single(im12);
else
    im = im2single(rgb2gray(im12));
end
figure();
for i = 1:N
    [h w b] = size(im);
    fft_h = 2^nextpow2(h);
    fft_w = 2^nextpow2(w);
    
    im_fft = fft2(im, fft_h, fft_w);
    
    % set the cutoff frequency to 50%
    sigma_max = (min(h,w)-1)/6;
    freq_min = min(h, w)/(2*pi*sigma_max);
    freq_max = max(h, w)/(2*pi);
    
    cutoff_freq = (freq_min+freq_max)/2;
    sigma = sqrt(2); %min(h, w)/(2*pi*cutoff_freq);
    
    % gaussian blur filter
    hs = ceil(3*sigma);
    fil = fspecial('gaussian', 2*hs+1, sigma);
%     fil_fft = fft2(fil, fft_h, fft_w);
%     im_low_fft = im_fft.*fil_fft;
%     im_low = ifft2(im_low_fft);
%     im_low = im_low(1+hs:size(im,1)+hs, 1+hs:size(im,2)+hs);
    im_low = imfilter(im, fil, 'replicate');
    im_high = im - im_low;

    im = imresize(im_low, .5);
    subplot(2, N, i);
    imshow(im_low), axis off image, colormap gray;
    subplot(2, N, i+N);
    imagesc(im_high), axis off image, colormap gray;
end
    
