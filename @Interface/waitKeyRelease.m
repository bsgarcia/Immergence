function [rep time]=waitKeyRelease(this,timeout,keys)
            if nargin<3 || isempty(keys)
                keys=[this.leftCode this.rightCode];
            end
            if nargin<2 || isempty(timeout)
                timeout=Inf;
            end
            [time, k] = WaitAnyRelease(keys,timeout);
            if isnan(time)
                rep=NaN; time=NaN;
                return;
            end
            for i=1:length(keys)
                if k(keys(i)); rep=i-1; end;
            end
end