function histshow(im)

im_g = rgb2gray(im);
h = hist(im_g(:), 0:1/255:1);
figure(), hold off, plot(h, 'k');
hold on;
col = ['r', 'g', 'b'];
for c = 1:3
    im_c = im(:,:,c);
    h_c = hist(im_c(:), 0:1/255:1);
    plot(h_c, col(c));
end
hold off;
