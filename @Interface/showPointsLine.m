function lineRect = showPointsLine(this, txtcell, rect1, rect2, bottom, imageorsign)
    %show lines for point information; txtcell should be a cell of 2 elements
    if nargin < 6;
        imageorsign = 'sign';
    end;
    if nargin < 5;
        bottom = 0;
    end;
    if nargin < 4;
        rect2 = [];
    end;
    leftMargin = 0.05;
    rightMargin = 0.05;
    lineFontsize = round(this.fontsize*0.7);
    distanceToRight = this.rect(3) - rect1(3);
    distanceToBottom = this.rect(4) - rect1(4);
    if isempty(rect2)
        top = rect1(RectTop) + RectHeight(rect1) * 0.2;
        rect2 = [0, top, distanceToRight, top + 1];
        rect2 = AdjoinRect(rect2, rect1, RectRight);
    end
    lineRect = OffsetRect(rect2, 0, RectHeight(rect2));
    nPoints = txtcell{2};
    sign = '+';
    if nPoints < 0;
        sign = '-';
    end;
    if ~bottom && strcmp(imageorsign, 'sign');
        nPoints = abs(nPoints);
    end;
    nPoints = mat2str(nPoints);
    %sighRect=Screen('TextBounds',this.window,sign);
    marginrect = [0, 0, 1, 1];
    if bottom
        lineRect = OffsetRect(rect1, distanceToRight*0.95, distanceToBottom);
    end
    leftMarginRect = ScaleRect(marginrect, leftMargin*RectWidth(lineRect), RectHeight(lineRect));
    rightMarginRect = ScaleRect(marginrect, rightMargin*RectWidth(lineRect), RectHeight(lineRect));
    leftMarginRect = CenterRect(leftMarginRect, lineRect);
    rightMarginRect = CenterRect(rightMarginRect, lineRect);
    leftMarginRect = AlignRect(leftMarginRect, lineRect, 'left');
    rightMarginRect = AlignRect(leftMarginRect, lineRect, 'right');
    leftTextRect = this.adjoinText(txtcell{1}, leftMarginRect, 'center', this.black, lineFontsize, RectRight);
    rightTextRect = this.adjoinText(' point(s)', rightMarginRect, 'center', this.black, round(lineFontsize*0.8), RectLeft);
    pointTextRect = this.adjoinText(nPoints, rightTextRect, 'center', this.orange, round(lineFontsize*2.2), RectLeft);
    lineRect(2) = pointTextRect(2);
    lineRectH = max([RectHeight(pointTextRect), RectHeight(leftTextRect), RectHeight(rightTextRect)]) * 1.2; %*1
    lineRect(4) = lineRect(2) + lineRectH;
    signImage = this.Images.wallet;
    if ~isempty(imageorsign) && ~strcmp(imageorsign, 'sign');
        eval(['signImage=this.Images.', imageorsign, ';']);
    end;
    if ~strcmp(imageorsign, 'sign');
        bottom = 1;
    end;
    if bottom;
        marginrect = ScaleRect(marginrect, lineRectH, lineRectH);
    end;
    offsetTopSign = 0.04;
    if sign == '-';
        offsetTopSign = 0.2;
    end; %0
    signRect = CenterRect(marginrect, lineRect);
    signRect = OffsetRect(signRect, 0.03*RectWidth(lineRect), offsetTopSign*RectHeight(lineRect));
    if ~bottom
        this.adjoinText(sign, signRect, 'center', this.black, round(lineFontsize*1.7), RectRight);
    else
        signRect = OffsetRect(signRect, -1.8*RectWidth(lineRect), 0);
        Screen('DrawTexture', this.window, signImage, [], signRect);
        %signRect
        %this.rect
    end
end
