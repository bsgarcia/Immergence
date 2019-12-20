function [gamePayed tenPercInfo proba gainEurSup hlgain totalGain key time]=infoGains2(this,nowait,R)
            if nargin<2; nowait=0; key=-1; time=-1; end;
            if nowait==1; key=-1; time=-1; end;
            %waiting screen:
            if ~nowait; [key time]=this.waitPaperQuestionnaire(600); end;
            %gain info:
            use10perc=this.useTenPercGain;
            this.resetScreen;
            rH=RectHeight(this.rect)*.4; rW=rH*0.4; bhRect=[0 0 rW rH]; 
            bhRect=OffsetRect(bhRect,rW*0.4,rH*0.7);
            eval(strcat('bh=this.Images.bh',this.type,';'));
            load gameRealWallets;
            tirage(this,gameRealWallets,bh,bhRect,1);
            vbl=Screen('Flip',this.window,0,1);
            % WaitSecs(2);
            maxNLoop=1; nloop=0;
            tenPerc=0.1;
            tenPercPer=round(R.nRound*tenPerc);
            rndStartRound=1+floor(rand()*(R.nRound-tenPercPer)); rndEndRound=rndStartRound+tenPercPer;
            gain10Perc=0;
            if use10perc;
                gain10Perc=gameRealWallets(rndEndRound)-gameRealWallets(rndStartRound);
            end;
            display(rndStartRound); display(rndEndRound); display(gain10Perc); display(gameRealWallets(rndStartRound)); display(gameRealWallets(rndEndRound));
            while nloop<maxNLoop
                [gamePayed gain]=tirage(this,gameRealWallets,bh,bhRect,0,gain10Perc,tenPercPer);
                nloop=nloop+1;
                WaitSecs(0.01);
            end
            %vbl=Screen('Flip', this.window,0,2);
            % this.marginText(['Le jeu n° ' mat2str(gamePayed) ' a été tiré au sort pour déterminer votre paiement'],'center',0.95,round(this.fontsize*0.5));
            % this.marginText(['Votre gain est donc égal à ' mat2str(gain) ' points'],'center',0.97,round(this.fontsize*0.5));
            if use10perc;
                this.marginText(['Les manches de ' mat2str(rndStartRound) ' à ' mat2str(rndEndRound) ' ont été tirées au hasard par l''ordinateur'],'center',0.70,round(this.fontsize*0.6)); %0.93
                endownmRect=this.marginText(['Vous avez gagné '],0.15,0.75,round(this.fontsize*0.6));
                endownmRect=this.adjoinImage(endownmRect,'wallet');
                this.adjoinText([mat2str(gain10Perc) ' points lors de ces ' mat2str(tenPercPer) ' manches.'],endownmRect, 'center',this.black,round(this.fontsize*0.6)); %0.93
            else
                this.marginText(['Votre gain est égal à ' mat2str(gain) ' points'],'center',0.80,round(this.fontsize*0.5)); %0.93
            end
			datafilename='lastGameData';
            load(datafilename);
            eval(['ldata=' datafilename ';']);
            lds=ldata(ldata.Session==R.session,:);
            compGain=lds.wallet(lds.realNumber==R.Players(1).realNumber & lds.nRound==R.nRound & lds.nGame==R.nGame);
            compGain10Perc=lds.wallet(lds.realNumber==R.Players(1).realNumber & lds.nRound==rndEndRound & lds.nGame==R.nGame)-lds.wallet(lds.realNumber==R.Players(1).realNumber & lds.nRound==rndStartRound & lds.nGame==R.nGame);
            if use10perc;
                this.marginText(['Avec les mêmes tirages aléatoires, l''ordinateur aurait gagné '],0.11,0.80,round(this.fontsize*0.6)); %0.95
                endownmRect=this.marginText([' '],0.25,0.85,round(this.fontsize*0.6)); %0.95
                endownmRect=this.adjoinImage(endownmRect,'wallet');
                this.adjoinText([ mat2str(compGain10Perc) ' points lors de ces ' mat2str(tenPercPer) ' manches.'], endownmRect, 'center',this.black,round(this.fontsize*0.6)); %0.95
            else
                this.marginText(['Avec les mêmes tirages aléatoires, l''ordinateur aurait gagné ' mat2str(compGain) ' points'],'center',0.85,round(this.fontsize*0.5)); %0.95
            end
			proba=0;
            usedGain=0;
            if use10perc;
                usedGain=gain10Perc;
                if(gain10Perc<compGain10Perc); proba=100*gain10Perc/compGain10Perc; end;
                if(compGain10Perc<0 && gain10Perc<0); proba=100*compGain10Perc/gain10Perc; end;
                if(proba<0); proba=0; end;
                if(proba>100); proba=100; end;
                if(gain10Perc>=compGain10Perc); proba=100; end;

            else
                usedGain=gain;
                if(gain<compGain); proba=100*gain/compGain; end;
                if(compGain<0 && gain<0); proba=100*compGain/gain; end;
                if(proba<0); proba=0; end;
                if(proba>100); proba=100; end;
                if(gain>=compGain); proba=100; end;
            end
            gainSupToWin=10;
            gainFixe=10;
            probatch=round(proba*10)/10;
			this.marginText(['Vos ' mat2str(usedGain) ' points se transforment donc en ' mat2str(probatch) ' % de chance de gagner ' mat2str(gainSupToWin) ' euros supplémentaires'],'center',0.90,round(this.fontsize*0.5)); %0.97
            vbl=Screen('Flip',this.window,0,1);
            %Next Screen:
            WaitSecs(1);
            codes=[this.leftCode this.rightCode];
            if(this.spacesAtInfoScreen); codes=this.spaceCode; end;
            this.waitKeyPress(45,codes);
            %WaitSecs(7);
            this.resetScreen;
            textRect=this.marginText(['Vos ' mat2str(usedGain) ' points se transforment en ' mat2str(probatch) ' % de chance de gagner ' mat2str(gainSupToWin) ' euros supplémentaires'],'center',0.21,round(this.fontsize*0.5));
            rightTextRect=textRect; rightTextRect(RectLeft)=textRect(RectRight)-0.262*RectWidth(this.rect);
            bottomTextMargins=[0.4 0.45 0.5];
            if proba>0 && proba<100
                wincolor=[this.cyan 100]; %255= full opacity, 0= full transparency
                Screen('FillRect',this.window,wincolor,rightTextRect);
                vbl=Screen('Flip',this.window,0,1);
                tirageEUR(this,proba,wincolor,1);
                WaitSecs(3);
                maxNLoop=60; nloop=0;
                while nloop<maxNLoop
                    result=tirageEUR(this,proba,wincolor);
                    nloop=nloop+1;
                    WaitSecs(0.02);
                end
                bottomTextMargins=[0.7 0.75 0.8];
            elseif proba==100
                result=1;
            else
                result=0;
            end
            gainEurSup=result*gainSupToWin;
            totalGain=gainFixe+gainEurSup;
            textwin='Vous n''avez pas gagné'; 
            if result; textwin='Vous avez gagné'; end;
            textwin=[textwin ' les ' mat2str(gainSupToWin) ' euros supplémentaires.'];
            this.marginText(textwin,'center',bottomTextMargins(1),round(this.fontsize*0.6));
			txtHL=''; hlgain=0;
			if exist('HLGain.trg','file');
                hlgain=dlmread('HLGain.trg'); txtHL=['Vous avez gagné '  mat2str(hlgain) ' euros dans la loterie. ' ];
                this.marginText(txtHL,'center',bottomTextMargins(2),round(this.fontsize*0.6));
            end;
			totalGain=totalGain+hlgain;
            this.marginText(['Votre gain total est donc égal à ' mat2str(totalGain) ' euros.'],'center',bottomTextMargins(3),round(this.fontsize*0.6));
            Screen('Flip',this.window,0,1);
            tenPercInfo=[gain compGain rndStartRound gain10Perc compGain10Perc];
            WaitSecs(2);
