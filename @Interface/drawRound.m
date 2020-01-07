function drawRound(this, n, pos)
    if nargin < 3
        pos = 'ttttttttttm';
    end
    if nargin < 2
        n = this.nRound;
    end
    DrawText(this.window, sprintf('Round %d', n), pos, 0);
end