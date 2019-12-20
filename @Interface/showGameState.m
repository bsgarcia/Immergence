function [rep time]=showGameState(this,Proportion)
            startSecs=GetSecs();
            this.resetScreen();
            if this.useHeader; this.drawHeader(); end;
            if this.useBottom; this.drawBottom(); end;
            stateWidth=RectWidth(this.rect); stateHeight=RectHeight(this.rect)*0.20;
            stateRect=[0 0 stateWidth stateHeight]; stateRect=CenterRect(stateRect,this.rect);
            stateRect=OffsetRect(stateRect,0,-RectHeight(stateRect)*0.15);
            elemStateW=stateWidth/5; elemStateW=stateHeight*0.8; elemInterval=stateWidth*0.10;
            elemStateRect=[0 0 elemStateW elemStateW]; elemStateRect=AlignRect(elemStateRect,stateRect,'bottom','left'); newelemStateRect=elemStateRect;
            unionRect=OffsetRect(newelemStateRect,elemInterval,0);
            for i=1:length(this.possibleTypes)
                if i>1
                    newelemStateRect=[0 0 elemStateW elemStateW]; newelemStateRect=AlignRect(newelemStateRect,stateRect,'bottom','left'); 
                    newelemStateRect=AdjoinRect(newelemStateRect,elemStateRect,RectRight);
                end
                newelemStateRect=OffsetRect(newelemStateRect,elemInterval,0);
                type=this.possibleTypes{i}; utype=type; utype(1)=upper(utype(1));
                eval(strcat('playersProportions=Proportion.p',utype,';'));
                elemStateRect=this.drawProportion(newelemStateRect,playersProportions,type);
                unionRect=UnionRect(unionRect,elemStateRect);
            end
            oldsize=Screen('TextSize', this.window , round(this.size(1)/30));
            DrawText(this.window,'Etat du jeu','lcctm',0);
            Screen('TextSize', this.window , oldsize);
            vtextrect=this.adjoinText('Proportion de biens en stock chez chaque type de joueur',unionRect,'center',this.black,round(this.fontsize*0.6),RectBottom);
            %Screen('Flip',this.window);
            if ~this.alreadyLaunchedGameState; Screen('Flip', this.window); end;
            this.alreadyLaunchedGameState=1;
            
            
            
            if(~this.useIntervalEverythere)
                if this.alreadyLaunched; Screen('Flip', this.window); end;
                this.alreadyLaunched=1;
                %WaitSecs(0.5);
                codes=[this.leftCode this.rightCode];
                if(this.spacesAtInfoScreen); codes=this.spaceCode; end;
                [key time]=this.waitKeyPress(Inf,codes);
                this.alreadyLaunched=1;
            	this.waitKeyRelease(0.3,codes);
            	rep=key;
            else
                Screen('Flip',this.window);
                WaitSecs(2);
                time=GetSecs()-startSecs;
                rep='';
            end
end