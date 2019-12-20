function textrect=marginText(this,text,marginLeft,marginTop,textsize,color,rect)
            if nargin<7
                rect=this.rect;
            end
            if nargin<6
                color=this.black;
            end
            if nargin<5
               textsize=this.fontsize;
            end
            if nargin<4
                marginTop=0;
            end
            if nargin<3
                marginLeft=0;
            end
            %textrect=rect; %return;
            oldsize=Screen('TextSize', this.window , textsize);
            [textrect, z]= Screen('TextBounds', this.window, text);
            if (ischar(marginLeft) && strcmp(marginLeft,'center')) || (ischar(marginTop) && strcmp(marginTop,'center'))
                textrect=CenterRect(textrect,rect);
            elseif ischar(marginLeft) && ~ischar(marginTop); textrect=AlignRect(textrect,rect,marginLeft);
            elseif ~ischar(marginLeft) && ischar(marginTop); textrect=AlignRect(textrect,rect,marginTop);
            elseif  ischar(marginLeft) && ischar(marginTop); textrect=AlignRect(textrect,rect,marginLeft,marginTop); 
            end
            if ~ischar(marginLeft)
                textrect=AlignRect(textrect,rect,'left');
                textrect=OffsetRect(textrect,marginLeft*RectWidth(rect),0);
            end
            if ~ischar(marginTop)
                textrect=AlignRect(textrect,rect,'top');
                textrect=OffsetRect(textrect,0,marginTop*RectHeight(rect));
            end
            [cx,cy]=RectCenter(textrect);
            %Screen('DrawText',this.window, text, textrect(1),textrect(2),color);
            DrawFormattedText(this.window, text, textrect(1),cy,color);
            Screen('TextSize', this.window , oldsize);
end