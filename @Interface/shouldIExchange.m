function answer=shouldIExchange(this,othertype,othergood,Proportion,Pl,R)
            if nargin<6; R=struct; end;
            if nargin<5; Pl=struct; end;
            if this.nRound==1 && (~this.lastGame || this.nGame>1)
                waitsecs=3;
                this.resetScreen();
                this.alignText(['Manche ',mat2str(this.nGame)],this.rect,round(this.fontsize*1.7)); %Manche ou Jeu ?
                if this.nGame>1
                    %waitsecs=2.5;
                    this.marginText('Les biens et les points sont réinitialisés.','center',0.7,round(this.fontsize*0.8));
                end
                Screen('Flip',this.window,0,0);
                WaitSecs(waitsecs);
                %this.informStock;
                %WaitSecs(2);
            end
            this.resetScreen();
            texttoshow=['Round ',mat2str(this.nRound)];
            if(this.plusInsteadOfRound); texttoshow='+'; end;
            this.alignText(texttoshow,this.rect,round(this.fontsize*1.7)); %['Round ',mat2str(this.nRound)] or '+'
            if 1; Screen('Flip',this.window,0,0); end; %this.alreadyLaunched
            debPlusInfoWaited=0;
            if(this.debPlusWaitSec~=0); debPlusInfoWaited=GetSecs()-this.debPlusWaitSec; end;
            secsToWait=1.5-debPlusInfoWaited;
            if(secsToWait>0); WaitSecs(secsToWait); end;
            this.debPlusWaitSec=0;
			if this.informGameState
				[gameStateKey gameStateTime]=this.showGameState(Proportion);
			else
				gameStateKey=-1; gameStateTime=0;
			end
			if this.showRandomOtherPair
				codes=[this.leftCode this.rightCode];
                if(this.spacesAtInfoScreen); codes=this.spaceCode; end;
                this.resetScreen();
                this.marginText(['Vous allez voir le choix d''un autre joueur tiré au sort'],'center',0.45,round(this.fontsize)); %Manche ou Jeu ?
				this.marginText('Vous n''aurez donc pas de choix à faire','center',0.55,round(this.fontsize*0.8));
                Screen('Flip',this.window,0,0);
				this.alreadyLaunched=1;
				WaitSecs(1);
                [key time]=this.waitKeyPress(2,codes);
				this.demonstrateRandomOtherChoice(R,Pl);
                this.resetScreen();
                this.alignText(['Maintenant, c''est à vous de faire le choix'],this.rect,round(this.fontsize)); %Manche ou Jeu ?
                Screen('Flip',this.window,0,0);
				WaitSecs(1);
                [key time]=this.waitKeyPress(2,codes);
				
			end
            Pl.proportionKey=gameStateKey; Pl.proportionReactionTime=gameStateTime;
            answer=-1;
            nloop=0;
            startWillTime=GetSecs;
            while answer==-1
                [rep time]=this.askForExchange(othertype,othergood);
                %[confirm ctime]=this.askForExchange(othertype,othergood,rep);
                confirm=1; ctime=0;
                if nloop==0
                    Pl.firstWillToExchange=rep; Pl.firstWillReactionTime=time; Pl.firstWillConfirmReactionTime=ctime;
                end
                Pl.willReactionTime=time; Pl.willConfirmReactionTime=ctime; Pl.nWillChanged=nloop;
                if(isnan(rep)); rep=0; Pl.nWillChanged=-1; end;
                if(confirm)
                    answer=rep;
                end
                nloop=nloop+1;
            end
            endWillTime=GetSecs; Pl.overallWillTime=endWillTime-startWillTime;
end