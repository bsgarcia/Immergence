function drawHeader(this, goodColor)
    headerColor = this.gray;
    headerRect = ScaleRect(this.rect, 1, this.headerPercent);
    Screen('FillRect', this.window, headerColor, headerRect);
    walletImageRect = [headerRect(3) * 0.7, headerRect(4) * 0.05, headerRect(3) * 0.78, headerRect(4) * 0.95];
    walletRect = this.adjoinText(sprintf(' %d', this.wallet), walletImageRect, 'center', this.orange);
    this.adjoinText(' points', walletRect, 'center', this.black, round(this.fontsize*0.5));
    Screen('DrawTexture', this.window, this.Images.wallet, [], walletImageRect);
    this.drawRound();
    bhRect = [headerRect(3) * 0.05, headerRect(4) * 0.05, headerRect(3) * 0.1, headerRect(4) * 0.95];
    if nargin < 2 || isempty(goodColor);
        goodColor = this.myGoodColor;
    end;
    this.drawSellerPicture(bhRect, goodColor);
end