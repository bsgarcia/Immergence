function [rep, time] = informInsufficientFunds(this, startWallet, cost, costword, R)
    %informs the subjects about the insufficient funds event
    if nargin < 4;
        R = struct;
    end;
    if length(fieldnames(R)) == 0;
        R.lastRound = 0;
        R.lastGame = 1;
    end; %#ok<ISMT>
    this.resetScreen;
    startSecs = GetSecs();
    informRect = ScaleRect(this.rect, 0.2, 0.7);
    textsize = round(this.fontsize*0.6);
    startWallet = round(startWallet);
    message_line1 = sprintf('Vous avez %u point(s) et le cout de %s est de %u points.', startWallet, costword, cost);
    verb = 'stocker';
    if strcmp(costword, 'production');
        verb = 'produire';
    end;
    if strcmp(costword, 'stockage et production');
        verb = 'produire et stocker';
    end;
    message_line2 = ['Vous n''avez pas sufisamment de points pour ', verb, ' ce bien.'];
    message_line3 = sprintf('La manche n° %u s''arrête à ce round.', this.nGame);
    this.marginText(message_line1, 0.02, 0.2, textsize);
    this.marginText(message_line2, 0.02, 0.25, textsize);
    this.marginText(message_line3, 0.02, 0.32, textsize);
    timenextmess = '';
    if this.useIntervalEverythere;
        timenextmess = sprintf(' dans %u secondes', this.intervalValueIfUsed);
    end;
    message_line4 = ['La manche suivant va commencer', timenextmess];
    if R.lastGame;
        message_line4 = ['Les jeux sont términés. L''écran suivant affichera votre gain', timenextmess];
    end;
    this.marginText(message_line4, 'center', 0.5, round(this.fontsize*0.6));

    this.showPointsLine({' ', this.wallet}, informRect, ScaleRect(this.rect, 1, 0.7), 1);
    Screen('Flip', this.window);

    elapsedSecs = GetSecs() - startSecs;
    time = elapsedSecs;
    rep = '';

    if this.useIntervalEverythere;
        WaitSecs(this.intervalValueIfUsed);
    else
        [rep, time] = this.waitKeyPress(this.intervalValueIfUsed);
    end
end
