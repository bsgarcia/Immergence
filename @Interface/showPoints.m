function [rep, time] = showPoints(this, consumption, stockCost, prodCost, Pl, R)
    %informs the subjects about their points in the current round
    startSecs = GetSecs();
    if nargin < 6;
        R = struct;
    end;
    if nargin < 5;
        Pl = struct;
    end;
    if length(fieldnames(R)) == 0;
        R.lastRound = 0;
        R.lastGame = 0;
    end; %#ok<ISMT>
    if length(fieldnames(Pl)) == 0;
        Pl.insufficientFunds = 0;
    end; %#ok<ISMT>

    cgoodColor = this.myGoodColor;
    this.myGoodColor = this.startGoodColor;

    costword = 'stockage';
    if (prodCost > 0);
        costword = 'production';
    end;
    if (prodCost > 0 && stockCost > 0);
        costword = 'stockage et production';
    end;

    if Pl.insufficientFunds
        cost = stockCost + prodCost;
        [rep, time] = this.informInsufficientFunds(Pl.startWallet, cost, costword, R);
        return
    end

    waitframes = 25; %50
    ifi = Screen('GetFlipInterval', this.window);
    fps = Screen('FrameRate', this.window); % frames per second
    if fps == 0;
        fps = 1 / ifi;
    end;
    mygood = this.myGoodColor;
    if consumption == Pl.utility;
        mygood = this.type;
    end;
    informRect = this.informStock(mygood);
    WaitSecs(0.5);

    total = consumption - stockCost - prodCost;
    informRect = OffsetRect(informRect, -RectWidth(informRect)*0.2, 0);
    this.drawSellerPicture(informRect, mygood);
    %DrawText(this.window,'Vos points','llmtttttttc',0);
    this.marginText('Vos points', 0.045, 0.045);
    vbl = Screen('Flip', this.window, 0, 1);
    %WaitSecs(1);
    newrect = [];
    newrect = this.showPointsLine({'Consommation', consumption}, informRect, newrect);
    vbl = Screen('Flip', this.window, vbl+(waitframes - 0.5)*ifi, 1);
    if (~Player.noStockCost); %stockCost>0
        newrect = this.showPointsLine({'Coût de stockage', -stockCost}, informRect, newrect);
        vbl = Screen('Flip', this.window, vbl+(waitframes - 0.5)*ifi, 1);
    end
    this.myGoodColor = cgoodColor;
    mygood = this.myGoodColor;
    if (strcmp(mygood, Pl.goodProduced(Pl.type)));
        this.drawSellerPicture(informRect, mygood);
    end;
    if (Player.productionCost > 0); %prodCost>0
        newrect = this.showPointsLine({'Production', -prodCost}, informRect, newrect);
        vbl = Screen('Flip', this.window, vbl+(waitframes - 0.5)*ifi, 1);
    end
    WaitSecs(0.5);

    newrect0 = newrect;

    newrect = this.showPointsLine({'Total round', total}, informRect, OffsetRect(newrect, 0, 2+0.1*RectHeight(newrect)));
    %vbl=Screen('Flip',this.window,vbl + (waitframes-0.5)*ifi,1);

    newrect = this.showPointsLine({' ', this.wallet}, informRect, newrect, 1);
    vbl = Screen('Flip', this.window, vbl+(waitframes - 0.5)*ifi, 1);

    startLineV = newrect0(RectBottom) + RectHeight(this.rect) * 0.005;
    endLineV = startLineV;
    step = RectWidth(newrect0) / 40;
    startLineH = newrect0(RectLeft) + 0.05 * RectWidth(newrect0);
    endLineH = startLineH;
    while endLineH < newrect0(RectRight) * 0.95;
        startLineH = endLineH;
        endLineH = startLineH + step;
        Screen('DrawLine', this.window, this.black, startLineH, startLineV, endLineH, endLineV, 2);
        vbl = Screen('Flip', this.window, vbl+(0.5)*ifi, 1);
    end
    if strcmp(mygood(2:end), Pl.perishtype);
        this.drawSellerPicture(informRect, mygood);
        vbl = Screen('Flip', this.window, vbl+(0.5)*ifi, 1);
    end;
    elapsedSecs = GetSecs() - startSecs;
    stillToWait = 3.5 - elapsedSecs;
    if (stillToWait <= 0);
        stillToWait = 0.001;
    end;
    if ~this.waitKeyAtGainInfo;
        WaitSecs(stillToWait);
    end;

    if R.lastRound

        %     message_line4=sprintf('Le jeu n° %u est terminé. Le jeu suivant va commencer.',this.nGame);
        %     if R.lastGame; message_line4='Les jeux sont términés. L''écran suivant affichera votre gain.'; end;
        %     this.marginText(message_line4,'center',0.75,round(this.fontsize*0.6));
        waitNext = this.intervalValueIfUsed; %30
        if this.waitKeyAtGainInfo;
            waitNext = 0.5;
        end;
        this.resetScreen();
        normalTextSize = round(this.fontsize*0.9);
        pointsSize = round(this.fontsize*1.5);
        % if this.wallet<0; pointsSize=round(this.fontsize*1.2); end;
        if ~this.lastGame || this.nGame > 1
            this.marginText(sprintf('Fin de la manche n° %u', this.nGame), 'center', 0.12, normalTextSize);
            endownmRect = this.marginText(sprintf('Total de la manche n° %u', this.nGame), 0.12, 0.45, normalTextSize);
        else
            this.marginText('Fin du jeu', 'center', 0.12, normalTextSize);
            endownmRect = this.marginText('Total des points', 0.12, 0.45, normalTextSize);
        end
        endownmRect = this.adjoinImage(endownmRect, 'wallet');
        endownmRect = this.adjoinText(sprintf(' %d', this.wallet), endownmRect, 'center', this.orange, pointsSize);
        this.adjoinText(' points', endownmRect, 'center', this.black, normalTextSize);
        message_line = sprintf('La manche suivante va débuter dans %u secondes', waitNext);
        if R.lastGame;
            message_line = sprintf('Un questionnaire va apparaître dans %u secondes.', waitNext);
        end;
        if this.waitKeyAtGainInfo;
            message_line = 'Appuyez sur une flèche gauche ou droite pour continuer';
            if (this.spacesAtInfoScreen);
                message_line = 'Appuyez sur la touche espace pour continuer';
            end;
            normalTextSize = round(normalTextSize*0.9);
        end;
        this.marginText(message_line, 'center', 0.8, normalTextSize);
        vbl = Screen('Flip', this.window, vbl+(waitframes - 0.5)*ifi, 1);
        WaitSecs(waitNext);
    end
    vbl = Screen('Flip', this.window, vbl+(waitframes - 0.5)*ifi, 1);

    elapsedSecs = GetSecs() - startSecs;
    time = elapsedSecs;
    rep = '';

    if this.waitKeyAtGainInfo;
        codes = [this.leftCode, this.rightCode];
        if (this.spacesAtInfoScreen);
            codes = this.spaceCode;
        end;
        [rep, time] = this.waitKeyPress(Inf, codes);
        %plus or Round at the "beginning" of the next round:
        this.resetScreen();
        texttoshow = ['Round ', mat2str(this.nRound)];
        if (this.plusInsteadOfRound);
            texttoshow = '+';
        end;
        this.alignText(texttoshow, this.rect, round(this.fontsize*1.7)); %['Round ',mat2str(this.nRound)] or '+'
        if 1;
            Screen('Flip', this.window, 0, 0);
        end; %this.alreadyLaunched
        this.debPlusWaitSec = GetSecs();
    end;
end
