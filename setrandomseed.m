function setrandomseed(num)
    %makes random numbers different
    if (nargin < 1);
        num = 1;
    end;
    RandStream.setGlobalStream(RandStream('mt19937ar', 'seed', sum(100*num*clock)));
end
