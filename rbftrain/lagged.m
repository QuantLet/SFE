function [tt yt] = lagged(xt,l)

   r = size(xt, 1);
  tt = xt((l + 1):(r), :);

  yt = xt.*ones(size(xt, 1), 1);

   i = 1;
  while(i <= (l-1))
    a  = yt(2:r).*ones(size(yt(2:r),1),1);
    b  = yt(1);
    yt = [a;b];
    xt = [xt,yt];
    i  = i + 1;
  end

  yt = xt(1:(r-l),:);
end