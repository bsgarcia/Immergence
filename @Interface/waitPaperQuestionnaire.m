function [key, time] = waitPaperQuestionnaire(this, nSeconds)
    this.resetScreen;
    this.marginText('Les jeux sont termin�s.', 'center', 0.4, round(this.fontsize*0.8));
    %this.marginText('Veuillez maintenant r�pondre au questionnaire papier.','center',0.5,round(this.fontsize*0.8));
    this.marginText('Veuillez r�pondre � un questionnaire.', 'center', 0.5, round(this.fontsize*0.8));
    %Screen('Flip',this.window);
    %WaitSecs(nSeconds);
    %WaitSecs(3);
    Screen('Close', this.window);
    for h = 1:50;
        display('Veuillez patienter...');
        display(' ');
    end;
    dos('questionnaire.exe');
    this.initializeWindow;
    this.resetScreen;
    %this.marginText('Si vous avez termin� de r�pondre au questionnaire papier,',0.1,0.4,round(this.fontsize*0.7));
    %this.marginText('Merci!',0.08,0.4,round(this.fontsize*0.7));
    %this.marginText('L''�cran suivant va afficher vos gains',0.08,0.5,round(this.fontsize*0.7));
    this.marginText('L''�cran suivant va afficher vos gains', 'center', 'center', round(this.fontsize*0.7));
    %this.marginText('pour connaitre vos gains',0.08,0.6,round(this.fontsize*0.7));
    %this.drawAskButtons('',1);
    %Screen('Flip',this.window);
    WaitSecs(1);
    [key, time] = this.waitKeyPress(2.5);
end
