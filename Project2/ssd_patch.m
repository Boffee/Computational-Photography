function ssd = ssd_patch(template, sample)
% compute the ssd between template patch from the output image and every
% section of the input image. Inputs are all between 0 and 1
mask = ceil(rgb2gray(template));

[ht, wt, bt] = size(template);
[hs, ws, bs] = size(sample);

ssd = zeros(hs-ht+1, ws-wt+1);

for i = 1:3
    sample_i = sample(:,:,i);
    template_i = template(:,:,i);
    ssd = ssd + filter2(mask, sample_i.^2,'valid')...
        - 2*filter2(template_i, sample_i, 'valid')...
        + sum(sum(template_i.^2));
end

% ssd = imfilter(sample.^2, mask,'conv')...
%     - 2*imfilter(sample, template, 'conv')...
%     + sum(template(:).^2);