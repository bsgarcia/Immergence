function newrect=drawProportion(this,rect,playersProportions,type)
            if nargin<4
                type=this.type;
            end
            onlyRect=0;
            if nargin<3
                onlyRect=1;
            end
            utype=type; %utype(1)=upper(utype(1));
            eval(strcat('bh=this.Images.bh',type,';'));
            %bh=this.bhColor(type);
            tempBhRect=ScaleRect(rect,0.4,0.85); bhRect=AlignRect(tempBhRect,rect,'bottom','left');
            bhRect=OffsetRect(bhRect,-RectWidth(bhRect)*0.4,0);
            Screen('DrawTexture', this.window, bh, [], bhRect);
            leftpos=bhRect(1);
            goodWidth=RectHeight(bhRect)*1.2; goodRect=[0 0 goodWidth goodWidth]; goodRect=AlignRect(goodRect,rect,'bottom','right');
            goodRect=OffsetRect(goodRect,goodWidth*.57,goodWidth*.3);
            shrinkFactor=0.03; %0.05
            for i=1:3
                shrinkWidth=RectWidth(bhRect)*shrinkFactor; shrinkHeight=RectHeight(bhRect)*shrinkFactor;
                tempBhRect=InsetRect(bhRect,shrinkWidth,shrinkHeight); tempBhRect=AlignRect(tempBhRect,bhRect,'bottom','left');
                bhRect=OffsetRect(tempBhRect,RectWidth(bhRect)*0.30,-RectHeight(bhRect)*0.05); %0.7, 0.05
                Screen('DrawTexture', this.window, bh, [], bhRect);
            end
            toppos=bhRect(RectTop);
            rightpos=goodRect(RectRight);
            newrect=[leftpos toppos rightpos goodRect(4)];
            if onlyRect
                return;
            end
            startangle=0;
            for t=1:length(this.possibleColors)
                ccolor=this.possibleColors{t};
                goodColor=this.findColor(ccolor);
                utype=type; utype(1)=upper(utype(1));
                uccolor=ccolor; uccolor(1)=upper(uccolor(1));
                eval(strcat('cprop=playersProportions.g',uccolor,';'));
                arcangle=cprop*360;
                Screen('FillArc',this.window,goodColor,goodRect,startangle,arcangle);
                startangle=startangle+arcangle;
            end
            Screen('DrawArc',this.window,200,goodRect,0,360);
        end