function  cadre=cadreColor(this,type)
            color=this.findColor(type);
            if(strcmp(type,'black'))
                color=this.black;
            end
            cadre=this.setVisibleColor(this.Images.cadre,color);
end