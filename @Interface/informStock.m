function  informRect=informStock(this,mygood)
%informs the subject about his stock
if nargin<2; mygood=this.myGoodColor; end;
Screen('FillRect',this.window, this.white);
            stateWidth=RectWidth(this.rect)*0.65; stateHeight=RectHeight(this.rect)*0.25;
            stateRect=[0 0 stateWidth stateHeight]; stateRect=CenterRect(stateRect,this.rect);
            elemRectWidth=stateWidth/5; elemRect=[0 0 elemRectWidth stateHeight];
            elemLeftRect=AlignRect(elemRect,stateRect,'center','left'); %elemRightRect=AlignRect(elemRect,stateRect,'center','right');
            %rect1=this.drawSellerPicture(elemLeftRect,this.myGoodColor,this.type,0,offset);
%rH=RectHeight(this.rect)*0.4; rW=rH*0.7;
%informRect=[0 0 rW rH]; informRect=CenterRect(informRect,this.rect);
informRect=elemLeftRect; %new feature
this.drawSellerPicture(informRect,mygood);
%DrawText(this.window,'Votre bien en stock','lmtttttttc',0);
%this.marginText('Votre bien en stock',0.045,0.045);
Screen('Flip',this.window);
%WaitSecs(0.5);
end

