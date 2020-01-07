function textrect = adjoinText(this, text, rect, position, color, textsize, RectSize)
    if nargin < 7
        RectSize = RectRight;
    end
    if nargin < 6
        textsize = this.fontsize;
    end
    if nargin < 5
        color = this.black;
    end
    if nargin < 4
        position = 'center';
    end
    %textrect=rect; %return;
    oldsize = Screen('TextSize', this.window, textsize);
    [textrect, z] = Screen('TextBounds', this.window, text);
    textrect = AlignRect(textrect, rect, position, position);
    textrect = AdjoinRect(textrect, rect, RectSize);
    if RectSize == RectRight
        textrect = OffsetRect(textrect, RectWidth(this.rect*0.0005), 0);
    elseif RectSize == RectLeft
        textrect = OffsetRect(textrect, -RectWidth(this.rect*0.0005), 0);
    elseif RectSize == RectBottom
        textrect = OffsetRect(textrect, 0, RectWidth(this.rect*0.03));
    end
    [cx, cy] = RectCenter(textrect);
    %Screen('DrawText',this.window, text, textrect(1),textrect(2),color);
    [nx, ny, textbounds] = DrawFormattedText(this.window, text, textrect(1), textrect(4), color);
    % textrect(2) or cy instead of textrect(4)
    %textrect=textbounds;
    %textrect=UnionRect(textrect,textbounds);
    Screen('TextSize', this.window, oldsize);
end