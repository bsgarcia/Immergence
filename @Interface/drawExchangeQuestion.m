function drawExchangeQuestion(this, firsttype, firstgood, othertype, othergood, choosen, texts, textcolor, showbuttons)
    if nargin < 9;
        showbuttons = 1;
    end;
    if nargin < 8;
        textcolor = this.black;
    end;
    if nargin < 7;
        texts = '';
    end;
    if nargin < 6 || isempty(choosen);
        choosen = '';
    end;
    if ~iscell(texts);
        text = {texts};
    end;
    if this.useHeader;
        this.drawHeader();
    end;
    if this.useBottom;
        this.drawBottom(1);
    end;
    %this.drawBottom(1); %this.drawBottom(1) for simple bottom; %this.drawBottom or this.drawBottom(0) for "hint" bottom;
    this.drawExchangePicture(firsttype, firstgood, othertype, othergood);
    if showbuttons == 1;
        this.drawAskButtons(choosen);
    end;
    if showbuttons == 2;
        this.drawAskButtons(choosen, 0, 1);
    end;
    pos = 'm';
    for i = length(texts):-1:1
        pos = [pos, 't'];
        DrawText(this.window, texts{i}, pos, textcolor);
    end
end