function hybrid_ims = hybridImage(im1, im2, cutoff_low, cutoff_high)
% combine the low frequency of im1 with the high frequency of im2
% where im1 and im2 are the same size.

% get size of images
[h1, w1, b1] = size(im1);
[h2, w2, b1] = size(im2);

sigma_low = min(h1, w1)/(2*pi*cutoff_low);
sigma_high = min(h1, w1)/(2*pi*cutoff_high);

hs1 = ceil(3*sigma_low);
hs2 = ceil(3*sigma_high);

% find mininum power of 2 dimensions >= dimesion of image to preserve
% all information
fft_h = nextpow2(h1);
fft_w = nextpow2(w1);


% gaussian filters and their fft
fil_low = fspecial('gaussian', 2*hs1+1, sigma_low);
fil_high = fspecial('gaussian', 2*hs2+1, sigma_high);
fil_low_fft = fft2(fil_low, fft_h, fft_w);
fil_high_fft = fft2(fil_high, fft_h, fft_w);

hybrid_ims = [];
for c = 1:b1
    % get the fft of the images
    im1_fft = fft2(im1(:,:,c), fft_h, fft_w);
    im2_fft = fft2(im2(:,:,c), fft_h, fft_w);

    % filtered fft images
    im1_fil_fft = im1_fft .* fil_low_fft;
    im2_fil_fft = im2_fft .* (1 - fil_high_fft);

    % filtered images
    im1_fil = ifft2(im1_fil_fft);
    im2_fil = ifft2(im2_fil_fft);

    % remove padding
    im1_fil = im1_fil(1+hs1:size(im1,1)+hs1, 1+hs1:size(im1,2)+hs1);
    im2_fil = im2_fil(1+hs2:size(im1,1)+hs2, 1+hs2:size(im1,2)+hs2);

    % combine the low and high frequency images
    hybrid_im_fil = (im1_fil + im2_fil)/2;
    hybrid_ims = cat(3,hybrid_ims, hybrid_im_fil);
end


