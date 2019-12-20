function askRect=drawAskButtons(this,choosen,notext,noimage)
            if nargin<2
                choosen='';
            end
            if nargin<3
                notext=0;
            end
            if nargin<4
                noimage=0;
            end
            askRect=[RectWidth(this.rect)*0.3 RectHeight(this.rect)*0.7 RectWidth(this.rect)*0.7 RectHeight(this.rect)*0.8];
            askHeight=RectHeight(askRect);
            noRect=[askRect(1) askRect(2) askRect(1)+askHeight askRect(2)+askHeight];
            yesRect=[askRect(3)-askHeight askRect(2) askRect(3) askRect(4)];
			if ~noimage
				Screen('DrawTexture', this.window, this.Images.yes, [], yesRect);
				Screen('DrawTexture', this.window, this.Images.no, [], noRect);
			end
            yesColor=this.black;
            noColor=this.black;
            switch choosen
                case {0,'no'}
                    noColor=this.orange;
                case {1,'yes'}
                        yesColor=this.orange;
                otherwise
            end
            if ~notext
                this.adjoinText(' Non',noRect,'center',noColor);%,textsize,RectSize
                this.adjoinText('Oui ',yesRect,'center',yesColor,this.fontsize,RectLeft);
            end
end