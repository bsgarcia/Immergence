function [gamePayed, gain, proba, gainEurSup, totalGain, key, time] = infoGains(this, nowait)
    if nargin < 2;
        nowait = 0;
        key = -1;
        time = -1;
    end;
    if nowait == 1;
        key = -1;
        time = -1;
    end;
    %waiting screen:
    if ~nowait;
        [key, time] = this.waitPaperQuestionnaire(600);
    end;
    %gain info:
    this.resetScreen;
    rH = RectHeight(this.rect) * .4;
    rW = rH * 0.4;
    bhRect = [0, 0, rW, rH];
    bhRect = OffsetRect(bhRect, rW*0.4, rH*0.7);
    eval(strcat('bh=this.Images.bh', this.type, ';'));
    load gameRealWallets;
    tirage(this, gameRealWallets, bh, bhRect, 1);
    vbl = Screen('Flip', this.window, 0, 1);
    WaitSecs(2);
    maxNLoop = 40;
    nloop = 0;
    while nloop < maxNLoop
        [gamePayed, gain] = tirage(this, gameRealWallets, bh, bhRect, 0);
        nloop = nloop + 1;
        WaitSecs(0.01);
    end
    %vbl=Screen('Flip', this.window,0,2);
    this.marginText(['Le jeu n° ', mat2str(gamePayed), ' a été tiré au sort pour déterminer votre paiement'], 'center', 0.95, round(this.fontsize*0.5));
    this.marginText(['Votre gain est donc égal à ', mat2str(gain), ' points'], 'center', 0.97, round(this.fontsize*0.5));
    vbl = Screen('Flip', this.window, 0, 1);
    %Next Screen:
    WaitSecs(1);
    this.waitKeyPress(7);
    %WaitSecs(7);
    this.resetScreen;
    pointsPerChance = 4; %9;%4;
    gainSupToWin = 10;
    gainFixe = 10;
    proba = (gain - 100) / pointsPerChance;
    if (proba < 0);
        proba = 0;
    end;
    if (proba > 100);
        proba = 100;
    end;
    textRect = this.marginText(['Vos ', mat2str(gain), ' points se transforment en ', mat2str(proba), ' % de chance de gagner ', mat2str(gainSupToWin), ' euros supplémentaires'], 'center', 0.21, round(this.fontsize*0.5));
    rightTextRect = textRect;
    rightTextRect(RectLeft) = textRect(RectRight) - 0.262 * RectWidth(this.rect);
    bottomTextMargins = [0.4, 0.45];
    if proba > 0 && proba < 100
        wincolor = [this.cyan, 100]; %255= full opacity, 0= full transparency
        Screen('FillRect', this.window, wincolor, rightTextRect);
        vbl = Screen('Flip', this.window, 0, 1);
        tirageEUR(this, proba, wincolor, 1);
        WaitSecs(3);
        maxNLoop = 60;
        nloop = 0;
        while nloop < maxNLoop
            result = tirageEUR(this, proba, wincolor);
            nloop = nloop + 1;
            WaitSecs(0.02);
        end
        bottomTextMargins = [0.7, 0.75];
    elseif proba == 100
        result = 1;
    else
        result = 0;
    end
    gainEurSup = result * gainSupToWin;
    totalGain = gainFixe + gainEurSup;
    textwin = 'Vous n''avez pas gagné';
    if result;
        textwin = 'Vous avez gagné';
    end;
    textwin = [textwin, ' les ', mat2str(gainSupToWin), ' euros supplémentaires.'];
    this.marginText(textwin, 'center', bottomTextMargins(1), round(this.fontsize*0.6));
    this.marginText(['Votre gain total est donc égal à ', mat2str(totalGain), ' euros.'], 'center', bottomTextMargins(2), round(this.fontsize*0.6));
    Screen('Flip', this.window, 0, 1);
    WaitSecs(2);
end
function [gamePayed, gain] = tirage(this, gameRealWallets, bh, bhRect, nopay)
    Screen('Flip', this.window);
    %headerRect=ScaleRect(this.rect,1,this.headerPercent);
    %Screen('FillRect',this.window,this.gray,headerRect);
    %this.drawBottom(1);
    Screen('DrawTexture', this.window, bh, [], bhRect);
    rect2 = [];
    nGamesTotal = length(gameRealWallets);
    randomVec = randperm(nGamesTotal);
    gamePayed = randomVec(1);
    if nopay;
        gamePayed = 0;
    end;
    for i = 1:nGamesTotal
        rect2 = this.showPointsLine({['Jeu n° ', mat2str(i)], gameRealWallets(i)}, bhRect, rect2, 0, 'wallet');
        rect2in = InsetRect(rect2, RectWidth(rect2)*0.01, 0);
        if i == gamePayed && ~nopay;
            Screen('FrameRect', this.window, this.black, rect2in);
        end;
    end
    if ~nopay;
        gain = gameRealWallets(gamePayed);
    end;
    this.marginText(['Ci-dessous le récapitulatif de vos gains dans les ', mat2str(nGamesTotal), ' jeux :'], 'center', 0.21, round(this.fontsize*0.7));
end

function result = tirageEUR(this, proba, wincolor, noline)
    if nargin < 4;
        noline = 0;
    end;
    rectsize = RectWidth(this.rect) * 0.2;
    ballrect = [0, 0, rectsize, rectsize];
    ballrect = CenterRect(ballrect, this.rect);
    arcangle = proba * 360 / 100;
    if noline
        startangle = 0;
    else
        startangle = rand(1) * 360;
    end
    Screen('FillRect', this.window, this.white, ballrect);
    Screen('FillArc', this.window, wincolor, ballrect, startangle, arcangle);
    Screen('FrameArc', this.window, this.black, ballrect, 0, 360, 2);
    if ~noline;
        Screen('DrawLine', this.window, [255, 0, 0], (ballrect(1) + ballrect(3))/2, (ballrect(2) + ballrect(4))/2, (ballrect(1) + ballrect(3))/2, ballrect(2)-RectHeight(ballrect)*0.1, 2);
    end;
    Screen('Flip', this.window, 0, 1);
    if startangle == 0 || startangle + arcangle >= 360;
        result = 1;
    else result = 0;
    end;
end
