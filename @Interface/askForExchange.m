function [rep, time] = askForExchange(this, othertype, othergood, confirm)
    if nargin < 4;
        confirm = -1;
    end;
    texts = {'Souhaitez-vous échanger votre bien en stock', 'contre celui de l’autre joueur?'};
    textcolor = this.black;
    if confirm > -1
        reponses = {'non', 'oui'};
        texts = {strcat('Vous avez répondu “', reponses{confirm+1}, '”, souhaitez-vous'), 'confirmer votre choix?'};
        textcolor = this.orange;
    end
    Screen('FillRect', this.window, this.white);
    this.drawExchangeQuestion(this.type, this.myGoodColor, othertype, othergood, [], texts, textcolor);
    if this.alreadyLaunched;
        Screen('Flip', this.window);
    end;
    if (~this.useIntervalEverythere);
        [key, time] = this.waitKeyPress(-this.exchangeConfirmTime);
    else [key, time] = this.waitKeyPress(2);
    end;
    %this.alreadyLaunched=1;
    if (~isnan(key))
        this.drawExchangeQuestion(this.type, this.myGoodColor, othertype, othergood, key, texts, textcolor);
        Screen('Flip', this.window);
        this.waitKeyRelease(0.3);
    end
    %if key; this.animExchange(othertype,othergood); else this.resetScreen; end;
    rep = key;
end