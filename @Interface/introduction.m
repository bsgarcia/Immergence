function introduction(this)
            %shows introduction%
            this.resetScreen();
            this.alignText('Jeu d''échange',this.rect,round(this.fontsize*1.7));
            %Screen('Flip',this.window,0,0);
            %if this.alreadyLaunched; Screen('Flip', this.window); end;
            Screen('Flip', this.window);
            WaitSecs(3);
            %this.waitKeyPress();
            if ~this.alreadyLaunched; this.resetScreen(); end;
            waitframes=76;%50
            ifi = Screen('GetFlipInterval', this.window);
            %this.alreadyLaunched=0;
            %etape 2:
            montype=this.findColor(this.type,1); bienproduit=this.findColor(Player.goodProduced(this.type),1);
            %this.marginText(['Vous êtes un joueur ' montype],0.045,0.045,round(this.fontsize*1.2));
            eval(strcat('bh=this.Images.bh',this.type,';'));
            rH=RectHeight(this.rect)*0.4; rW=rH*0.4;
            bhRect=[0 0 rW rH]; bhRect=CenterRect(bhRect,this.rect);
            %Screen('DrawTexture', this.window, bh, [], bhRect);
            %Screen('Flip',this.window,0,0);
            %this.waitKeyPress();
            %etape 3 (Implications):
            rH=RectHeight(this.rect)*0.58; rW=rH*0.39; bhRect=[0 0 rW rH]; 
            %bhRect=OffsetRect(bhRect,-rW*0.4,rH*0.05);
            bhRect=OffsetRect(bhRect,rW*0.1,rH*0.35);
            Screen('DrawTexture', this.window, bh, [], bhRect);
            headerRect=ScaleRect(this.rect,1,this.headerPercent);
            Screen('FillRect',this.window,this.white,headerRect);
            this.marginText(['Vous êtes un joueur ' montype],0.03,'center',round(this.fontsize*1.3),this.black,headerRect); %"Implications" and this.gray before
            vbl=Screen('Flip',this.window,0,1);
            %tic
            %vbl=Screen('Flip',this.window,vbl + (waitframes-0.5)*ifi,1);
            normalTextSize=round(this.fontsize*0.55); pointsSize=this.fontsize;
            whiteRect=[0 0 0 0];
            whiteRect(RectLeft)=bhRect(RectRight);whiteRect(RectTop)=headerRect(RectBottom)+RectWidth(this.rect)*0.05; 
            whiteRect(RectRight)=this.rect(RectRight);whiteRect(RectBottom)=this.rect(RectBottom)-RectWidth(this.rect)*this.headerPercent*1.3;
            %this.marginText('L’expérience est divisée en jeux, chaque jeu est divisé en rounds.',-0.07,'top',normalTextSize,this.cyan,whiteRect);
            cPosit=0.2; step=0.2;
            endownmRect=this.marginText('Vous débutez chaque jeu avec 100 points',0.02,cPosit,normalTextSize,this.black,whiteRect);
            endownmRect=this.adjoinImage(endownmRect,'wallet');
            endownmRect=this.adjoinText(sprintf(' %d',this.wallet),endownmRect,'center',this.orange,pointsSize);
            this.adjoinText(' points',endownmRect,'center',this.black,normalTextSize);
            vbl=Screen('Flip',this.window,vbl + (waitframes-0.5)*ifi,1);
            cPosit=cPosit+step;
            productRect=this.marginText(['Vous produisez le bien ' bienproduit],0.02,cPosit,normalTextSize,this.cyan,whiteRect);
            this.adjoinImage(productRect,Player.goodProduced(this.type));
            vbl=Screen('Flip',this.window,vbl + (waitframes-0.5)*ifi,1);
            if Player.productionCost>0
                cPosit=cPosit+step;
                productRect=this.marginText('Produire un bien coûte des points',0.02,cPosit,normalTextSize,this.black,whiteRect);
                productRect=this.adjoinImage(productRect,Player.goodProduced(this.type));
                productRect=this.adjoinText(' -',productRect,'center',this.black,pointsSize);
                productRect=this.adjoinText(sprintf('%d',Player.productionCost),productRect,'center',this.orange,pointsSize);
                this.adjoinText(' points',productRect,'center',this.black,normalTextSize);
                vbl=Screen('Flip',this.window,vbl + (waitframes-0.5)*ifi,1);
            end
            cPosit=cPosit+step;
            consumeRect=this.marginText(['Obtenir le bien ' montype ' vous rapporte des points'],0.02,cPosit,normalTextSize,this.black,whiteRect);
            consumeRect=this.adjoinImage(consumeRect,this.type);
            consumeRect=this.adjoinText(' +',consumeRect,'center',this.black,pointsSize);
            consumeRect=this.adjoinText(sprintf('%d',this.utility),consumeRect,'center',this.orange,pointsSize);
            this.adjoinText(' points',consumeRect,'center',this.black,normalTextSize);
            vbl=Screen('Flip',this.window,vbl + (waitframes-0.5)*ifi,1);
            if(~Player.noStockCost)
                cPosit=cPosit+1.5*step;%+0.7;
                this.marginText('Stocker un bien d’un round à l’autre coûte des points',0.02,cPosit,normalTextSize,this.cyan,whiteRect);
                this.drawBottom(0,1);
                vbl=Screen('Flip',this.window,vbl + (waitframes-0.5)*ifi,1);
            end
            %Screen('Flip',this.window,0,0);
            WaitSecs(this.introductionWaitTime);
            %toc
            %this.waitKeyPress();
end

            