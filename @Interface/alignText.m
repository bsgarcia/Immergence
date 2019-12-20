function textrect=alignText(this,text,rect,textsize,color,pos1,pos2)
            if nargin<7
                pos2=[];
            end
            if nargin<6
                pos1='center';
            end
            if nargin<5
                color=this.black;
            end
            if nargin<4
                textsize=this.fontsize;
            end
            %textrect=rect; %return;
            oldsize=Screen('TextSize', this.window , textsize);
            [textrect, z]= Screen('TextBounds', this.window, text);
            textrect=CenterRect(textrect,rect); 
            if isempty(pos2)
                textrect=AlignRect(textrect,rect,pos1);
            else
                textrect=AlignRect(textrect,rect,pos1,pos2);
            end
            %Screen('DrawText',this.window, text, textrect(1),textrect(2),color);
            DrawFormattedText(this.window, text, textrect(1),textrect(2),color);
            Screen('TextSize', this.window , oldsize);
end