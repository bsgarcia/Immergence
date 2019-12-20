function informPartnersAnswer(this,othertype,othergood,partnersAnswer,myWill)
            %this.partialResetScreen();
            %tic
            if ~this.alreadyLaunched; this.partialResetScreen(); end;
            this.alreadyLaunched=1;
            waittime=2;
            if myWill
            switch partnersAnswer
                case {0,'no','non'}
                    textAnswer='L’autre joueur ne souhaite pas réaliser l’échange'; textcolor=this.black;
                otherwise
                    textAnswer='L’autre joueur souhaite aussi réaliser l’échange'; textcolor=this.orange;
                    prevtime=this.currentMeasureTime;
                    if prevtime==0; prevtime=0.93; end;
                    waittime=waittime-prevtime;
                    this.currentMeasureTime=0;
            end
            else
                textAnswer='Vous ne réalisez pas l’échange'; textcolor=this.black;
            end
            %oldsize=Screen('TextSize', this.window , round(this.fontsize*0.9));
            %DrawText(this.window,textAnswer,'mt',textcolor);
            this.marginText(textAnswer,'center',0.2,round(this.fontsize*0.9),textcolor);
            %Screen('TextSize', this.window , oldsize);
            this.drawExchangePicture(this.type,this.myGoodColor,othertype,othergood);
            if this.useHeader; this.drawHeader(); end;
            if this.useBottom; this.drawBottom(1); end;
            %this.drawHeader; this.drawBottom(1); %this.drawBottom(1) for simple bottom; %this.drawBottom or this.drawBottom(0) for "hint" bottom;
            Screen('Flip', this.window);
            WaitSecs(waittime);
            %toc
end