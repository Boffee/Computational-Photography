function patch = choose_sample(patchsize, sample, ssd, k)

hp = patchsize(1);
wp = patchsize(2);

% sample from the 1% lowest ssd
minc = kth_small(ssd(:), k);
[Y, X] = find(ssd<=minc);

i = randi(length(Y));
xs = X(i)+floor(wp/2);
ys = Y(i)+floor(hp/2);

yrange = floor(-(hp-1)/2):floor((hp-1)/2);
xrange = floor(-(wp-1)/2):floor((wp-1)/2);

patch = sample(ys+yrange, xs+xrange, :);
