function quilt = quilt_simple(sample, outsize, patchsize, overlap, k)
% Generate a quilt of size OUTSIZE by sampling patches of PATHSIZE from
% SAMPLE and concatenating the sample patches with specified OVERLAP. 
%
% Sample patches are chosen randomly from the k smallest ssd between the
% overlapping region in the quilt and the sample patch.

% output quilt size
ho = uint32(outsize(1));
wo = uint32(outsize(2));

% patch size 
hp = uint32(patchsize(1));
wp = uint32(patchsize(2));

% sample image size
[hs, ws, bs] = size(sample);

% number of patches to sample in each direction to produce output image.
% subtract overlap from output size because first patch does not overlap.
m_patches = floor((ho-overlap)/(hp-overlap));
n_patches = floor((wo-overlap)/(wp-overlap));

% range of patch without offset
y_range = 1:hp;
x_range = 1:wp;

quilt = single(zeros(ho, wo, bs));

for m = 1:m_patches
    for n = 1:n_patches
        % offset the start position of each patch by the width of the 
        % non-overlapping section of the patch when adding new patches.
        t_y_range = y_range+(m-1)*(hp-overlap);
        t_x_range = x_range+(n-1)*(wp-overlap);
        
        % randomly sample the patches from the sample that has the k
        % smallest ssd with the overlapping region in the quilt
        template = quilt(t_y_range, t_x_range, :);
        ssd = ssd_patch(template, sample);
        patch = choose_sample(patchsize, sample, ssd, k);
        quilt(t_y_range, t_x_range, :) = patch;
    end
end
        