end
function [gamePayed gain]=tirage(this,gameRealWallets,bh,bhRect,nopay,gain10perc,tenPercPer)
            if nargin<6; gain10perc=0; end;
            if nargin<7; tenPercPer=0; end;
            Screen('Flip',this.window);
            %headerRect=ScaleRect(this.rect,1,this.headerPercent);
            %Screen('FillRect',this.window,this.gray,headerRect);
            %this.drawBottom(1);
            Screen('DrawTexture', this.window, bh, [], bhRect);
            rect2=[];
            nGamesTotal=length(gameRealWallets);
            if(this.useTenPercGain); nGamesTotal=1; end;
            randomVec=randperm(nGamesTotal);
            gamePayed=randomVec(1);
            if nopay; gamePayed=0; end; 
            for i=1:nGamesTotal
                gainToShow=gameRealWallets(i);
                if(this.useTenPercGain); gainToShow=gain10perc; end;
                rect2=this.showPointsLine({['Jeu n° ' mat2str(i)] gainToShow},bhRect,rect2,0,'wallet');
                rect2in=InsetRect(rect2,RectWidth(rect2)*0.01,0);
                if i==gamePayed && ~nopay; Screen('FrameRect', this.window,this.black,rect2in); end;
            end
            if ~nopay; gain=gameRealWallets(gamePayed); end;
            if nGamesTotal>1;
                this.marginText(['Ci-dessous le récapitulatif de vos gains dans les ' mat2str(nGamesTotal) ' jeux :'],'center',0.21,round(this.fontsize*0.7));
            else
                this.marginText(['Ci-dessous le récapitulatif de vos gains '],'center',0.17,round(this.fontsize*0.7));
                this.marginText(['dans les ' mat2str(tenPercPer) ' manches du jeu tirées au hasard  :'],'center',0.21,round(this.fontsize*0.7));
                if ~nopay && this.useTenPercGain; gain=gameRealWallets(end); end;
            end
                
end

function result=tirageEUR(this,proba,wincolor,noline)
            if nargin<4; noline=0; end;
            rectsize=RectWidth(this.rect)*0.2;
            ballrect=[0 0 rectsize rectsize];
            ballrect=CenterRect(ballrect,this.rect);
            arcangle=proba*360/100;
            if noline
                startangle=0;
            else
                startangle=rand(1)*360;
            end
            Screen('FillRect',this.window,this.white,ballrect);
            Screen('FillArc',this.window,wincolor,ballrect,startangle,arcangle);
            Screen('FrameArc',this.window,this.black,ballrect,0,360, 2);
            if ~noline; Screen('DrawLine', this.window ,[255 0 0], (ballrect(1)+ballrect(3))/2, (ballrect(2)+ballrect(4))/2, (ballrect(1)+ballrect(3))/2, ballrect(2)-RectHeight(ballrect)*0.1, 2); end;
            Screen('Flip',this.window,0,1);
            if startangle==0 || startangle+arcangle>=360; result=1; else result=0; end;
end
