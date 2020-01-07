function distance = drawExchangePicture(this, firsttype, firstgood, othertype, othergood, offset)
    if nargin < 6
        offset = 0;
    end
    stateWidth = RectWidth(this.rect) * 0.65;
    stateHeight = RectHeight(this.rect) * 0.25;
    stateRect = [0, 0, stateWidth, stateHeight];
    stateRect = CenterRect(stateRect, this.rect);
    Screen('FillRect', this.window, this.white, stateRect);
    elemRectWidth = stateWidth / 5;
    elemRect = [0, 0, elemRectWidth, stateHeight];
    elemLeftRect = AlignRect(elemRect, stateRect, 'center', 'left');
    elemRightRect = AlignRect(elemRect, stateRect, 'center', 'right');
    rect1 = this.drawSellerPicture(elemLeftRect, firstgood, firsttype, 0, offset);
    rect2 = this.drawSellerPicture(elemRightRect, othergood, othertype, 1, -offset);
    distance = rect2(1) - rect1(1);
end