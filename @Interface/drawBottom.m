function drawBottom(this, simple, onlyothers)
    %this.drawBottom(1) for simple bottom; this.drawBottom or this.drawBottom(0) for "hint" bottom;
    if nargin < 3
        onlyothers = 0;
    end
    if nargin < 2
        simple = 0;
    end
    if this.noHintsInBottom;
        simple = 1;
    end;
    headerRect = ScaleRect(this.rect, 1, this.headerPercent);
    BaseBottomRect = AlignRect(headerRect, this.rect, 'bottom');
    if simple
        Screen('FillRect', this.window, this.gray, BaseBottomRect);
        return;
    end
    scalefactor = 1.3; %if onlyothers; scalefactor=1.6; end;
    tempRect = ScaleRect(this.rect, 1, this.headerPercent*scalefactor);
    bottomRect = AlignRect(tempRect, this.rect, 'bottom');
    if onlyothers;
        bottomRect = OffsetRect(bottomRect, 0, -RectHeight(bottomRect)*0.1);
    end;
    hintRect = InsetRect(bottomRect, RectWidth(bottomRect)*0.05, RectHeight(bottomRect)*0.07);
    hintElemRect = hintRect;
    hintElemRect(3) = RectWidth(bottomRect) * 0.06 + hintElemRect(1);
    hintTextSize = round(this.fontsize*0.6);
    hintSmallTextSize = round(this.fontsize*0.4);
    if ~onlyothers
        Screen('DrawLine', this.window, this.black, bottomRect(1), bottomRect(2), bottomRect(3), bottomRect(2), round(RectWidth(this.rect)*0.002));
        this.drawSellerPicture(hintElemRect, this.type, this.type);
        textElemRect = this.adjoinText(' +', hintElemRect, 'center', this.black, hintTextSize);
        textElemRect = this.adjoinText(sprintf(' %d', this.utility), textElemRect, 'center', this.orange, hintTextSize);
        textElemRect = this.adjoinText(' points', textElemRect, 'center', this.black, hintSmallTextSize);
    else
        textElemRect = hintElemRect;
    end
    textElemRect = OffsetRect(textElemRect, RectWidth(hintRect)*0.23, 0);
    if length(this.possibleColors) > 3;
        textElemRect = OffsetRect(textElemRect, -RectWidth(textElemRect)*(length(this.possibleColors) - 3), 0);
    end;
    for i = 1:length(this.possibleColors)
        ctype = this.possibleColors{i};
        textElemRect(2) = hintRect(2);
        textElemRect(4) = hintRect(4);
        textElemRect(3) = RectWidth(bottomRect) * 0.06 + textElemRect(1);
        this.drawSellerPicture(textElemRect, ctype, 'black');
        textElemRect = this.adjoinText(' -', textElemRect, 'center', this.black, hintTextSize);
        ccost = Player.cost(ctype);
        wordPoints = ' points';
        if ccost < 2;
            wordPoints = ' point';
        end;
        textElemRect = this.adjoinText(sprintf(' %d', ccost), textElemRect, 'center', this.orange, hintTextSize);
        textElemRect = this.adjoinText(wordPoints, textElemRect, 'center', this.black, hintSmallTextSize);
        textElemRect = OffsetRect(textElemRect, RectWidth(hintRect)*0.1, 0);
    end
end