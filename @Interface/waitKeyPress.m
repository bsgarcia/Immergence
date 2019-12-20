function [rep time]=waitKeyPress(this,timeout,keys)
            if nargin<3 || isempty(keys)
                keys=[this.leftCode this.rightCode];
            end
            if nargin<2 || isempty(timeout)
                timeout=Inf;
            end

            [time, k] = WaitAnyPress(keys,timeout);

            if isnan(time)
                rep=NaN; time=timeout;
                return;
            end
            for i=1:length(keys)
                if k(keys(i)); rep=i-1; keys2=keys(i); end;
            end

end