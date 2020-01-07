function animExchange(this, othertype, othergood)
    startAnimTime = GetSecs();
    priorityLevel = MaxPriority(this.window);
    Priority(priorityLevel);
    waitframes = 1;
    ifi = Screen('GetFlipInterval', this.window);
    fps = Screen('FrameRate', this.window); % frames per second
    if fps == 0;
        fps = 1 / ifi;
    end;
    initialDistance = this.drawExchangePicture(this.type, this.myGoodColor, othertype, othergood);
    offsetLength = initialDistance / 40;
    distance = 0;
    offset = 0;
    nloop = 0;
    if this.useHeader;
        this.drawHeader();
    end;
    if this.useBottom;
        this.drawBottom();
    end;
    goodChanged = 0;
    textAnswer = 'L’autre joueur souhaite aussi réaliser l’échange';
    textcolor = this.orange;
    drawtextsize = round(this.fontsize*0.9);
    %oldsize=Screen('TextSize', this.window ,drawtextsize);
    %DrawText(this.window,textAnswer,'mt',textcolor);
    this.marginText(textAnswer, 'center', 0.2, drawtextsize, textcolor);
    %Screen('TextSize', this.window , oldsize);
    while initialDistance > -distance
        offset = offset + offsetLength;
        distance = drawExchangePicture(this, this.type, this.myGoodColor, othertype, othergood, offset);
        if initialDistance / 2 < -distance && ~goodChanged
            %this.drawHeader(othergood); this.drawBottom; drawExchangePicture(this,this.type,this.myGoodColor,othertype,othergood,offset); DrawText(this.window,textAnswer,'mt',textcolor);
            vbl = Screen('Flip', this.window);
            if this.useHeader;
                this.drawHeader(othergood);
            end;
            offset = offset + offsetLength;
            drawExchangePicture(this, this.type, this.myGoodColor, othertype, othergood, offset);
            if this.useBottom;
                this.drawBottom;
            end;
            %oldsize=Screen('TextSize', this.window ,drawtextsize);
            %DrawText(this.window,textAnswer,'mt',textcolor);
            this.marginText(textAnswer, 'center', 0.2, drawtextsize, textcolor);
            %Screen('TextSize', this.window , oldsize);
            goodChanged = 1;
            %Screen('Flip', this.window);
        end
        Screen('DrawingFinished', this.window, 1);
        vbl = Screen('Flip', this.window, 0, 1);
        %if nloop>0; vbl=Screen('Flip', this.window, vbl + (waitframes-0.5)*ifi,1); end;
        %if nloop==0; vbl=Screen('Flip', this.window,0,1); end;
        %nloop=nloop+1;
    end
    WaitSecs(0.1);
    %this.myGoodColor=othergood; Problems when launched from Player's class
    elapsedAnimTime = GetSecs() - startAnimTime;
    this.currentMeasureTime = elapsedAnimTime;
end
