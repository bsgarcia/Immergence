function goodRect=drawSellerPicture(this,rect,good,type,opposite,offsetBall)
            if nargin<6
                offsetBall=0;
            end
            if nargin<5
                opposite=0;
            end
            if nargin<4
                type=this.type;
            end
            if nargin<3
                good=this.myGoodColor;
            end
            if nargin<2
                rect=this.rect;
            end
            utype=type; %utype(1)=upper(utype(1));
            eval(strcat('bh=this.Images.bh',type,';'));
            eval(strcat('cadre=this.Images.cadre',type,';'));
            %bh=this.bhColor(type);
            goodColor=this.findColor(good);
            %cadre=this.cadreColor(type);
            %cadre=this.Images.cadre;
            shrinkSize=RectWidth(rect)*0.05; cadreRect=InsetRect(rect,shrinkSize,shrinkSize); goodWidth=RectWidth(cadreRect)*0.5;
            tempBhRect=ScaleRect(rect,0.5,0.90); tempGoodRect=[0 0 goodWidth goodWidth];
            bhRect=AlignRect(tempBhRect,cadreRect,'center','left'); goodRect=AlignRect(tempGoodRect,cadreRect,'right','bottom');
            if opposite
                bhRect=AlignRect(tempBhRect,cadreRect,'center','right'); goodRect=AlignRect(tempGoodRect,cadreRect,'left','bottom');
            end
            if offsetBall~=0
                goodRect=OffsetRect(goodRect,offsetBall,0);
            end
            %Screen('DrawTexture', this.window, cadre, [], rect); Screen('DrawTexture', this.window, bh, [], bhRect);
            Screen('DrawTextures', this.window, [cadre bh], [], [rect;bhRect]');
            Screen('FillArc',this.window,goodColor,goodRect,0,360);
end