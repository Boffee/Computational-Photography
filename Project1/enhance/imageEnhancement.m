clear all;

SHARPEN = 1; % sharpen edge
COLOR_BAL = 0; % color balance 

im = im2single(imread('path.jpg'));
figure(1), imshow(im), title('original');
histshow(im);

% gamma correction
im2 = im.^1.1;
figure(2), imshow(im2), title('gamma correction');
histshow(im2);

% histogram equalization
[hue, sat, val] = rgb2hsv(im2);
h = hist(val(:), 0:1/255:1);
c = cumsum(h);
val2 = c(uint8(val*255)+1)/numel(val);
alpha = 0;
im2 = hsv2rgb(hue, sat, alpha*val+(1-alpha)*val2);
figure(3), imshow(im2), title('gamma correction and histogram equilization');
histshow(im2);

if SHARPEN
    sigma = 2;
    hs = ceil(3*sigma);
    gauss = fspecial('gaussian', 2*hs+1, sigma);
    log = fspecial('log', 2*hs+1, sigma);

    im3 = im2;
    mv = mean(im3(:));

    for c = 1:3
        im_c = im3(:,:,c);

        % color balancing
        if COLOR_BAL
            im_c = im_c * mv/mean(im_c(:));
        end

    %     if c < 3
    %         im_c = im_c * sqrt(mv/mean(im_c(:)));
    %     else
    %         im_c = im_c * nthroot(mv/mean(im_c(:)),5);
    %     end

        % image sharpening by adding 1-gaussian to original image
        im_padded = padarray(im_c, [hs hs], 'replicate', 'both');
        im_blur = conv2(im_padded, gauss, 'valid');
        im_log = conv2(im_blur, log, 'same');
        im_sharp = im_c + im_log; %(3*im_c-im_blur)/2;
        im3(:,:,c) = im_sharp;
    end
    figure(3), imshow(im3), title('sharpen and color balance');
else
    im3 = im2;
end

    
% increase saturation
[hue, sat, val] = rgb2hsv(uint8(im3*255));
im4 = hsv2rgb(hue, sat.^.8, val);
figure(4), imshow(im4), title('increased saturation');

% figure(3)
% [x, y] = ginput(8);
% [hue, sat, val] = rgb2hsv(uint8(im3*255));
% mask = poly2mask(x, y, size(val,1), size(val, 2));
% mask2 = imfilter(im2double(mask), fspecial('gaussian', 151, 25));
% im4 = hsv2rgb(hue, (1-mask2).*sat + mask2.*(sat.^0.7), val2*0.5+val*0.5);
% figure(4), imshow(im4);

% color shift
lab = rgb2lab(im4);
l = lab(:,:,1); a = lab(:,:,2); b = lab(:,:,3);
lab2 = cat(3, l, single((a+128)*1.1-128), b);
more_red =  lab2rgb(lab2);
lab3 = cat(3, l, a, single((b+128)*.9-128));
less_yellow =  lab2rgb(lab3);

figure(5), imshow(more_red), title('more red');
figure(6), imshow(less_yellow), title('less yellow');


